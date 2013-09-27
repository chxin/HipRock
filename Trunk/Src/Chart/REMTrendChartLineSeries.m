//
//  REMTrendChartScatterSeries.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/13/13.
//
//

#import "REMTrendChart.h"

@implementation REMTrendChartLineSeries
//-(REMTrendChartSeries*)initWithData:(NSArray*)energyData dataStep:(REMEnergyStep)step dataProcessor:(REMTrendChartDataProcessor*)processor yAxisIndex:(int)yAxisIndex startDate:(NSDate*)startDate {
//    self = [super initWithData:energyData dataStep:step dataProcessor:processor yAxisIndex:yAxisIndex startDate:startDate];
//    seriesType = REMTrendChartSeriesTypeLine;
//    return self;
//}

-(CPTPlot*)makePlot {
    CPTPlot* plot = [[CPTScatterPlot alloc]init];
    plot.dataSource = self;
    plot.delegate = self;
    return plot;
}
-(REMTrendChartSeriesType)getSeriesType {
    return REMTrendChartSeriesTypeLine;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx {
    REMTrendChartPoint* point = [self.points objectAtIndex:idx];
    if (fieldEnum == CPTScatterPlotFieldX) {
        return [NSNumber numberWithFloat:point.x];
    } else {
        return point.y;
    }
}
@end
