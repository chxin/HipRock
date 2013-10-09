//
//  REMChartSeries.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/12/13.
//
//

#import "REMChartHeader.h"

@implementation REMChartSeries
-(REMChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMChartDataProcessor*)processor plotStyle:(NSDictionary*)plotStyle {
    self = [super init];
    if (self) {
        _plotStyle = plotStyle;
        _dataProcessor = processor;
        _energyData = energyData;
    }
    return self;
}

-(void)beforePlotAddToGraph:(CPTGraph*)graph seriesList:(NSArray*)seriesList selfIndex:(uint)selfIndex {
    plot.frame = graph.bounds;
    plot.dataSource = self;
    plot.delegate = self;
    [CPTAnimation animate:plot
                 property:@"pieRadius"
                     from: 0
                       to: MIN(graph.bounds.size.height, graph.bounds.size.width) / 2
                 duration:0.5
                withDelay:0
           animationCurve:CPTAnimationCurveBounceOut
                 delegate:nil];
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return self.energyData.count;
}
-(CPTPlot*)getPlot {
    return plot;
}

@end
