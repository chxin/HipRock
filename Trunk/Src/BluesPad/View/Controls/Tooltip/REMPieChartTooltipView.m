/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMPieChartTooltipView.m
 * Date Created : 张 锋 on 11/8/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/

#import <QuartzCore/QuartzCore.h>
#import "REMPieChartTooltipView.h"
#import "REMCommonHeaders.h"
#import "REMDimensions.h"
#import "REMChartTooltipItem.h"
#import "REMTextIndicatorFormator.h"

#define kPieTooltipItemBaseLeft (kDMChart_TooltipContentWidth - kDMChart_TooltipItemWidth) / 2
#define REMPieTooltipItemFrame(i) CGRectMake(kPieTooltipItemBaseLeft + (i)*(kDMChart_TooltipItemWidth + kMDChart_TooltipItemLeftOffset), 0, kDMChart_TooltipItemWidth, kDMChart_TooltipContentHeight)




@interface REMPieChartTooltipView ()

@property (nonatomic) int highlightIndex;
@property (nonatomic,weak) REMChartTooltipItem *centerItem;

@end


@implementation REMPieChartTooltipView

/* Who has pie chart?
 * Common tags pie chart
 * Time slices pie chart
 * Carbon total and single commodities
 * Cost total and single commodities
 */


-(REMTooltipViewBase *)initWithHighlightedPoints:(NSArray *)points inEnergyData:(REMEnergyViewData *)data widget:(REMWidgetObject *)widget andParameters:(REMWidgetSearchModelBase *)parameters
{
    self = [super initWithHighlightedPoints:points inEnergyData:data widget:widget andParameters:parameters];
    
    if(self){
        [self renderItems2];
    }
    
    return self;
}

- (NSArray *)convertItemModels
{
    self.highlightIndex = [self decideHighlightIndex];
    //NSLog(@"highlight index: %d", self.highlightIndex);
    NSMutableArray *itemModels = [[NSMutableArray alloc] init];
    
    for(int i=0;i<self.data.targetEnergyData.count;i++){
        REMTargetEnergyData *targetData = self.data.targetEnergyData[i];
        
        REMChartTooltipItemModel *model = [[REMChartTooltipItemModel alloc] init];
        model.title = [self formatTargetName:targetData.target];
        model.value = REMIsNilOrNull(targetData.energyData[0]) ? nil : [targetData.energyData[0] dataValue];
        model.color = [REMColor colorByIndex:i].uiColor;
        model.index = i;
        
        if(REMIsNilOrNull(targetData.target.uomName)){
            model.uom = REMUoms[@(targetData.target.uomId)];
        }
        else{
            model.uom = targetData.target.uomName;
        }
        
        [itemModels addObject:model];
    }
    
    return itemModels;
}

-(UIScrollView *)renderScrollView
{
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDMChart_TooltipContentWidth-kDMChart_TooltipCloseViewWidth, kDMChart_TooltipContentHeight)];
    
    view.pagingEnabled = NO;
    view.showsHorizontalScrollIndicator = NO;
    view.showsVerticalScrollIndicator = NO;
    view.clipsToBounds = YES;
    view.scrollEnabled = NO;
    view.backgroundColor = [UIColor clearColor];
    
    int itemCount = self.itemModels.count;
    
    CGFloat contentWidth = (kDMChart_TooltipItemWidth + kMDChart_TooltipItemLeftOffset) * itemCount;
    
    if(contentWidth < view.bounds.size.width){
        contentWidth = kDMChart_TooltipContentWidth;
    }
    
    view.contentSize = CGSizeMake(contentWidth+kDMChart_TooltipCloseViewWidth, kDMChart_TooltipContentHeight);
    
    return view;
}


