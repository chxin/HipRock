//
//  REMStackColumnWidgetWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 10/23/13.
//
//

#import "REMStackColumnWidgetWrapper.h"

@implementation REMStackColumnWidgetWrapper
-(REMTrendChartSeries*) getSeriesConfigByData:(REMTargetEnergyData*)energyData step:(REMEnergyStep)step yAxisIndex:(uint)yAxisIndex seriesIndex:(uint)seriesIndex {
    return [[REMTrendChartStackColumnSeries alloc]initWithData:energyData.energyData dataProcessor:self.dataProcessor plotStyle:nil yAxisIndex:yAxisIndex dataStep:step];
}
-(NSDictionary*)getSeriesAndAxisConfig:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    NSMutableArray* seriesArray = [[NSMutableArray alloc]init];
    int seriesCount = 0;
    if (energyViewData.targetEnergyData != nil && energyViewData.targetEnergyData != NULL) seriesCount =energyViewData.targetEnergyData.count;
    for (int seriesIndex = 0; seriesIndex < seriesCount; seriesIndex++) {
        REMTargetEnergyData* seriesData = [energyViewData.targetEnergyData objectAtIndex:seriesIndex];
        [seriesArray addObject: [self getSeriesConfigByData:seriesData step:self.widgetSyntax.step.intValue yAxisIndex:0 seriesIndex:seriesIndex]];
    }
    [dic setObject:seriesArray forKey:@"series"];
    
    REMTrendChartAxisConfig* yAxis = nil;
    if (self.status == REMWidgetStatusMinimized) {
        yAxis = [REMTrendChartAxisConfig getMinWidgetYConfig];
    } else {
        yAxis = [REMTrendChartAxisConfig getMaxWidgetYConfig];
    }
    [dic setObject:@[yAxis] forKey:@"yAxis"];
    
    [dic setObject:[NSNumber numberWithUnsignedInt:energyViewData.targetEnergyData.count] forKey:@"xGlobalLength"];
    [dic setObject:[NSNumber numberWithUnsignedInt:0] forKey:@"xStartLocation"];
    [dic setObject:[NSNumber numberWithUnsignedInt:energyViewData.targetEnergyData.count] forKey:@"xEndLocation"];
    return dic;
}
@end
