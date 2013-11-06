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

-(REMChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMChartDataProcessor*)processor plotStyle:(NSDictionary*)plotStyle {
    NSDate* startDate = energyData.count > 0 ? ((REMEnergyData*)[energyData objectAtIndex:0]).localTime : [NSDate date];
    return [self initWithData:energyData dataProcessor:processor plotStyle:plotStyle startDate:startDate];
}
-(REMChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMChartDataProcessor*)processor plotStyle:(NSDictionary*)plotStyle startDate:(NSDate*)startDate {
    self = [super initWithData:energyData dataProcessor:processor plotStyle:plotStyle];
    if (self) {
        source = [[NSMutableArray alloc]init];
        _yScale = @(1);
        _startDate = startDate;
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
    NSDate* startDate = [self.dataProcessor deprocessX:self.visableRange.location];
    NSDate* endDate = [self.dataProcessor deprocessX:self.visableRange.length+self.visableRange.location+2];
    
    NSUInteger index = 0;
    REMEnergyData* data = nil;
    NSUInteger allDataCount = self.energyData.count;
    while (index < allDataCount) {
        data = self.energyData[index];
        index++;
        if ([data.localTime compare:startDate]==NSOrderedAscending) continue;
        if ([data.localTime compare:endDate]==NSOrderedDescending) break;
        [source addObject:@{@"x":[self.dataProcessor processX:data.localTime], @"y":[self.dataProcessor processY:data.dataValue], @"enenrgydata":data}];
    }
    [[self getPlot]reloadData];
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
@end