- (void)updateHighlightedData:(NSArray *)data fromDirection:(REMDirection)direction;
{
    int itemCount = self.itemModels.count;
    if(itemCount<=1) //2,3
        return;
    
    self.highlightedPoints = data;
    int oldIndex = self.highlightIndex;
    int newIndex = [self decideHighlightIndex];
    self.highlightIndex = newIndex;
    
    int indexOffset = newIndex - oldIndex, clockwise = 0;
    if(indexOffset == 1 || indexOffset == -(itemCount-1))
        clockwise = 1;
    else if(indexOffset == -1 || indexOffset == itemCount-1)
        clockwise = -1;
    
    int offset = itemCount == 2 ? -direction : clockwise;
    //NSLog(@"clockwise: %d",clockwise);
    
    
    if(offset == 0)
        return;
    
    if(itemCount<=3){
        int itemLeftOffset = (kDMChart_TooltipContentWidth - (itemCount==2?kDMChart_TooltipCloseViewWidth:0) - itemCount * kDMChart_TooltipItemWidth) / 2;
        
        CGPoint destinationPoint = CGPointMake(offset*(itemLeftOffset + kDMChart_TooltipItemWidth), self.scrollView.contentOffset.y);
        
        self.scrollView.contentOffset = CGPointZero;
        [self updateCenterItemLightenStatus:NO];
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.scrollView.contentOffset = destinationPoint;
        } completion:^(BOOL finished) {
            for(UIView *subview in self.scrollView.subviews){
                [subview removeFromSuperview];
            }
            [self renderItems2];
        }];
    }
    else{
        //add an item at left or right
        int start = clockwise > 0 ? 3 : -4;
        int end = start + offset;
        for(int i=start; i<=end; clockwise>0 ? i++:i--){
            int arrayIndex = (2*offset + i + oldIndex) % offset;
            
            REMChartTooltipItem *tooltipItem = [REMChartTooltipItem itemWithFrame:REMPieTooltipItemFrame(i) andModel:self.itemModels[arrayIndex]];
            
            [self.scrollView addSubview:tooltipItem];
        }
        
        //scroll one item toward left or right direction, when finish, re-render items
        CGPoint destinationPoint = CGPointMake(self.scrollView.contentOffset.x + offset * (kDMChart_TooltipItemWidth + kMDChart_TooltipItemLeftOffset), self.scrollView.contentOffset.y);
        
        self.scrollView.contentOffset = CGPointZero;
        [self updateCenterItemLightenStatus:NO];
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.scrollView.contentOffset = destinationPoint;
        } completion:^(BOOL finished) {
            for(UIView *subview in self.scrollView.subviews){
                [subview removeFromSuperview];
            }
            [self renderItems2];
        }];
    }
}


-(void)renderItems2
{
    self.scrollView.contentOffset = CGPointMake(0, 0);
    
    int itemCount = self.itemModels.count, highlightIndex = self.highlightIndex;
    
    if(itemCount <= 0){
        return;
    }
    
    if(itemCount == 1){
        REMChartTooltipItem *tooltipItem = [REMChartTooltipItem itemWithFrame:REMPieTooltipItemFrame(0) andModel:self.itemModels[0]];
        
        self.centerItem = tooltipItem;
        [self.scrollView addSubview:tooltipItem];
    }
    else if(itemCount <= 3){ //3
        int itemLeftOffset = (kDMChart_TooltipContentWidth - (itemCount==2?kDMChart_TooltipCloseViewWidth:0) - itemCount * kDMChart_TooltipItemWidth) / 2;
        for(int i=-1;i<=1;i++){
            int arrayIndex = (10*itemCount + highlightIndex + i) % itemCount;
            
            CGRect itemFrame = CGRectMake(kPieTooltipItemBaseLeft + i*(kDMChart_TooltipItemWidth + itemLeftOffset), 0, kDMChart_TooltipItemWidth, kDMChart_TooltipViewHeight);
            REMChartTooltipItem *tooltipItem = [REMChartTooltipItem itemWithFrame:itemFrame andModel:self.itemModels[arrayIndex]];
            
            if(i==0)
                self.centerItem = tooltipItem;
            
            [self.scrollView addSubview:tooltipItem];
        }
    }
    else{ //>3
        for(int i=-3; i<3; i++){
            int arrayIndex = (itemCount + highlightIndex + i) % itemCount;
            
            REMChartTooltipItem *tooltipItem = [REMChartTooltipItem itemWithFrame:REMPieTooltipItemFrame(i) andModel:self.itemModels[arrayIndex]];
            
            if(i==0)
                self.centerItem = tooltipItem;
            
            [self.scrollView addSubview:tooltipItem];
        }
    }
    
    [self updateCenterItemLightenStatus:YES];
}

