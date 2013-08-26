//
//  REMBuildingCommodityView.m
//  Blues
//
//  Created by tantan on 8/6/13.
//
//

#import "REMBuildingCommodityView.h"

@interface REMBuildingCommodityView()

typedef void(^SuccessCallback)(BOOL success);

@property (nonatomic,strong) REMBuildingTitleLabelView *totalLabel;

@property (nonatomic,strong) NSArray *detailLabelArray;
@property (nonatomic,strong) NSArray *chartViewArray;

@property (nonatomic,strong) SuccessCallback successBlock;

@property (nonatomic) NSUInteger successCounter;

@property (nonatomic,weak) REMCommodityUsageModel *commodityInfo;

@end

@implementation REMBuildingCommodityView

- (id)initWithFrame:(CGRect)frame withCommodityInfo:(REMCommodityUsageModel *)commodityInfo
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.commodityInfo=commodityInfo;
        self.successCounter=0;
        [self initTotalValue];
        [self initDetailValue];
        [self initChartContainer];
    }
    
    return self;
}

- (void)initTotalValue
{
    
    self.totalLabel=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(0, 0, 1000, kBuildingCommodityTotalHeight) withData:self.commodityInfo.commodityUsage withTitle:[NSString stringWithFormat:@"上月用%@总量",self.commodityInfo.commodity.comment] andTitleFontSize:kBuildingCommodityTitleFontSize withTitleMargin:kBuildingTotalInnerMargin   withValueFontSize:kBuildingCommodityTotalValueFontSize withUomFontSize:kBuildingCommodityTotalUomFontSize];
    
    [self addSubview:self.totalLabel];
    
}

- (void)initDetailValue
{
    int marginTop=kBuildingTotalGroupMargin+kBuildingCommodityTotalHeight+kBuildingCommodityTotalTitleHeight+kBuildingTotalInnerMargin;
    REMBuildingTitleLabelView *carbon=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(0, marginTop, kBuildingCommodityDetailWidth, kBuildingCommodityDetailHeight) withData:self.commodityInfo.carbonEquivalent withTitle:@"二氧化碳当量" andTitleFontSize:kBuildingCommodityTitleFontSize withTitleMargin:kBuildingDetailInnerMargin   withValueFontSize:kBuildingCommodityDetailValueFontSize withUomFontSize:kBuildingCommodityDetailUomFontSize];
    
    [self addSubview:carbon];
    
    REMBuildingRankingView *ranking=[[REMBuildingRankingView alloc]initWithFrame:CGRectMake(kBuildingCommodityDetailWidth, marginTop, kBuildingCommodityDetailWidth, kBuildingCommodityDetailHeight) withData:self.commodityInfo.rankingData withTitle:@"集团排名" andTitleFontSize:kBuildingCommodityTitleFontSize withTitleMargin:kBuildingDetailInnerMargin ];
    
    [self addSubview:ranking];
    
    
    REMBuildingTitleLabelView *target=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(kBuildingCommodityDetailWidth*2, marginTop, kBuildingCommodityDetailWidth, kBuildingCommodityDetailHeight) withData:self.commodityInfo.targetValue withTitle:@"目标值"  andTitleFontSize:kBuildingCommodityTitleFontSize withTitleMargin:kBuildingDetailInnerMargin   withValueFontSize:kBuildingCommodityDetailValueFontSize withUomFontSize:kBuildingCommodityDetailUomFontSize];
    
    [self addSubview:target];
}

- (void)initChartContainer
{
    int marginTop=kBuildingTotalInnerMargin+kBuildingCommodityTotalHeight+kBuildingCommodityDetailHeight+kBuildingDetailInnerMargin+kBuildingDetailGroupMargin+kBuildingTotalGroupMargin;

    REMBuildingChartContainerView *view = [[REMBuildingChartContainerView alloc]initWithFrame:CGRectMake(0,marginTop , kBuildingChartWidth, kBuildingChartHeight) withTitle: [NSString stringWithFormat:@"单位面积逐月用%@",self.commodityInfo.commodity.comment] andTitleFontSize:kBuildingCommodityTitleFontSize ];
    
    [self addSubview:view];
    
    int marginTop1=marginTop+kBuildingChartHeight;
    
    REMBuildingChartContainerView *view1 = [[REMBuildingChartContainerView alloc]initWithFrame:CGRectMake(0, marginTop1, kBuildingChartWidth, kBuildingChartHeight) withTitle:[NSString stringWithFormat:@"用%@趋势图",self.commodityInfo.commodity.comment] andTitleFontSize:kBuildingCommodityTitleFontSize ];
    
    [self addSubview:view1];
    
    self.chartViewArray=@[view,view1];
}

- (void)sucessRequest{
    self.successCounter+=1;
    if(self.successCounter == self.chartViewArray.count){
        self.successBlock(YES);
        self.successBlock=nil;
    }
}

- (void)requireChartDataWithBuildingId:(NSNumber *)buildingId withCommodityId:(NSNumber *)commodityId complete:(void(^)(BOOL))callback
{
    self.successBlock=callback;
    
    REMBuildingChartContainerView *averageContainer = self.chartViewArray[0];
    
    if(averageContainer.controller==nil){
        REMBuildingAverageChartHandler *averageController = [[REMBuildingAverageChartHandler alloc]initWithViewFrame:averageContainer.chartContainer.frame];
        averageContainer.controller=averageController;
    }
    
    
    [averageContainer requireChartDataWithBuildingId:buildingId withCommodityId:commodityId withEnergyData:nil complete:^(BOOL success){
        [self sucessRequest];
    }];
    
    
    REMBuildingChartContainerView *trendContainer = self.chartViewArray[1];
    
    if (trendContainer.controller==nil) {
        REMBuildingTrendChartHandler  *trendController = [[REMBuildingTrendChartHandler alloc]initWithViewFrame:trendContainer.chartContainer.frame];
        trendContainer.controller=trendController;
        
    }
    
   
    [trendContainer requireChartDataWithBuildingId:buildingId withCommodityId:commodityId withEnergyData:nil complete:^(BOOL success){
        [self sucessRequest];    
    }];
}
/*
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *result = [super hitTest:point withEvent:event];
    UIView *average = self.chartViewArray[0];
    CGPoint p = [average convertPoint:point fromView:self];
    if ([average pointInside:p withEvent:event]) {
        
        return average;
    }
    return result;
}
*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
