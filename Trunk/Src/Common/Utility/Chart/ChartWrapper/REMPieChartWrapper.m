/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMPieChartWrapper.m
 * Created      : Zilong-Oscar.Xu on 10/8/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMPieChartWrapper.h"

@implementation REMPieChartWrapper
-(REMPieChartView*)renderContentView:(CGRect)frame chartConfig:(REMChartConfig*)chartConfig {
    return  [[REMPieChartView alloc]initWithFrame:frame chartConfig:chartConfig];
}

-(REMChartConfig*)getChartConfig:(REMChartStyle*)style {
    REMChartConfig* chartConfig = [[REMChartConfig alloc]initWithStyle:style];
    
    NSMutableArray* series0Data = [[NSMutableArray alloc]init];
    int seriesCount = 0;
    if (self.energyViewData != nil && self.energyViewData.targetEnergyData != NULL) seriesCount =self.energyViewData.targetEnergyData.count;
    NSMutableArray* targets = [[NSMutableArray alloc]init];
    for (uint i = 0; i < seriesCount; i++) {
        REMTargetEnergyData* seriesData = [self.energyViewData.targetEnergyData objectAtIndex:i];
        if (seriesData.energyData != nil && seriesData.energyData.count > 0) {
            [series0Data addObject:seriesData.energyData[0]];
        } else {
            [series0Data addObject:[NSNull null]];
        }
        [targets addObject:seriesData.target.name == nil ? @"" : seriesData.target.name];
    }
    REMPieChartSeries* s =[[REMPieChartSeries alloc]initWithData:series0Data dataProcessor:[[REMChartDataProcessor alloc]init] plotStyle:nil];
    s.targetNames = targets;
    s.animationDuration = chartConfig.animationDuration;
    chartConfig.series = @[s];
    
    return chartConfig;
}

-(UIView*)getView {
    return self.view;
}
-(void)redraw:(REMEnergyViewData *)energyViewData {
    id<REMTPieChartDelegate> delegate = ((REMPieChartView*)[self getView]).delegate;
    [super redraw:energyViewData];
    ((REMPieChartView*)self.view).delegate = delegate;
}
@end
