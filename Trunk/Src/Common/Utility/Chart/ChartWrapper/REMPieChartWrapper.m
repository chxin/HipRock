//
//  REMPieChartWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 10/8/13.
//
//

#import "REMPieChartWrapper.h"

@implementation REMPieChartWrapper
-(REMPieChartView*)renderContentView:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax {
    REMChartConfig* chartConfig = [REMChartConfig getMinimunWidgetDefaultSetting];
    NSMutableArray* seriesArray = [[NSMutableArray alloc]init];
    
    NSMutableArray* series0Data = [[NSMutableArray alloc]init];
    int seriesCount = 0;
    if (energyViewData != nil && energyViewData.targetEnergyData != NULL) seriesCount =energyViewData.targetEnergyData.count;
    for (uint i = 0; i < seriesCount; i++) {
        REMTargetEnergyData* seriesData = [energyViewData.targetEnergyData objectAtIndex:i];
        if (seriesData.energyData != nil && seriesData.energyData.count > 0) {
            [series0Data addObjectsFromArray:seriesData.energyData];
        }
    }
    [seriesArray addObject: [[REMPieChartSeries alloc]initWithData:series0Data dataProcessor:self.dataProcessor plotStyle:nil]];
    
    chartConfig.series = seriesArray;
    return  [[REMPieChartView alloc]initWithFrame:frame chartConfig:chartConfig];
}
-(REMChartDataProcessor*)initializeProcessor {
    return [[REMChartDataProcessor alloc]init];
}
@end
