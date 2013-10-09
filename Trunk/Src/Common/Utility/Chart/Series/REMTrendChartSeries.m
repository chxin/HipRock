//
//  REMTrendChartSeries.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/13/13.
//
//

#import "REMChartHeader.h"

@implementation REMTrendChartSeries

-(REMChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMChartDataProcessor*)processor plotStyle:(NSDictionary*)plotStyle yAxisIndex:(int)yAxisIndex dataStep:(REMEnergyStep)step {
    return [self initWithData:energyData dataProcessor:processor plotStyle:plotStyle yAxisIndex:yAxisIndex dataStep:step startDate:((REMEnergyData*)[energyData objectAtIndex:0]).localTime];
}
-(REMChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMChartDataProcessor*)processor plotStyle:(NSDictionary*)plotStyle yAxisIndex:(int)yAxisIndex dataStep:(REMEnergyStep)step startDate:(NSDate*)startDate {
    self = [super initWithData:energyData dataProcessor:processor plotStyle:plotStyle];
    if (self) {
        _startDate = startDate;
        _step = step;
        _yAxisIndex = yAxisIndex;
        _minX = [processor processX:[energyData objectAtIndex:0] startDate:startDate step:step].floatValue;
        _maxX = [processor processX:[energyData objectAtIndex:(energyData.count-1)] startDate:startDate step:step].floatValue;
    }
    return self;
}
-(void)beforePlotAddToGraph:(CPTGraph*)graph seriesList:(NSArray*)seriesList selfIndex:(uint)selfIndex {
    [super beforePlotAddToGraph:graph seriesList:seriesList selfIndex:selfIndex];
    CPTXYAxis* yAxis = (CPTXYAxis*)[graph.axisSet.axes objectAtIndex:self.yAxisIndex + 1];
    plot.plotSpace = yAxis.plotSpace;
}

-(BOOL)isOccupy {
    return occupy;
}

@end