//-(void)renderItems
//{
//    int itemCount = self.itemModels.count;
//    
//    CGFloat baseX = kPieTooltipHighlightFrame.origin.x;
//    int index = self.highlightIndex;
//    
//    CGFloat itemOffset = kMDChart_TooltipItemLeftOffset;
//    CGFloat itemWidth = kDMChart_TooltipItemWidth;
//    CGFloat contentWidth = (itemWidth + itemOffset) * itemCount - kDMChart_TooltipCloseViewWidth;
//    
//    
//    if(contentWidth < kDMChart_TooltipContentWidth){
//        itemOffset = itemCount == 1 ? 0 : (kDMChart_TooltipContentWidth - kDMChart_TooltipCloseViewWidth - (itemCount * itemWidth)) / (itemCount - 1);
//        contentWidth = kDMChart_TooltipContentWidth - kDMChart_TooltipCloseViewWidth;
//    }
//    
//    for(int i=0;i<itemCount;i++){
//        CGRect itemFrame = CGRectMake((i - index)*(itemWidth + itemOffset) + baseX,0,itemWidth,kDMChart_TooltipContentHeight);
//        
//        REMChartTooltipItem *tooltipItem = [REMChartTooltipItem itemWithFrame:itemFrame andModel:self.itemModels[i]];
//        
//        if(i==index){
//            tooltipItem.backgroundColor = [REMColor colorByHexString:kDMChart_TooltipViewBackgroundColor];
//            
//            tooltipItem.frame = CGRectMake((i - index)*(itemWidth + itemOffset) + baseX,5,itemWidth,kDMChart_TooltipContentHeight-10);
//            
//            tooltipItem.layer.shadowColor = [UIColor blackColor].CGColor;
//            tooltipItem.layer.shadowOffset = CGSizeMake(0, 0);
//            tooltipItem.layer.shadowOpacity = 0.4;
//            tooltipItem.layer.shadowRadius = 3.0;
//        }
//        
//        [self.scrollView addSubview:tooltipItem];
//    }
//}


-(NSString *)formatTargetName:(REMEnergyTargetModel *)target
{
    return [REMTextIndicatorFormator formatTargetName:target withWidget:self.widget andParameters:self.parameters];
}

-(int)decideHighlightIndex
{
    if(self.highlightedPoints.count <=0)
        return 0;
    
    REMEnergyData *point = self.highlightedPoints[0];
    
    if(REMIsNilOrNull(point))
        return 0;
    
    for(int i=0;i<self.data.targetEnergyData.count;i++){
        REMTargetEnergyData *targetData = self.data.targetEnergyData[i];
        
        if([point isEqual:targetData.energyData[0]])
            return i;
    }
    
    return 0;
}

//-(UIView *)renderPointerView
//{
//    UIView *view = [[UIView alloc] initWithFrame:kPieTooltipHighlightFrame];
//    view.layer.borderColor = [UIColor purpleColor].CGColor;
//    view.layer.borderWidth = 1.0;
//    view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
//    
//    return view;
//}

-(void)updateCenterItemLightenStatus:(BOOL)isLighten
{
    if(self.centerItem == nil) return;
    
//    CGPoint point = self.centerItem.frame.origin;
//    CGSize size = self.centerItem.frame.size;
    
    if(isLighten){
//        self.centerItem.layer.borderColor = [UIColor purpleColor].CGColor;
//        self.centerItem.layer.borderWidth = 1.0;
//        self.centerItem.frame = CGRectMake(point.x, 5, size.width, size.height-10);
        self.centerItem.layer.shadowColor = [UIColor blackColor].CGColor;
        self.centerItem.layer.shadowOffset = CGSizeMake(0, 0);
        self.centerItem.layer.shadowOpacity = 0.4;
        self.centerItem.layer.shadowRadius = 3.0;
    }
    else{
//        self.centerItem.layer.borderColor = nil;
//        self.centerItem.layer.borderWidth = 0.0;
//        self.centerItem.frame = CGRectMake(point.x, 0, size.width, kDMChart_TooltipContentHeight);
        self.centerItem.layer.shadowColor = nil;
        self.centerItem.layer.shadowOffset = CGSizeMake(0, 0);
        self.centerItem.layer.shadowOpacity = 0;
        self.centerItem.layer.shadowRadius = 0;
    }
        
}

@end
