//
//  REMTrendChartScatterSeries.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/13/13.
//
//

#import "REMTrendChart.h"

@implementation REMTrendChartLineSeries
-(REMTrendChartLineSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMTrendChartDataProcessor*)processor dataStep:(REMEnergyStep)step startDate:(NSDate*)startDate {
    self = [super initWithData:energyData dataProcessor:processor dataStep:step startDate:startDate];
    seriesType = REMTrendChartSeriesTypeLine;
    return self;
}

//-(CPTPlot*)makePlot {
//    CPTScatterPlot* plot = [[CPTScatterPlot alloc]initWithFrame: graph.bounds];
//    plot.plotSymbol
//    return plot;
//}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    REMTrendChartPoint* point = [self.points objectAtIndex:idx];
    if (fieldEnum == CPTScatterPlotFieldX) {
        return [NSNumber numberWithFloat:point.x];
    } else {
        return point.y;
    }
}
@end
