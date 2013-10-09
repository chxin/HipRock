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
    
    REMTrendChartConfig* chartConfig = [REMTrendChartConfig getMinimunWidgetDefaultSetting];
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
    chartConfig.series = seriesArray;
    return  [[REMTrendChartView alloc]initWithFrame:frame chartConfig:chartConfig];
}

-(REMTrendChartSeries*) getSeriesConfigByData:(REMTargetEnergyData*)energyData step:(REMEnergyStep)step yAxisIndex:(uint)yAxisIndex seriesIndex:(uint)seriesIndex {
    return nil;
}
@end
