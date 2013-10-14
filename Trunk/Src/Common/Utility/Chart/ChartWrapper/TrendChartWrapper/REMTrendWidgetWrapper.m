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
    REMTrendChartConfig* chartConfig = nil;
    if (self.status == REMWidgetStatusMinimized) {
        chartConfig = (REMTrendChartConfig*)[REMTrendChartConfig getMinimunWidgetDefaultSetting];
    } else {
        chartConfig = (REMTrendChartConfig*)[REMTrendChartConfig getMaximunWidgetDefaultSetting];
    }
    
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
            [yAxisConfig addObject:[REMTrendChartAxisConfig getMinWidgetYConfig]];
        }
        chartConfig.yAxisConfig = yAxisConfig;
    }
    chartConfig.series = seriesArray;
    
    REMTrendChartView* myView = [[REMTrendChartView alloc]initWithFrame:frame chartConfig:chartConfig];
    NSDate* globalEnd, *globalStart;
//    if (energyViewData.targetGlobalData != nil && energyViewData.targetGlobalData.energyData != nil && energyViewData.targetGlobalData.energyData.count > 0) {
//        globalEnd = [[energyViewData.targetGlobalData.energyData objectAtIndex:energyViewData.targetGlobalData.energyData.count-1] localTime];
//        globalStart = [[energyViewData.targetGlobalData.energyData objectAtIndex:0] localTime];
//    } else {
//        REMTargetEnergyData* theFirstSeries =(REMTargetEnergyData*)[energyViewData.targetEnergyData objectAtIndex:0];
//        globalEnd = [theFirstSeries.energyData objectAtIndex:theFirstSeries.energyData.count-1];
//        globalStart = [theFirstSeries.energyData objectAtIndex:0];
//    }
    REMTimeRange* theFirstTimeRange = [widgetSyntax.timeRanges objectAtIndex:0];
    globalStart = theFirstTimeRange.startTime;
    globalEnd = theFirstTimeRange.endTime;
    NSDate* syntaxStartDate = theFirstTimeRange.startTime;
    NSDate* syntaxEndDate = theFirstTimeRange.endTime;
    chartConfig.xGlobalLength = [self.dataProcessor processX:globalEnd startDate:globalStart step:widgetSyntax.step.intValue];
    float rangeStart =[self.dataProcessor processX:syntaxStartDate startDate:globalStart step:widgetSyntax.step.intValue].floatValue;
    float rangeEnd = [self.dataProcessor processX:syntaxEndDate startDate:globalStart step:widgetSyntax.step.intValue].floatValue;
    [myView renderRange: rangeStart length:rangeEnd-rangeStart];
    return  myView;
}

-(REMTrendChartSeries*) getSeriesConfigByData:(REMTargetEnergyData*)energyData step:(REMEnergyStep)step yAxisIndex:(uint)yAxisIndex seriesIndex:(uint)seriesIndex {
    return nil;
}
-(REMChartDataProcessor*)initializeProcessor {
    return [[REMTrendChartDataProcessor alloc]init];
}
@end
