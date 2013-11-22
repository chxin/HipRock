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


-(REMTooltipViewBase *)initWithHighlightedData:(id)points inEnergyData:(REMEnergyViewData *)data widget:(REMWidgetObject *)widget andParameters:(REMWidgetSearchModelBase *)parameters
{
    self = [super initWithHighlightedData:points inEnergyData:data widget:widget andParameters:parameters];
    
    if(self){
    }
    
    return self;
}

-(UIScrollView *)renderScrollView
{
    self.tooltipItems = [[NSMutableArray alloc] init];
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDMChart_TooltipContentWidth - kDMChart_TooltipCloseViewWidth, kDMChart_TooltipContentHeight)];
    
    view.pagingEnabled = NO;
    view.showsHorizontalScrollIndicator = NO;
    view.showsVerticalScrollIndicator = NO;
    view.clipsToBounds = YES;
    
    int itemCount = self.itemModels.count;
    
    CGFloat itemOffset = kMDChart_TooltipItemLeftOffset;
    CGFloat itemWidth = kDMChart_TooltipItemWidth;
    CGFloat contentWidth = (itemWidth + itemOffset) * itemCount - kDMChart_TooltipCloseViewWidth;
    
    if(contentWidth < view.bounds.size.width){
        itemOffset = itemCount == 1 ? 0 : (kDMChart_TooltipContentWidth - kDMChart_TooltipCloseViewWidth - (itemCount * itemWidth)) / (itemCount - 1);
        contentWidth = kDMChart_TooltipContentWidth-kDMChart_TooltipCloseViewWidth;
    }
    
    for(int i=0;i<itemCount;i++){
        CGRect itemFrame = CGRectMake(i*(itemWidth + itemOffset),0,itemWidth,kDMChart_TooltipViewHeight);
        
        REMChartTooltipItem *tooltipItem = [REMChartTooltipItem itemWithFrame:itemFrame andModel:self.itemModels[i]];
        
        [view addSubview:tooltipItem];
        [self.tooltipItems addObject:tooltipItem];
    }
    
    view.contentSize = CGSizeMake(contentWidth, kDMChart_TooltipViewHeight);
    
    NSLog(@"scroll view width: %f, content width: %f", view.frame.size.width, view.contentSize.width);
    
    return view;
}

- (void)updateHighlightedData:(NSArray *)data
{
    self.highlightedPoints = data;
    self.itemModels = [self convertItemModels];
    
    for(int i=0;i<self.itemModels.count;i++)
        [[self.tooltipItems objectAtIndex:i] updateModel:self.itemModels[i]];
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
        
        if(REMIsNilOrNull(targetData.target.uomName)){
            model.uom = REMUoms[@(targetData.target.uomId)];
        }
        else{
            model.uom = targetData.target.uomName;
        }
        
        
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
