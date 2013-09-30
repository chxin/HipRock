//
//  REMTrendChartSeries.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/13/13.
//
//

#import "REMChartHeader.h"

@implementation REMTrendChartSeries
-(REMTrendChartSeries*)initWithData:(NSArray*)energyData dataStep:(REMEnergyStep)step {
    REMTrendChartDataProcessor* processor = [[REMTrendChartDataProcessor alloc]init];
    return [self initWithData:energyData dataStep:step dataProcessor:processor];
}
-(REMTrendChartSeries*)initWithData:(NSArray*)energyData dataStep:(REMEnergyStep)step dataProcessor:(REMTrendChartDataProcessor*)processor {
    return [self initWithData:energyData dataStep:step dataProcessor:processor yAxisIndex:0];
}
-(REMTrendChartSeries*)initWithData:(NSArray*)energyData dataStep:(REMEnergyStep)step dataProcessor:(REMTrendChartDataProcessor*)processor yAxisIndex:(int)yAxisIndex {
    return [self initWithData:energyData dataStep:step dataProcessor:processor yAxisIndex:yAxisIndex startDate:((REMEnergyData*)[energyData objectAtIndex:0]).localTime];
}
-(REMTrendChartSeries*)initWithData:(NSArray*)energyData dataStep:(REMEnergyStep)step dataProcessor:(REMTrendChartDataProcessor*)processor yAxisIndex:(int)yAxisIndex startDate:(NSDate*)startDate {
    self = [super init];
    if (self) {
        _yAxisIndex = 0;
        seriesType = [self getSeriesType];
        _startDate = startDate;
        _plot = [self makePlot];
        NSMutableArray* data = [[NSMutableArray alloc]init];
        for (REMEnergyData *p in energyData) {
            [data addObject:[processor processEnergyData:p startDate:startDate step:step]];
        }
        _points = data;
    }
    return self;
}
-(CPTPlot*)makePlot {
    return nil;
}
-(REMTrendChartSeriesType)getSeriesType {
    return 0;
}
-(int)getXAxisField {
    return 0;
}



- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    REMTrendChartPoint* point = [self.points objectAtIndex:idx];
    if (fieldEnum == [self getXAxisField]) {
        return [NSNumber numberWithFloat:point.x];
    } else {
        return point.y;
    }
}
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return self.points.count;
}

@end
