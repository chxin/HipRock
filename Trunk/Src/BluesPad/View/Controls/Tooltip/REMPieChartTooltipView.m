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

@property (nonatomic,strong) NSMutableArray *tooltipItems;
@property (nonatomic) int highlightIndex;

@end


@implementation REMPieChartTooltipView

/* Who has pie chart?
 * Common tags pie chart
 * Time slices pie chart
 * Carbon total and single commodities
 * Cost total and single commodities
 */

- (NSArray *)convertItemModels
{
    self.highlightIndex = [self decideHighlightIndex];
    NSMutableArray *itemModels = [[NSMutableArray alloc] init];
    
    for(int i=0;i<self.data.targetEnergyData.count;i++){
        REMTargetEnergyData *targetData = self.data.targetEnergyData[i];
        
        REMChartTooltipItemModel *model = [[REMChartTooltipItemModel alloc] init];
        model.title = [self formatTargetName:targetData.target];
        model.value = REMIsNilOrNull(targetData.energyData[0]) ? nil : [targetData.energyData[0] dataValue];
        model.color = [REMColor colorByIndex:i].uiColor;
        model.index = i;
        model.type = REMChartSeriesIndicatorPie;
        
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

-(UIScrollView *)renderScrollView:(NSArray *)itemModels
{
    self.tooltipItems = [[NSMutableArray alloc] init];
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDMChart_TooltipContentWidth, kDMChart_TooltipViewHeight)];
    
    view.pagingEnabled = NO;
    view.showsHorizontalScrollIndicator = NO;
    view.showsVerticalScrollIndicator = NO;
    view.clipsToBounds = YES;
    view.scrollEnabled = NO;
    //    view.backgroundColor = [UIColor redColor];
    
    int itemCount = self.data.targetEnergyData.count;
    
    CGFloat contentWidth = (kDMChart_TooltipItemWidth + kMDChart_TooltipItemLeftOffset) * itemCount;
    
    if(contentWidth < view.bounds.size.width){
        contentWidth = kDMChart_TooltipContentWidth;
    }
    
    view.contentSize = CGSizeMake(contentWidth+kDMChart_TooltipCloseViewWidth, kDMChart_TooltipViewHeight);
    
    

    
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

-(UIView *)pointerView
{
    return nil;
}

-(void)renderItems
{
    int itemCount = self.itemModels.count;
    
    CGFloat baseX = kPieTooltipHighlightFrame.origin.x;
    int index = self.highlightIndex;
    
    CGFloat itemOffset = kMDChart_TooltipItemLeftOffset;
    CGFloat itemWidth = kDMChart_TooltipItemWidth;
    CGFloat contentWidth = (itemWidth + itemOffset) * itemCount;
    
    
    if(contentWidth < kDMChart_TooltipContentWidth){
        itemOffset = itemCount == 1 ? 0 : (kDMChart_TooltipContentWidth - (itemCount * itemWidth)) / (itemCount - 1);
        contentWidth = kDMChart_TooltipContentWidth;
    }
    
    for(int i=0;i<itemCount;i++){
        CGRect itemFrame = CGRectMake((i - index)*(itemWidth + itemOffset) + baseX,0,itemWidth,kDMChart_TooltipViewHeight);
        
        REMChartTooltipItem *tooltipItem = [REMChartTooltipItem itemWithFrame:itemFrame andModel:self.itemModels[i]];
        
        [self.scrollView addSubview:tooltipItem];
        [self.tooltipItems addObject:tooltipItem];
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
