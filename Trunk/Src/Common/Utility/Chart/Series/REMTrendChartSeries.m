/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTrendChartSeries.m
 * Created      : Zilong-Oscar.Xu on 9/13/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMChartHeader.h"

@implementation REMTrendChartSeries
-(UIColor*)getSeriesColor {
    return color.uiColor;
}

-(REMChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMTrendChartDataProcessor*)processor plotStyle:(NSDictionary*)plotStyle {
//    NSDate* startDate = energyData.count > 0 ? ((REMEnergyData*)[energyData objectAtIndex:0]).localTime : [NSDate date];
//    if (![startDate isEqualToDate:processor.baseDate]) {
//        REMEnergyStep step = processor.step;
//        processor = [[REMTrendChartDataProcessor alloc]init];
//        processor.baseDate = startDate;
//        processor.step = step;
//    }
    self = [super initWithData:energyData dataProcessor:processor plotStyle:plotStyle];
    if (self) {
        source = [[NSMutableArray alloc]init];
        _yScale = @(1);
        if (energyData.count == 0 || processor == nil) {
            _maxX = 0;
            _minX = energyData.count - 1;
        } else {
            _minX = [processor processX:[[energyData objectAtIndex:0] localTime]].floatValue;
            _maxX = [processor processX:[[energyData objectAtIndex:(energyData.count-1)] localTime]].floatValue;
        }
    }
    return self;
}
-(void)beforePlotAddToGraph:(CPTGraph*)graph seriesList:(NSArray*)seriesList selfIndex:(uint)selfIndex {
    color = [REMColor colorByIndex:selfIndex];
    diabledColor = [CPTColor colorWithCGColor:[color.uiColor colorWithAlphaComponent:0.5].CGColor];
    [super beforePlotAddToGraph:graph seriesList:seriesList selfIndex:selfIndex];
    CPTXYAxis* yAxis = (CPTXYAxis*)[graph.axisSet.axes objectAtIndex:self.yAxisIndex + 1];
    plot.plotSpace = yAxis.plotSpace;
}
-(void)setYScale:(NSNumber *)yScale {
    if ([yScale isEqualToNumber:self.yScale]) return;
    _yScale = yScale;
    [[self getPlot]reloadData];
}

-(void)setVisableRange:(NSRange)visableRange {
    if(visableRange.location != self.visableRange.location || visableRange.length != self.visableRange.length) {
        [source removeAllObjects];
        _visableRange = visableRange;
        [self cacheDataOfRange];
    }
}

-(void)cacheDataOfRange {
    NSUInteger index = self.visableRange.location;
    
    NSUInteger endLocation = self.visableRange.location + self.visableRange.length + 2;
    for (REMEnergyData* data in self.energyData) {
        int xVal = [self.dataProcessor processX:data.localTime].intValue;
        if (xVal < 0 || xVal < self.visableRange.location) continue;
        if (xVal > endLocation) break;
        while (index != xVal) {
            [source addObject:@{@"x":@(index), @"y":[NSNull null], @"enenrgydata":[NSNull null]}];
            index++;
        }
        [source addObject:@{@"x":@(xVal), @"y":[self.dataProcessor processY:data.dataValue], @"enenrgydata":data}];
        index++;
        
    }
    while (index < endLocation) {
        [source addObject:@{@"x":@(index), @"y":[NSNull null], @"enenrgydata":[NSNull null]}];
        index++;
    }
    [[self getPlot]reloadData];
}

-(NSUInteger)getIndexOfCachePointByCoordinate:(double)xCoordinate {
    int roundX = floor(xCoordinate-0.5);
    NSUInteger i = 0;
    for (NSDictionary* dic in source) {
        if (((NSNumber*)dic[@"x"]).intValue == roundX)
            break;
        i++;
    }
    if (i >= self.visableRange.length) i = self.visableRange.length;
    return i;
}

-(NSArray*)getCurrentRangeSource {
    return source;
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return self.visableRange.length+2;
}

-(BOOL)isOccupy {
    return occupy;
}


-(NSNumber*)maxYInCache {
    NSNumber* maxY = [NSNumber numberWithInt:0];
    
    for (NSDictionary* dic in source) {
        NSNumber* yVal = dic[@"y"];
        if (yVal == nil || yVal == NULL || [yVal isEqual:[NSNull null]] || [yVal isLessThan:([NSNumber numberWithInt:0])]) continue;
        if ([maxY isLessThan:yVal]) {
            maxY = yVal;
        }
    }
    return maxY;
}
-(void)highlightAt:(NSUInteger)index {
    highlightIndex = @(index);
    [[self getPlot]reloadData];
}

-(void)dehighlight {
    highlightIndex = nil;
    [[self getPlot]reloadData];
}
@end
