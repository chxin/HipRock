//
//  REMTrendChartScatterSeries.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by Zilong-Oscar.Xu on 9/13/13.
//
//

#import "REMChartHeader.h"

@implementation REMTrendChartLineSeries
-(REMChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMChartDataProcessor*)processor plotStyle:(NSDictionary*)plotStyle startDate:(NSDate*)startDate {
    self = [super initWithData:energyData dataProcessor:processor plotStyle:plotStyle startDate:startDate];
    occupy = NO;
    plot = [[CPTScatterPlot alloc]init];
    return self;
}

-(void)beforePlotAddToGraph:(CPTGraph*)graph seriesList:(NSArray*)seriesList selfIndex:(uint)selfIndex {
    [super beforePlotAddToGraph:graph seriesList:seriesList selfIndex:selfIndex];
    CPTScatterPlot* myPlot = (CPTScatterPlot*)plot;
    
    CPTLineStyle* lineStyle = (self.plotStyle == nil ? nil : [self.plotStyle objectForKey:@"lineStyle"]);
    CPTPlotSymbol* plotSymbol = (self.plotStyle == nil ? nil : [self.plotStyle objectForKey:@"symbol"]);
    
    if (lineStyle == nil) {
        CPTMutableLineStyle* mutStyle = [[CPTMutableLineStyle alloc]init];
        mutStyle.lineWidth = 2;
        mutStyle.lineColor = [REMColor colorByIndex:selfIndex];
        lineStyle = mutStyle;
    }
    if (plotSymbol == nil) {
        plotSymbol = [self getSymbol:selfIndex];
        plotSymbol.fill = [CPTFill fillWithColor:lineStyle.lineColor];
        plotSymbol.size = CGSizeMake(12.0, 12.0);
        plotSymbol.lineStyle = nil;
    }
    myPlot.dataLineStyle = lineStyle;
    myPlot.plotSymbol = plotSymbol;
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
    REMEnergyData* point = [self.energyData objectAtIndex:idx];
    if (fieldEnum == CPTScatterPlotFieldX) {
        return [self.dataProcessor processX:point.localTime];
    } else if (fieldEnum == CPTScatterPlotFieldY) {
        return [self.dataProcessor processY:point.dataValue];
    } else {
        return nil;
    }
}
@end
