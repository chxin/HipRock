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
    REMTrendChartRankingSeries* series =[[REMTrendChartRankingSeries alloc]initWithData:energyViewData.targetEnergyData dataProcessor:self.dataProcessor plotStyle:nil yAxisIndex:0 dataStep:REMEnergyStepHour];
    //    if (widgetSyntax)
    //    _sortOrder = NSOrderedDescending;
    [dic setObject:@[series] forKey:@"series"];
    
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
