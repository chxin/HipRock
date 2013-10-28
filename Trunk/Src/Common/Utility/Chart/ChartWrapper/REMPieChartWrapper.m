//
//  REMPieChartWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 10/8/13.
//
//

#import "REMPieChartWrapper.h"

@implementation REMPieChartWrapper
-(REMPieChartView*)renderContentView:(CGRect)frame chartConfig:(REMChartConfig*)chartConfig {
    return  [[REMPieChartView alloc]initWithFrame:frame chartConfig:chartConfig];
}

-(REMChartConfig*)getChartConfig:(NSDictionary*)style {
    REMChartConfig* chartConfig = [[REMChartConfig alloc]initWithDictionary:style];
    
    NSMutableArray* series0Data = [[NSMutableArray alloc]init];
    int seriesCount = 0;
    if (self.energyViewData != nil && self.energyViewData.targetEnergyData != NULL) seriesCount =self.energyViewData.targetEnergyData.count;
    for (uint i = 0; i < seriesCount; i++) {
        REMTargetEnergyData* seriesData = [self.energyViewData.targetEnergyData objectAtIndex:i];
        if (seriesData.energyData != nil && seriesData.energyData.count > 0) {
            [series0Data addObjectsFromArray:seriesData.energyData];
        }
    }
    REMPieChartSeries* s =[[REMPieChartSeries alloc]initWithData:series0Data dataProcessor:[[REMChartDataProcessor alloc]init] plotStyle:nil];
    s.animationDuration = chartConfig.animationDuration;
    chartConfig.series = @[s];
    
    return chartConfig;
}
@end
