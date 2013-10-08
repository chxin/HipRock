//
//  REMColumnWidgetWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/27/13.
//
//

#import "REMColumnWidgetWrapper.h"

@implementation REMColumnWidgetWrapper
-(REMTrendChartSeries*) getSeriesConfigByData:(REMTargetEnergyData*)energyData step:(REMEnergyStep)step yAxisIndex:(uint)yAxisIndex seriesIndex:(uint)seriesIndex {
    NSDictionary* seriesStyle = @{@"fill": [CPTFill fillWithColor:[self getSeriesColorByIndex:seriesIndex]]};
    return [[REMTrendChartColumnSeries alloc]initWithData:energyData.energyData dataStep:step plotStyle:nil yAxisIndex:yAxisIndex];
}
@end
