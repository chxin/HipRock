/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTrendChartScatterSeries.m
 * Created      : Zilong-Oscar.Xu on 9/13/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMChartHeader.h"

@implementation REMTrendChartLineSeries{
    CPTPlotSymbol* normalSymbol;
    CPTPlotSymbol* highlightedSymbol;
}
-(REMChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMChartDataProcessor*)processor plotStyle:(NSDictionary*)plotStyle {
    self = [super initWithData:energyData dataProcessor:processor plotStyle:plotStyle];
    occupy = NO;
    plot = [[CPTScatterPlot alloc]init];
    return self;
}

-(void)beforePlotAddToGraph:(CPTGraph*)graph seriesList:(NSArray*)seriesList selfIndex:(uint)selfIndex {
    [super beforePlotAddToGraph:graph seriesList:seriesList selfIndex:selfIndex];
    CPTScatterPlot* myPlot = (CPTScatterPlot*)plot;
    
    CPTLineStyle* lineStyle = (self.plotStyle == nil ? nil : [self.plotStyle objectForKey:@"lineStyle"]);
    
    if (lineStyle == nil) {
        CPTMutableLineStyle* mutStyle = [[CPTMutableLineStyle alloc]init];
        mutStyle.lineWidth = 2;
        mutStyle.lineColor = color;
        lineStyle = mutStyle;
    }
    normalSymbol = [self getSymbol:selfIndex];
    normalSymbol.fill = [CPTFill fillWithColor:color];
    normalSymbol.size = CGSizeMake(12.0, 12.0);
    normalSymbol.lineStyle = nil;
    
    highlightedSymbol = [self getSymbol:selfIndex];
    highlightedSymbol.fill = [CPTFill fillWithColor:diabledColor];
    highlightedSymbol.size = CGSizeMake(12.0, 12.0);
    CPTMutableLineStyle* hLine = [[CPTMutableLineStyle alloc]init];
    hLine.lineWidth = 3;
    hLine.lineColor = [CPTColor whiteColor];
    highlightedSymbol.lineStyle = hLine;
    
    myPlot.dataLineStyle = lineStyle;
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

-(CPTPlotSymbol *)symbolForScatterPlot:(CPTScatterPlot *)plot recordIndex:(NSUInteger)idx {
    if (highlightIndex != nil && highlightIndex.unsignedIntegerValue == idx) return highlightedSymbol;
    else return normalSymbol;
}
-(NSUInteger)getIndexOfCachePointByCoordinate:(double)xCoordinate {
    int roundX = floor(xCoordinate);
    NSUInteger i = 0;
    for (NSDictionary* dic in source) {
        if (((NSNumber*)dic[@"x"]).intValue == roundX)
            break;
        i++;
    }
    if (i >= self.visableRange.length) i = self.visableRange.length;
    if (i == 0) i = 1;
    return i;
}
@end
