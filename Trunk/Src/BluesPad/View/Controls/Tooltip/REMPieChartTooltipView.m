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

#define kPieTooltipHighlightFrame CGRectMake((kDMChart_TooltipContentWidth - kDMChart_TooltipItemWidth) / 2, 0, kDMChart_TooltipItemWidth, kDMChart_TooltipViewHeight)


@interface REMPieChartTooltipView ()

@property (nonatomic) int highlightIndex;

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
        [self renderItems];
    }
    
    return self;
}

- (NSArray *)convertItemModels
{
    self.highlightIndex = [self decideHighlightIndex];
    NSLog(@"highlight index: %d", self.highlightIndex);
    NSMutableArray *itemModels = [[NSMutableArray alloc] init];
    
    for(int i=0;i<self.data.targetEnergyData.count;i++){
        REMTargetEnergyData *targetData = self.data.targetEnergyData[i];
        
        REMChartTooltipItemModel *model = [[REMChartTooltipItemModel alloc] init];
        model.title = [self formatTargetName:targetData.target];
        model.value = REMIsNilOrNull(targetData.energyData[0]) ? nil : [targetData.energyData[0] dataValue];
        model.color = [REMColor colorByIndex:i].uiColor;
        model.index = i;
        model.type = REMChartSeriesIndicatorPie;
        
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

- (void)updateHighlightedData:(NSArray *)data
{
    self.highlightedPoints = data;
    int newHighlightIndex = [self decideHighlightIndex];
    int offset = self.highlightIndex - newHighlightIndex;
    
    NSLog(@"Now highlight index is %d, offset: %d", newHighlightIndex, offset);
    
    self.highlightIndex = newHighlightIndex;
    
    for(UIView *subview in self.scrollView.subviews){
        [subview removeFromSuperview];
    }
    
    [self renderItems];
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


-(NSString *)formatTargetName:(REMEnergyTargetModel *)target
{
    return [REMTextIndicatorFormator formatTargetName:target withWidget:self.widget andParameters:self.parameters];
}

//-(void)renderItems
//{
//    int itemCount = self.itemModels.count, index = self.highlightIndex;
//    
//    
//    
//}

-(void)renderItems
{
    int itemCount = self.itemModels.count;
    
    CGFloat baseX = kPieTooltipHighlightFrame.origin.x;
    int index = self.highlightIndex;
    
    CGFloat itemOffset = kMDChart_TooltipItemLeftOffset;
    CGFloat itemWidth = kDMChart_TooltipItemWidth;
    CGFloat contentWidth = (itemWidth + itemOffset) * itemCount - kDMChart_TooltipCloseViewWidth;
    
    
    if(contentWidth < kDMChart_TooltipContentWidth){
        itemOffset = itemCount == 1 ? 0 : (kDMChart_TooltipContentWidth - kDMChart_TooltipCloseViewWidth - (itemCount * itemWidth)) / (itemCount - 1);
        contentWidth = kDMChart_TooltipContentWidth - kDMChart_TooltipCloseViewWidth;
    }
    
    for(int i=0;i<itemCount;i++){
        CGRect itemFrame = CGRectMake((i - index)*(itemWidth + itemOffset) + baseX,0,itemWidth,kDMChart_TooltipContentHeight);
        
        REMChartTooltipItem *tooltipItem = [REMChartTooltipItem itemWithFrame:itemFrame andModel:self.itemModels[i]];
        
        if(i==index){
            tooltipItem.backgroundColor = [REMColor colorByHexString:kDMChart_TooltipViewBackgroundColor];
            
            tooltipItem.frame = CGRectMake((i - index)*(itemWidth + itemOffset) + baseX,5,itemWidth,kDMChart_TooltipContentHeight-10);
            
            tooltipItem.layer.shadowColor = [UIColor blackColor].CGColor;
            tooltipItem.layer.shadowOffset = CGSizeMake(0, 0);
            tooltipItem.layer.shadowOpacity = 0.4;
            tooltipItem.layer.shadowRadius = 3.0;
        }
        
        [self.scrollView addSubview:tooltipItem];
    }
}

-(UIView *)renderPointerView
{
    UIView *view = [[UIView alloc] initWithFrame:kPieTooltipHighlightFrame];
    view.layer.borderColor = [UIColor purpleColor].CGColor;
    view.layer.borderWidth = 1.0;
    view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    
    return view;
}

- (void)update:(id)highlightIndex
{
    int offset = self.highlightIndex - [highlightIndex intValue];
    NSLog(@"Now highlight index is %d, offset: %d", [highlightIndex intValue], offset);
    
    self.highlightIndex = [highlightIndex intValue];
    
    for(UIView *subview in self.scrollView.subviews){
        [subview removeFromSuperview];
    }
    
    [self renderItems];
}

@end
