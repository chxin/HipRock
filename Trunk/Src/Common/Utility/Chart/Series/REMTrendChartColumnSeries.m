//
//  REMTrendChartColumnSeries.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/13/13.
//
//

#import "REMChartHeader.h"

@implementation REMTrendChartColumnSeries
-(CPTPlot*)makePlot {
    CPTBarPlot* plot = [[CPTBarPlot alloc]init];
    plot.dataSource = self;
    plot.delegate = self;
    return plot;
}
-(REMTrendChartSeriesType)getSeriesType {
    return REMTrendChartSeriesTypeColumn;
}
-(void)beforePlotAddToGraph:(CPTGraph*)graph seriesList:(NSArray*)seriesList selfIndex:(uint)selfIndex {
    [super beforePlotAddToGraph:graph seriesList:seriesList selfIndex:selfIndex];
    CPTBarPlot* plot = (CPTBarPlot*)self.plot;
    
    CPTFill* plotFill = (self.plotStyle == nil ? nil : [self.plotStyle objectForKey:@"fill"]);
    
    if (plotFill == nil) {
        plotFill = [CPTFill fillWithColor:[REMColor colorByIndex:selfIndex]];
    }
    plot.fill = plotFill;
    plot.lineStyle = nil;
    
//    plot.barOffset = CPTDecimalFromFloat(0);
    plot.barWidth = CPTDecimalFromFloat(0.3);
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    REMTrendChartPoint* point = [self.points objectAtIndex:idx];
    if (fieldEnum == CPTBarPlotFieldBarLocation) {
        return [NSNumber numberWithFloat:point.x];
    } else if (fieldEnum == CPTBarPlotFieldBarTip) {
        return point.y;
    } else {
        return nil;
    }
}
@end
