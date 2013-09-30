//
//  REMLineWidget.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/27/13.
//
//

#import "REMLineWidgetWrapper.h"

@implementation REMLineWidget

-(REMTrendChartSeries*) getSeriesConfigByData:(NSArray*)energyData step:(REMEnergyStep)step seriesIndex:(int)seriesIndex {
    return [[REMTrendChartLineSeries alloc]initWithData:energyData dataStep:step];
}
@end
