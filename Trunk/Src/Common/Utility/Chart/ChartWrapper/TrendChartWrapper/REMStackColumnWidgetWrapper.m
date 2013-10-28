//
//  REMStackColumnWidgetWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 10/23/13.
//
//

#import "REMStackColumnWidgetWrapper.h"

@implementation REMStackColumnWidgetWrapper
-(REMTrendChartSeries*) getSeriesConfigByData:(REMTargetEnergyData*)energyData step:(REMEnergyStep)step yAxisIndex:(uint)yAxisIndex seriesIndex:(uint)seriesIndex startDate:(NSDate*)startDate {
    
    return [[REMTrendChartStackColumnSeries alloc]initWithData:energyData.energyData dataProcessor:sharedProcessor plotStyle:nil startDate:startDate];
}
-(NSDictionary*)getSeriesAndAxisConfig:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    NSMutableArray* seriesArray = [[NSMutableArray alloc]init];
    int seriesCount = 0;
    if (energyViewData.targetEnergyData != nil && energyViewData.targetEnergyData != NULL) seriesCount =energyViewData.targetEnergyData.count;
    NSDate* startDate = nil;
    for (int seriesIndex = 0; seriesIndex < seriesCount; seriesIndex++) {
        REMTargetEnergyData* seriesData = [energyViewData.targetEnergyData objectAtIndex:seriesIndex];
        if (seriesData.energyData.count == 0) continue;
        NSDate* firstPointTime = ((REMEnergyData*)seriesData.energyData[0]).localTime;
        if (startDate == nil || [startDate compare:firstPointTime] == NSOrderedDescending) {
            startDate = firstPointTime;
        }
    }
    for (int seriesIndex = 0; seriesIndex < seriesCount; seriesIndex++) {
        REMTargetEnergyData* seriesData = [energyViewData.targetEnergyData objectAtIndex:seriesIndex];
        [seriesArray addObject: [self getSeriesConfigByData:seriesData step:self.widgetSyntax.step.intValue yAxisIndex:0 seriesIndex:seriesIndex startDate:startDate]];
    }
    [dic setObject:seriesArray forKey:@"series"];
    
    REMTrendChartAxisConfig* yAxis = nil;
    yAxis.labelFormatter = [[REMYFormatter alloc]init];
    [dic setObject:@[yAxis] forKey:@"yAxis"];
    
    [dic setObject:[NSNumber numberWithUnsignedInt:energyViewData.targetEnergyData.count] forKey:@"xGlobalLength"];
    [dic setObject:[NSNumber numberWithUnsignedInt:0] forKey:@"xStartLocation"];
    [dic setObject:[NSNumber numberWithUnsignedInt:energyViewData.targetEnergyData.count] forKey:@"xEndLocation"];
    return dic;
}
@end
