//
//  REMTrendChartScatterSeries.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/13/13.
//
//

#import "REMChartHeader.h"

@implementation REMTrendChartLineSeries
-(CPTPlot*)makePlot {
    CPTScatterPlot* plot = [[CPTScatterPlot alloc]init];
    plot.dataSource = self;
    plot.delegate = self;
    return plot;
}
-(REMTrendChartSeriesType)getSeriesType {
    return REMTrendChartSeriesTypeLine;
}

-(void)beforePlotAddToGraph:(CPTGraph*)graph seriesList:(NSArray*)seriesList selfIndex:(uint)selfIndex {
    [super beforePlotAddToGraph:graph seriesList:seriesList selfIndex:selfIndex];
    CPTScatterPlot* plot = (CPTScatterPlot*)self.plot;
    
    CPTLineStyle* lineStyle = (self.plotStyle == nil ? nil : [self.plotStyle objectForKey:@"lineStyle"]);
    CPTPlotSymbol* plotSymbol = (self.plotStyle == nil ? nil : [self.plotStyle objectForKey:@"symbol"]);
    
    if (lineStyle == nil) {
        CPTMutableLineStyle* mutStyle = [[CPTMutableLineStyle alloc]init];
        mutStyle.lineWidth = 2;
        mutStyle.lineColor = [REMColor colorByIndex:selfIndex];
    }
    if (plotSymbol == nil) {
        plotSymbol = [self getSymbol:selfIndex];
        plotSymbol.fill = [CPTFill fillWithColor:lineStyle.lineColor];
        plotSymbol.size = CGSizeMake(12.0, 12.0);
        plotSymbol.lineStyle = nil;
    }
    plot.dataLineStyle = lineStyle;
    plot.plotSymbol = plotSymbol;
}

- (CPTPlotSymbol*) getSymbol:(uint)index {
    CPTPlotSymbol *symbol;
    switch (index) {
        case 0:
            symbol = [CPTPlotSymbol diamondPlotSymbol];
            break;
        case 1:
            symbol=    [CPTPlotSymbol rectanglePlotSymbol];
            break;
        case 2:
            symbol=[CPTPlotSymbol trianglePlotSymbol];
            break;
        case 3:
            symbol=[CPTPlotSymbol snowPlotSymbol];
            break;
        case 4:
            symbol =[CPTPlotSymbol starPlotSymbol];
            break;
        case 5:
            symbol=[CPTPlotSymbol pentagonPlotSymbol];
            break;
        case 6:
            symbol = [CPTPlotSymbol hexagonPlotSymbol];
            break;
        case 7:
            symbol = [CPTPlotSymbol ellipsePlotSymbol];
            break;
        case 8:
            symbol=[CPTPlotSymbol crossPlotSymbol];
            break;
        case 9:
            symbol=[CPTPlotSymbol plusPlotSymbol];
            break;
        default:
            symbol = [CPTPlotSymbol diamondPlotSymbol];
            break;
    }
    return symbol;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    REMTrendChartPoint* point = [self.points objectAtIndex:idx];
    if (fieldEnum == CPTScatterPlotFieldX) {
        return [NSNumber numberWithFloat:point.x];
    } else if (fieldEnum == CPTScatterPlotFieldY) {
        return point.y;
    } else {
        return nil;
    }
}
@end
