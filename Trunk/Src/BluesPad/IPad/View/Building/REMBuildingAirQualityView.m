/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingAirQualityView.m
 * Created      : tantan on 8/22/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMBuildingAirQualityView.h"

@interface REMBuildingAirQualityView()

@property (nonatomic,strong) REMBuildingTitleLabelView *totalLabel;

@property (nonatomic,strong) NSArray *detailLabelArray;



@property (nonatomic,weak) REMAirQualityModel *airQuality;

@end

@implementation REMBuildingAirQualityView


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if(point.y>self.frame.origin.y)return YES;
    
    return [super pointInside:point withEvent:event];
    
}

/*
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
 
    self.totalLabel=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(0, 0, 1000, kBuildingCommodityTotalHeight) withData:self.airQuality.honeywell withTitle:@"室内PM2.5" andTitleFontSize:kBuildingCommodityTitleFontSize withTitleMargin:kBuildingTotalInnerMargin withLeftMargin:0   withValueFontSize:kBuildingCommodityTotalValueFontSize withUomFontSize:kBuildingCommodityTotalUomFontSize];
    
    [self addSubview:self.totalLabel];
    
}

- (void)initDetailValue
{
    
    int marginTop=kBuildingCommodityTotalHeight+kBuildingCommodityBottomMargin;
    
    
    REMBuildingTitleLabelView *outdoor=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(0, marginTop, kBuildingCommodityDetailWidth, kBuildingCommodityDetailHeight) withData:self.airQuality.outdoor withTitle:@"室外PM2.5" andTitleFontSize:kBuildingCommodityTitleFontSize withTitleMargin:kBuildingDetailInnerMargin withLeftMargin:0   withValueFontSize:kBuildingCommodityDetailValueFontSize withUomFontSize:kBuildingCommodityDetailUomFontSize];
    
    [self addSubview:outdoor];
    
    
    REMBuildingTitleLabelView *huoni=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(kBuildingCommodityDetailWidth, marginTop, kBuildingCommodityDetailWidth, kBuildingCommodityDetailHeight) withData:self.airQuality.honeywell withTitle:@"室内新风PM2.5(霍尼)"  andTitleFontSize:kBuildingCommodityTitleFontSize withTitleMargin:kBuildingDetailInnerMargin withLeftMargin:kBuildingCommodityDetailTextMargin  withValueFontSize:kBuildingCommodityDetailValueFontSize withUomFontSize:kBuildingCommodityDetailUomFontSize];
    [self addSplitBar:huoni];
    [self addSubview:huoni];
    
    
    REMBuildingTitleLabelView *meiai=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(kBuildingCommodityDetailWidth*2, marginTop, kBuildingCommodityDetailWidth, kBuildingCommodityDetailHeight) withData:self.airQuality.mayair withTitle:@"室内新风PM2.5(美埃)"  andTitleFontSize:kBuildingCommodityTitleFontSize withTitleMargin:kBuildingDetailInnerMargin withLeftMargin:kBuildingCommodityDetailTextMargin  withValueFontSize:kBuildingCommodityDetailValueFontSize withUomFontSize:kBuildingCommodityDetailUomFontSize];
        [self addSplitBar:meiai];
    [self addSubview:meiai];
    
}

- (void)initChartContainer
{
    int marginTop=kBuildingCommodityTotalHeight+kBuildingCommodityDetailHeight+kBuildingDetailInnerMargin+kBuildingCommodityBottomMargin*2;
    int chartContainerHeight= kBuildingChartHeight*2+kBuildingCommodityBottomMargin+85;
    REMBuildingChartContainerView *view = [[REMBuildingChartContainerView alloc]initWithFrame:CGRectMake(0,marginTop , kImageWidth-kBuildingCommodityLeftMargin,chartContainerHeight) withTitle:@"室内外PM2.5逐日含量" andTitleFontSize:kBuildingCommodityTitleFontSize ];
    
    [self addSubview:view];
    
    
    
    self.chartViewArray=@[view];
}


- (void)requireChartDataWithBuildingId:(NSNumber *)buildingId withCommodityId:(NSNumber *)commodityId complete:(void(^)(BOOL))callback
{
        
    REMBuildingChartContainerView *pmContainer = self.chartViewArray[0];
    
    if(pmContainer.controller==nil){
        //REMBuildingAirQualityChartHandler *pmController = [[REMBuildingAirQualityChartHandler alloc]initWithViewFrame:CGRectMake(0, 0, pmContainer.chartContainer.frame.size.width, pmContainer.chartContainer.frame.size.height)];
        //pmContainer.controller=pmController;
    }
    
    
    //[pmContainer requireChartDataWithBuildingId:buildingId withCommodityId:commodityId withEnergyData:nil complete:^(BOOL success){
    //    callback(success);
    //}];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if(point.y>self.frame.origin.y)return YES;
    
    return [super pointInside:point withEvent:event];
    
}
*/
@end