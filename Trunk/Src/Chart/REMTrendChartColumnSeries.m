//
//  REMTrendChartColumnSeries.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/13/13.
//
//

#import "REMTrendChart.h"

@implementation REMTrendChartColumnSeries

-(REMTrendChartColumnSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMTrendChartDataProcessor*)processor dataStep:(REMEnergyStep)step startDate:(NSDate*)startDate {
    self = [super initWithData:energyData dataProcessor:processor dataStep:step startDate:startDate];
    seriesType = REMTrendChartSeriesTypeColumn;
    return self;
}

-(CPTPlot*)makePlot {
    CPTBarPlot* plot ;
    
    return plot;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    REMTrendChartPoint* point = [self.points objectAtIndex:idx];
    if (fieldEnum == CPTBarPlotFieldBarLocation) {
        return [NSNumber numberWithFloat:point.x];
    } else {
        return point.y;
    }
}
@end
