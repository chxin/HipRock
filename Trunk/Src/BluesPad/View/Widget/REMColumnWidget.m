//
//  REMColumnWidget.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/27/13.
//
//

#import "REMColumnWidget.h"

@implementation REMColumnWidget
-(REMTrendChartSeries*) getSeriesConfigByData:(NSArray*)energyData step:(REMEnergyStep)step seriesIndex:(int)seriesIndex {
    return [[REMTrendChartColumnSeries alloc]initWithData:energyData dataStep:step];
}
@end
