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
    int seriesCount = 0;
    if (energyViewData.targetEnergyData != nil && energyViewData.targetEnergyData != NULL) seriesCount =energyViewData.targetEnergyData.count;
    
    REMTargetEnergyData* seriesData = [energyViewData.targetEnergyData objectAtIndex:0];
    [seriesArray addObject: [[REMPieChartSeries alloc]initWithData:seriesData.energyData dataProcessor:self.dataProcessor plotStyle:nil]];
    
    chartConfig.series = seriesArray;
    return  [[REMPieChartView alloc]initWithFrame:frame chartConfig:chartConfig];
}
-(REMChartDataProcessor*)initializeProcessor {
    return [[REMChartDataProcessor alloc]init];
}
@end
