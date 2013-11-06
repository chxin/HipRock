/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTrendChartScatterSeries.m
 * Created      : Zilong-Oscar.Xu on 9/13/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
        color = [REMColor colorByIndex:selfIndex];
        mutStyle.lineColor = color;
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
    if(source.count<=idx){
        return nil;
    }
    NSDictionary* point = source[idx];
    if (fieldEnum == CPTScatterPlotFieldX) {
        return point[@"x"];
    } else if (fieldEnum == CPTScatterPlotFieldY) {
        NSNumber* yVal =  point[@"y"];;
        if ([yVal isEqual:[NSNull null]]) return yVal;
        else {
            return [NSNumber numberWithDouble: yVal.doubleValue / self.yScale.doubleValue];
        }
    } else {
        return nil;
    }
}
@end
