/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTooltipView.m
 * Date Created : 张 锋 on 11/7/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <QuartzCore/QuartzCore.h>
#import "REMTrendChartTooltipView.h"
#import "REMDimensions.h"
#import "REMChartTooltipItem.h"
#import "REMColor.h"
#import "REMCommonHeaders.h"
#import "REMImages.h"
#import "REMWidgetTagSearchModel.h"
#import "REMWidgetCommoditySearchModel.h"
#import "REMTextIndicatorFormator.h"


@interface REMTrendChartTooltipView()

@property (nonatomic,strong) NSMutableArray *tooltipItems;

@end

@implementation REMTrendChartTooltipView

/* Who has trend chart tooltip?
 * Common tags
 * Time slices
 * Carbon total and multiple commodities
 * Cost total and multiple commodities
 * Cost electricity Peak Plain Valley
 * Unit common tags
 * Unit carbon total and commodity
 * Unit cost total and commodity
 * Ratio common tags
 * Ratio carbon and cost total and commodity
 * Benchmark
 * Ranking
 */

-(UIScrollView *)renderScrollView:(NSArray *)itemModels
{
    self.tooltipItems = [[NSMutableArray alloc] init];
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDMChart_TooltipContentWidth, kDMChart_TooltipViewHeight)];
    
    view.pagingEnabled = NO;
    view.showsHorizontalScrollIndicator = NO;
    view.showsVerticalScrollIndicator = NO;
    view.clipsToBounds = YES;
    
    int itemCount = itemModels.count;
    
    CGFloat itemOffset = kMDChart_TooltipItemLeftOffset;
    CGFloat itemWidth = kDMChart_TooltipItemWidth;
    CGFloat contentWidth = (itemWidth + itemOffset) * itemCount;
    
    if(contentWidth < view.bounds.size.width){
        itemOffset = itemCount == 1 ? 0 : (kDMChart_TooltipContentWidth - (itemCount * itemWidth)) / (itemCount - 1);
        contentWidth = kDMChart_TooltipContentWidth;
    }
    
    for(int i=0;i<itemCount;i++){
        CGRect itemFrame = CGRectMake(i*(itemWidth + itemOffset),0,itemWidth,kDMChart_TooltipViewHeight);
        
        REMChartTooltipItem *tooltipItem = [REMChartTooltipItem itemWithFrame:itemFrame andModel:itemModels[i]];
        
        [view addSubview:tooltipItem];
        [self.tooltipItems addObject:tooltipItem];
    }
    
    view.contentSize = CGSizeMake(contentWidth+kDMChart_TooltipCloseViewWidth, kDMChart_TooltipViewHeight);
    
    return view;
}

- (void)updateHighlightedData:(NSArray *)data
{
    NSArray *highlightedPoints = data; //highlightedPoints for trend data is an array
    
    for(int i=0;i<highlightedPoints.count;i++)
        [[self.tooltipItems objectAtIndex:i] updateModel:highlightedPoints[i]];
}

- (NSArray *)convertItemModels
{
    NSArray *highlightedPoints = self.highlightedPoints; //highlightedPoints for trend data is an array
    NSMutableArray *itemModels = [[NSMutableArray alloc] init];
    
    for(int i=0;i<highlightedPoints.count;i++){
        REMEnergyData *point = highlightedPoints[i];
        REMTargetEnergyData *targetData = self.data.targetEnergyData[i];
        
        REMDataStoreType storeType = self.widget.contentSyntax.dataStoreType;
        REMChartTooltipItemModel *model = (storeType == REMDSEnergyRankingCarbon || storeType == REMDSEnergyRankingCost || storeType == REMDSEnergyRankingEnergy) ? [[REMRankingTooltipItemModel alloc] init] : [[REMChartTooltipItemModel alloc] init];
        
        model.title = [self formatTargetName:targetData.target];
        model.value = REMIsNilOrNull(point) ? nil : point.dataValue;
        model.color = [REMColor colorByIndex:i].uiColor;
        model.index = i;
        model.type = [REMChartSeriesIndicator indicatorTypeWithDiagramType: self.widget.diagramType];
        
        if([model isKindOfClass:[REMRankingTooltipItemModel class]]){
            ((REMRankingTooltipItemModel *)model).numerator = i;
            ((REMRankingTooltipItemModel *)model).denominator = self.data.targetEnergyData.count;
        }
        
        [itemModels addObject:model];
    }
    
    return itemModels;
}

-(NSString *)formatTargetName:(REMEnergyTargetModel *)target
{
    return [REMTextIndicatorFormator formatTargetName:target withWidget:self.widget andParameters:self.parameters];
}


@end