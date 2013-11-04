//
//  REMTrendChartSeries.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by Zilong-Oscar.Xu on 9/13/13.
//
//

#import "REMChartHeader.h"

@implementation REMTrendChartSeries

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
    if(visableRange.location != self.visableRange.location || visableRange.length == self.visableRange.length) {
        [source removeAllObjects];
        _visableRange = visableRange;
        NSDate* startDate = [self.dataProcessor deprocessX:visableRange.location];
        NSDate* endDate = [self.dataProcessor deprocessX:visableRange.length+visableRange.location];
        
        NSUInteger index = 0;
        REMEnergyData* data = nil;
        NSUInteger allDataCount = self.energyData.count;
        while (index < allDataCount) {
            data = self.energyData[index];
            index++;
            if ([data.localTime compare:startDate]==NSOrderedAscending) continue;
            if ([data.localTime compare:endDate]==NSOrderedDescending) continue;
            [source addObject:@{@"x":[self.dataProcessor processX:data.localTime], @"y":[self.dataProcessor processY:data.dataValue]}];
        }
        [[self getPlot]reloadData];
    }
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return self.visableRange.length;
}

-(BOOL)isOccupy {
    return occupy;
}

-(NSNumber*)maxYValBetween:(int)minX and:(int)maxX {
    NSNumber* maxY = [NSNumber numberWithInt:0];
    NSDate* xStartDate = [self.dataProcessor deprocessX:minX];
    NSDate* xEndDate = [self.dataProcessor deprocessX:maxX];
    /*效率还可以改善*/
    for (int j = 0; j < self.energyData.count; j++) {
        REMEnergyData* point = [self.energyData objectAtIndex:j];
        if ([point.localTime timeIntervalSinceDate:xStartDate] < 0) continue;
        if ([point.localTime timeIntervalSinceDate:xEndDate] > 0) break;
        NSNumber* yVal = [self.dataProcessor processY:point.dataValue];
        if (yVal == nil || yVal == NULL || [yVal isEqual:[NSNull null]] || [yVal isLessThan:([NSNumber numberWithInt:0])]) continue;
        if (maxY.floatValue < yVal.floatValue) {
            maxY = yVal;
        }
    }
    return maxY;
}
@end
