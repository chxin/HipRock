//
//  REMTrendWidget.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/27/13.
//
//

#import "REMTrendWidgetWrapper.h"

@implementation REMTrendWidgetWrapper

-(REMTrendChartView*)renderContentView:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax {
    
    REMTrendChartConfig* chartConfig = (REMTrendChartConfig*)[REMTrendChartConfig getMinimunWidgetDefaultSetting];
    chartConfig.step = widgetSyntax.step.intValue;
    NSMutableArray* seriesArray = [[NSMutableArray alloc]init];
    int seriesCount = 0;
    if (energyViewData.targetEnergyData != nil && energyViewData.targetEnergyData != NULL) seriesCount =energyViewData.targetEnergyData.count;
    NSMutableArray* uomIdArray = [[NSMutableArray alloc]init];
    for (int seriesIndex = 0; seriesIndex < seriesCount; seriesIndex++) {
        REMTargetEnergyData* seriesData = [energyViewData.targetEnergyData objectAtIndex:seriesIndex];
        long uomId = seriesData.target.uomId;
        uint uomIndex = 0;
        for (; uomIndex < uomIdArray.count; uomIndex++) {
            NSNumber* otherUomId = [uomIdArray objectAtIndex:uomIndex];
            if (otherUomId.unsignedIntValue == uomId) {
                break;
            }
        }
        if (uomIndex == uomIdArray.count) {
            [uomIdArray addObject:[NSNumber numberWithLong:uomId]];
        }
        [seriesArray addObject: [self getSeriesConfigByData:seriesData step:widgetSyntax.step.intValue yAxisIndex:uomIndex seriesIndex:seriesIndex]];
    }
    if (uomIdArray.count > 1) {
        NSMutableArray* yAxisConfig = [NSMutableArray arrayWithArray: chartConfig.yAxisConfig];
        for (int i = 1; i < uomIdArray.count; i++) {
            [yAxisConfig addObject:[REMTrendChartAxisConfig getWidgetYConfig]];
        }
        chartConfig.yAxisConfig = yAxisConfig;
    }
    chartConfig.series = seriesArray;
    
    if (energyViewData.targetGlobalData != nil && energyViewData.targetGlobalData.energyData != nil && energyViewData.targetGlobalData.energyData.count > 0) {
        REMEnergyData* globalEndPoint = [energyViewData.targetGlobalData.energyData objectAtIndex:energyViewData.targetGlobalData.energyData.count-1];
        REMEnergyData* globalStartPoint = [energyViewData.targetGlobalData.energyData objectAtIndex:0];
        
        chartConfig.xGlobalLength = [self.dataProcessor processX:globalEndPoint startDate:globalStartPoint.localTime step:widgetSyntax.step.intValue];
    }
    
    return  [[REMTrendChartView alloc]initWithFrame:frame chartConfig:chartConfig];
}

-(REMTrendChartSeries*) getSeriesConfigByData:(REMTargetEnergyData*)energyData step:(REMEnergyStep)step yAxisIndex:(uint)yAxisIndex seriesIndex:(uint)seriesIndex {
    return nil;
}
-(REMChartDataProcessor*)initializeProcessor {
    return [[REMTrendChartDataProcessor alloc]init];
}
@end
