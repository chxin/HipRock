//
//  REMTrendChartSeries.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/13/13.
//
//

#import "REMChartHeader.h"

@implementation REMTrendChartSeries
-(REMTrendChartSeries*)initWithData:(NSArray*)energyData dataStep:(REMEnergyStep)step plotStyle:(NSDictionary*)plotStyle {
    return [self initWithData:energyData dataStep:step plotStyle:plotStyle yAxisIndex:0];
}
-(REMTrendChartSeries*)initWithData:(NSArray*)energyData dataStep:(REMEnergyStep)step plotStyle:(NSDictionary*)plotStyle yAxisIndex:(int)yAxisIndex {
    return [self initWithData:energyData dataStep:step plotStyle:plotStyle yAxisIndex:yAxisIndex dataProcessor:
            [[REMTrendChartDataProcessor alloc]init]];
}

-(REMTrendChartSeries*)initWithData:(NSArray*)energyData dataStep:(REMEnergyStep)step plotStyle:(NSDictionary*)plotStyle yAxisIndex:(int)yAxisIndex dataProcessor:(REMTrendChartDataProcessor*)processor {
    return [self initWithData:energyData dataStep:step plotStyle:plotStyle yAxisIndex:yAxisIndex dataProcessor:processor startDate:((REMEnergyData*)[energyData objectAtIndex:0]).localTime];
}

-(REMTrendChartSeries*)initWithData:(NSArray*)energyData dataStep:(REMEnergyStep)step plotStyle:(NSDictionary*)plotStyle yAxisIndex:(int)yAxisIndex dataProcessor:(REMTrendChartDataProcessor*)processor startDate:(NSDate*)startDate {
    self = [super init];
    if (self) {
        _yAxisIndex = 0;
        _plotStyle = plotStyle;
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
-(void)beforePlotAddToGraph:(CPTGraph*)graph seriesList:(NSArray*)seriesList selfIndex:(uint)selfIndex {
    self.plot.frame = graph.bounds;
    CPTXYAxis* yAxis = (CPTXYAxis*)[graph.axisSet.axes objectAtIndex:self.yAxisIndex + 1];
    self.plot.plotSpace = yAxis.plotSpace;
}
-(REMTrendChartSeriesType)getSeriesType {
    return 0;
}
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return self.points.count;
}

@end
