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
    return [[REMTrendChartColumnSeries alloc]initWithData:energyData.energyData dataProcessor:self.dataProcessor plotStyle:nil yAxisIndex:yAxisIndex dataStep:step];
}
@end