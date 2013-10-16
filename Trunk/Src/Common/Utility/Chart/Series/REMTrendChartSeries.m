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
    NSDate* startDate = energyData.count > 0 ? ((REMEnergyData*)[energyData objectAtIndex:0]).localTime : [NSDate date];
    return [self initWithData:energyData dataProcessor:processor plotStyle:plotStyle yAxisIndex:yAxisIndex dataStep:step startDate:startDate];
}
-(REMChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMChartDataProcessor*)processor plotStyle:(NSDictionary*)plotStyle yAxisIndex:(int)yAxisIndex dataStep:(REMEnergyStep)step startDate:(NSDate*)startDate {
    self = [super initWithData:energyData dataProcessor:processor plotStyle:plotStyle];
    if (self) {
        _startDate = startDate;
        _step = step;
        _yAxisIndex = yAxisIndex;
        if (energyData.count == 0) {
            _maxX = 0;
            _minX = 0;
        } else {
            _minX = [processor processX:[[energyData objectAtIndex:0] localTime] startDate:startDate step:step].floatValue;
            _maxX = [processor processX:[[energyData objectAtIndex:(energyData.count-1)] localTime] startDate:startDate step:step].floatValue;
        }
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
