//
//  REMTrendWidget.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/27/13.
//
//

#import "REMTrendWidgetWrapper.h"

@implementation REMTrendWidget

-(REMTrendChartView*)renderContentView:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax {
    
    REMTrendChartConfig* chartConfig = [REMTrendChartConfig getMinimunWidgetDefaultSetting];
    chartConfig.step = widgetSyntax.step.intValue;
    NSMutableArray* seriesArray = [[NSMutableArray alloc]init];
    int seriesCount = 0;
    if (energyViewData.targetEnergyData != nil && energyViewData.targetEnergyData != NULL) seriesCount =energyViewData.targetEnergyData.count;
    for (int seriesIndex = 0; seriesIndex < seriesCount; seriesIndex++) {
        REMTargetEnergyData* seriesData = [energyViewData.targetEnergyData objectAtIndex:seriesIndex];
        [seriesArray addObject: [self getSeriesConfigByData:seriesData.energyData step:widgetSyntax.step.intValue seriesIndex:seriesIndex]];
    }
    chartConfig.series = seriesArray;
    return  [[REMTrendChartView alloc]initWithFrame:frame chartConfig:chartConfig];
}

-(REMTrendChartSeries*) getSeriesConfigByData:(NSArray*)energyData step:(REMEnergyStep)step seriesIndex:(int)seriesIndex {
    return nil;
}
@end
