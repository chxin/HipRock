//
//  REMTrendChartColumnSeries.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/13/13.
//
//

#import "REMChartHeader.h"

@implementation REMTrendChartColumnSeries
-(REMTrendChartSeries*)initWithData:(NSArray*)energyData dataStep:(REMEnergyStep)step plotStyle:(NSDictionary*)plotStyle yAxisIndex:(int)yAxisIndex dataProcessor:(REMTrendChartDataProcessor*)processor startDate:(NSDate*)startDate {
    self = [super initWithData:energyData dataStep:step plotStyle:plotStyle yAxisIndex:yAxisIndex dataProcessor:processor startDate:startDate];
    occupy = YES;
    plot = [[CPTBarPlot alloc]init];
    seriesType = REMTrendChartSeriesTypeColumn;
    return self;
}

-(void)beforePlotAddToGraph:(CPTGraph*)graph seriesList:(NSArray*)seriesList selfIndex:(uint)selfIndex {
    [super beforePlotAddToGraph:graph seriesList:seriesList selfIndex:selfIndex];
    CPTBarPlot* myPlot = (CPTBarPlot*)plot;
    
    CPTFill* plotFill = (self.plotStyle == nil ? nil : [self.plotStyle objectForKey:@"fill"]);
    
    if (plotFill == nil) {
        plotFill = [CPTFill fillWithColor:[REMColor colorByIndex:selfIndex]];
    }
    myPlot.fill = plotFill;
    myPlot.lineStyle = nil;
    
    float barWidth = 0;
    float barOffSet = 0;
    
    float occupySeriesCount = 0;
    float myIndexOfOccupy = 0;
    
    const float pointMargin = 0.2;
    const float barMargin = 0.08;
    
    for (REMTrendChartSeries* series in seriesList) {
        if ([series isOccupy]) {
            if (series == self) myIndexOfOccupy = occupySeriesCount;
            occupySeriesCount++;
        }
    }
    barWidth = 1 / (occupySeriesCount + pointMargin*2 + barMargin*(occupySeriesCount-1));
    barOffSet = ((pointMargin + 0.5 + myIndexOfOccupy + (myIndexOfOccupy * barMargin)) * barWidth) - 0.5;
    NSLog(@"barOffSet:%f", barOffSet);
    myPlot.barOffset = CPTDecimalFromFloat(barOffSet);
    myPlot.barWidth = CPTDecimalFromFloat(barWidth);
    
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    REMEnergyData* point = [self.energyData objectAtIndex:idx];
    if (fieldEnum == CPTBarPlotFieldBarLocation) {
        return [self.dataProcessor processX:point startDate:self.startDate step:self.step];
    } else if (fieldEnum == CPTBarPlotFieldBarTip) {
        return [self.dataProcessor processY:point startDate:self.startDate step:self.step];
    } else {
        return nil;
    }
}
@end
