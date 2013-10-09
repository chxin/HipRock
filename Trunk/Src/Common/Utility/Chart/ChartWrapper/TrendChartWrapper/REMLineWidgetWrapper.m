//
//  REMLineWidget.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/27/13.
//
//

#import "REMLineWidgetWrapper.h"

@implementation REMLineWidgetWrapper

-(REMTrendChartSeries*) getSeriesConfigByData:(REMTargetEnergyData*)energyData step:(REMEnergyStep)step yAxisIndex:(uint)yAxisIndex seriesIndex:(uint)seriesIndex {
    return [[REMTrendChartLineSeries alloc]initWithData:energyData.energyData dataStep:step plotStyle:nil yAxisIndex:yAxisIndex];
}
@end
