//
//  REMBuildingAirQualityView.m
//  Blues
//
//  Created by tantan on 8/22/13.
//
//

#import "REMBuildingAirQualityView.h"

@interface REMBuildingAirQualityView()

@property (nonatomic,strong) REMBuildingTitleLabelView *totalLabel;

@property (nonatomic,strong) NSArray *detailLabelArray;
@property (nonatomic,strong) NSArray *chartViewArray;


@property (nonatomic,weak) REMAirQualityModel *airQuality;

@end

@implementation REMBuildingAirQualityView

- (id)initWithFrame:(CGRect)frame withAirQualityInfo:(REMAirQualityModel *)airQualityInfo
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.airQuality=airQualityInfo;
        [self initTotalValue];
        [self initDetailValue];
        [self initChartContainer];
    }
    
    return self;
}

- (void)initTotalValue
{
    
    self.totalLabel=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(0, 0, 1000, kBuildingCommodityTotalHeight) withData:self.airQuality.honeywell withTitle:@"室内监测点" andTitleFontSize:kBuildingCommodityTitleFontSize withTitleMargin:kBuildingTotalInnerMargin   withValueFontSize:kBuildingCommodityTotalValueFontSize withUomFontSize:kBuildingCommodityTotalUomFontSize];
    
    [self addSubview:self.totalLabel];
    
}

- (void)initDetailValue
{
    int marginTop=kBuildingTotalGroupMargin+kBuildingCommodityTotalHeight+kBuildingCommodityTotalTitleHeight+kBuildingTotalInnerMargin;
    
    
    REMBuildingTitleLabelView *outdoor=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(0, marginTop, kBuildingCommodityDetailWidth, kBuildingCommodityDetailHeight) withData:self.airQuality.outdoor withTitle:@"室外监测点" andTitleFontSize:kBuildingCommodityTitleFontSize withTitleMargin:kBuildingDetailInnerMargin   withValueFontSize:kBuildingCommodityDetailValueFontSize withUomFontSize:kBuildingCommodityDetailUomFontSize];
    
    [self addSubview:outdoor];
    
    
    REMBuildingTitleLabelView *huoni=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(kBuildingCommodityDetailWidth, marginTop, kBuildingCommodityDetailWidth, kBuildingCommodityDetailHeight) withData:self.airQuality.honeywell withTitle:@"室内霍尼韦尔净化后"  andTitleFontSize:kBuildingCommodityTitleFontSize withTitleMargin:kBuildingDetailInnerMargin   withValueFontSize:kBuildingCommodityDetailValueFontSize withUomFontSize:kBuildingCommodityDetailUomFontSize];
    
    [self addSubview:huoni];
    
    
    REMBuildingTitleLabelView *meiai=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(kBuildingCommodityDetailWidth*2, marginTop, kBuildingCommodityDetailWidth, kBuildingCommodityDetailHeight) withData:self.airQuality.mayair withTitle:@"室内美埃净化后"  andTitleFontSize:kBuildingCommodityTitleFontSize withTitleMargin:kBuildingDetailInnerMargin   withValueFontSize:kBuildingCommodityDetailValueFontSize withUomFontSize:kBuildingCommodityDetailUomFontSize];
    
    [self addSubview:meiai];
}

- (void)initChartContainer
{
    int marginTop=kBuildingTotalInnerMargin+kBuildingCommodityTotalHeight+kBuildingCommodityDetailHeight+kBuildingDetailInnerMargin+kBuildingDetailGroupMargin+kBuildingTotalGroupMargin;
    
    REMBuildingChartContainerView *view = [[REMBuildingChartContainerView alloc]initWithFrame:CGRectMake(0,marginTop , kBuildingChartWidth, kBuildingChartHeight) withTitle:@"室内外PM2.5" andTitleFontSize:kBuildingCommodityTitleFontSize ];
    
    [self addSubview:view];
    
    
    
    self.chartViewArray=@[view];
}


- (void)requireChartDataWithBuildingId:(NSNumber *)buildingId withCommodityId:(NSNumber *)commodityId complete:(void(^)(BOOL))callback
{
        
    REMBuildingChartContainerView *pmContainer = self.chartViewArray[0];
    
    if(pmContainer.controller==nil){
        REMBuildingAirQualityChartHandler *pmController = [[REMBuildingAirQualityChartHandler alloc]initWithViewFrame:pmContainer.chartContainer.frame];
        pmContainer.controller=pmController;
    }
    
    
    [pmContainer requireChartDataWithBuildingId:buildingId withCommodityId:commodityId withEnergyData:nil complete:^(BOOL success){
        callback(success);
    }];
    
    
    
}


@end
