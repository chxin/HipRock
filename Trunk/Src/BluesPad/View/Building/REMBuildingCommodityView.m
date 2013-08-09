//
//  REMBuildingCommodityView.m
//  Blues
//
//  Created by tantan on 8/6/13.
//
//

#import "REMBuildingCommodityView.h"

@interface REMBuildingCommodityView()

@property (nonatomic,strong) REMBuildingTitleLabelView *totalLabel;

@property (nonatomic,strong) NSArray *detailLabelArray;
@property (nonatomic,strong) NSArray *chartViewArray;



@property (nonatomic,strong) REMCommodityUsageModel *commodityInfo;

@end

@implementation REMBuildingCommodityView

- (id)initWithFrame:(CGRect)frame withCommodityInfo:(REMCommodityUsageModel *)commodityInfo
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.commodityInfo=commodityInfo;
        
        [self initTotalValue];
        [self initDetailValue];
        [self initChartContainer];
    }
    
    return self;
}

- (void)initTotalValue
{
    
    self.totalLabel=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(0, 0, 1000, kBuildingCommodityTotalHeight) withData:self.commodityInfo.commodityUsage withTitle:@"上月总量" andTitleFontSize:kBuildingCommodityTitleFontSize  withValueFontSize:kBuildingCommodityTotalValueFontSize withUomFontSize:kBuildingCommodityTotalUomFontSize];
    
    [self addSubview:self.totalLabel];
    
}

- (void)initDetailValue
{
    
    REMBuildingTitleLabelView *carbon=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(0, kBuildingCommodityItemGroupMargin+kBuildingCommodityTotalHeight, kBuildingCommodityDetailWidth, kBuildingCommodityDetailHeight) withData:self.commodityInfo.carbonEquivalent withTitle:@"二氧化碳当量" andTitleFontSize:kBuildingCommodityTitleFontSize  withValueFontSize:kBuildingCommodityDetailValueFontSize withUomFontSize:kBuildingCommodityDetailUomFontSize];
    
    [self addSubview:carbon];
    
    REMBuildingRankingView *ranking=[[REMBuildingRankingView alloc]initWithFrame:CGRectMake(kBuildingCommodityDetailWidth, kBuildingCommodityItemGroupMargin+kBuildingCommodityTotalHeight, kBuildingCommodityDetailWidth, kBuildingCommodityDetailHeight) withData:self.commodityInfo.rankingData withTitle:@"集团排名" andTitleFontSize:kBuildingCommodityTitleFontSize];
    
    [self addSubview:ranking];
    
    
    REMBuildingTitleLabelView *target=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(kBuildingCommodityDetailWidth*2, kBuildingCommodityItemGroupMargin+kBuildingCommodityTotalHeight, kBuildingCommodityDetailWidth, kBuildingCommodityDetailHeight) withData:self.commodityInfo.targetValue withTitle:@"目标值"  andTitleFontSize:kBuildingCommodityTitleFontSize  withValueFontSize:kBuildingCommodityDetailValueFontSize withUomFontSize:kBuildingCommodityDetailUomFontSize];
    
    [self addSubview:target];
}

- (void)initChartContainer
{
    REMBuildingChartContainerView *view = [[REMBuildingChartContainerView alloc]initWithFrame:CGRectMake(0, kBuildingCommodityItemGroupMargin*3+kBuildingCommodityTotalHeight+kBuildingCommodityDetailHeight, 1024, kBuildingChartHeight) withTitle:@"上月平均" andTitleFontSize:kBuildingCommodityTitleFontSize ];
    
    [self addSubview:view];
    
    
    REMBuildingChartContainerView *view1 = [[REMBuildingChartContainerView alloc]initWithFrame:CGRectMake(0, kBuildingCommodityItemGroupMargin*4+kBuildingCommodityTotalHeight+kBuildingCommodityDetailHeight+kBuildingChartHeight, 1024, kBuildingChartHeight) withTitle:@"趋势图" andTitleFontSize:kBuildingCommodityTitleFontSize ];
    
    [self addSubview:view1];
    
    self.chartViewArray=@[view,view1];
}

- (void)requireChartDataWithBuildingId:(NSNumber *)buildingId withCommodityId:(NSNumber *)commodityId
{
    REMBuildingChartContainerView *averageContainer = self.chartViewArray[0];
    
    REMBuildingAverageChartHandler *chart = [[REMBuildingAverageChartHandler alloc]initWithViewFrame:averageContainer.chartContainer.frame];
    
    [averageContainer requireChartDataWithBuildingId:buildingId withCommodityId:commodityId withController:chart withEnergyData:self.commodityInfo.averageUsageData];
    
    
    REMBuildingChartContainerView *trendContainer = self.chartViewArray[1];
    
   REMBuildingTrendChartHandler  *chart1 = [[REMBuildingTrendChartHandler alloc]initWithViewFrame:trendContainer.chartContainer.frame];
    
    [trendContainer requireChartDataWithBuildingId:buildingId withCommodityId:commodityId withController:chart1 withEnergyData:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
