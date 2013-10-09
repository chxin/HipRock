//
//  REMTrendChartSeries.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/13/13.
//
//

#import "REMChartHeader.h"

@implementation REMTrendChartSeries
//-(REMTrendChartSeries*)initWithData:(NSArray*)energyData dataStep:(REMEnergyStep)step plotStyle:(NSDictionary*)plotStyle {
//    return [self initWithData:energyData dataStep:step plotStyle:plotStyle yAxisIndex:0];
//}
//-(REMTrendChartSeries*)initWithData:(NSArray*)energyData dataStep:(REMEnergyStep)step plotStyle:(NSDictionary*)plotStyle yAxisIndex:(int)yAxisIndex {
//    return [self initWithData:energyData dataStep:step plotStyle:plotStyle yAxisIndex:yAxisIndex dataProcessor:
//            [[REMTrendChartDataProcessor alloc]init]];
//}

-(REMTrendChartSeries*)initWithData:(NSArray*)energyData dataStep:(REMEnergyStep)step plotStyle:(NSDictionary*)plotStyle yAxisIndex:(int)yAxisIndex dataProcessor:(REMTrendChartDataProcessor*)processor {
    return [self initWithData:energyData dataStep:step plotStyle:plotStyle yAxisIndex:yAxisIndex dataProcessor:processor startDate:((REMEnergyData*)[energyData objectAtIndex:0]).localTime];
}

-(REMTrendChartSeries*)initWithData:(NSArray*)energyData dataStep:(REMEnergyStep)step plotStyle:(NSDictionary*)plotStyle yAxisIndex:(int)yAxisIndex dataProcessor:(REMTrendChartDataProcessor*)processor startDate:(NSDate*)startDate {
    self = [super init];
    if (self) {
        _step = step;
        _plotStyle = plotStyle;
        _yAxisIndex = yAxisIndex;
        _dataProcessor = processor;
        _startDate = startDate;
        _energyData = energyData;
        _minX = [processor processX:[energyData objectAtIndex:0] startDate:startDate step:step].floatValue;
        _maxX = [processor processX:[energyData objectAtIndex:(energyData.count-1)] startDate:startDate step:step].floatValue;
//        NSMutableArray* data = [[NSMutableArray alloc]init];
//        for (REMEnergyData *p in energyData) {
//            [data addObject:[processor processEnergyData:p startDate:startDate step:step]];
//        }
//        _points = data;
    }
    return self;
}
-(void)beforePlotAddToGraph:(CPTGraph*)graph seriesList:(NSArray*)seriesList selfIndex:(uint)selfIndex {
    plot.frame = graph.bounds;
    plot.dataSource = self;
    plot.delegate = self;
    CPTXYAxis* yAxis = (CPTXYAxis*)[graph.axisSet.axes objectAtIndex:self.yAxisIndex + 1];
    plot.plotSpace = yAxis.plotSpace;
}
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return self.energyData.count;
}
-(CPTPlot*)getPlot {
    return plot;
}
-(BOOL)isOccupy {
    return occupy;
}

@end
