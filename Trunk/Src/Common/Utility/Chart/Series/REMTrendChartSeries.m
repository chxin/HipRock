//
//  REMTrendChartSeries.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by Zilong-Oscar.Xu on 9/13/13.
//
//

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
//    NSDate* endDate = [self.dataProcessor deprocessX:self.visableRange.length+self.visableRange.location+2];
    
    NSUInteger index = 0;
    REMEnergyData* data = nil;
    NSUInteger allDataCount = self.energyData.count;
    while (index < allDataCount) {
        data = self.energyData[index];
        index++;
        if ([data.localTime compare:startDate]==NSOrderedAscending) continue;
        int processedX = [self.dataProcessor processX:data.localTime].intValue;
        if (processedX >= self.visableRange.length+self.visableRange.location+2) break;
        if (processedX == index - 1) {
            [source addObject:@{@"x":@(index-1), @"y":[self.dataProcessor processY:data.dataValue], @"enenrgydata":data}];
        } else {
            [source addObject:@{@"x":@(index-1), @"y":[NSNull null], @"enenrgydata":[NSNull null]}];
        }
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
