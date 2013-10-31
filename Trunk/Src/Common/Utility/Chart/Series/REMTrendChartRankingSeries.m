//
//  REMTrendChartRankingSeries.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by Zilong-Oscar.Xu on 10/23/13.
//
//

#import "REMChartHeader.h"
#import "REMTargetEnergyData.h"

@interface REMTrendChartRankingSeries()
/****  ****/
@property (nonatomic) NSMutableDictionary* dataTargetIdDic; // { key: targetID, value: REMEnergyData }
@property (nonatomic) NSMutableDictionary* targetIdDic; // { key: targetID, value: REMEnergyTargetModel }
@end

@implementation REMTrendChartRankingSeries

-(REMChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMChartDataProcessor*)processor plotStyle:(NSDictionary*)plotStyle {
    return [self initWithData:energyData dataProcessor:processor plotStyle:plotStyle startDate:[NSDate dateWithTimeIntervalSince1970:0]];
}
-(REMChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMChartDataProcessor*)processor plotStyle:(NSDictionary*)plotStyle startDate:(NSDate*)startDate {
    NSMutableDictionary* dataTargetIdDic = [[NSMutableDictionary alloc]init];
    NSMutableDictionary* targetIdDic = [[NSMutableDictionary alloc]init];

    NSMutableArray* series0Data = [[NSMutableArray alloc]init];
    for (int i = 0; i < energyData.count; i++) {
        REMTargetEnergyData* seriesData = [energyData objectAtIndex:i];
        if (seriesData.energyData != nil && seriesData.energyData.count > 0) {
            REMEnergyData* dataPoint = [seriesData.energyData objectAtIndex:0];
            [series0Data addObject:dataPoint];
            [dataTargetIdDic setObject:dataPoint forKey:seriesData.target.targetId];
            [targetIdDic setObject:seriesData.target forKey:seriesData.target.targetId];
        }
    }
    self = [super initWithData:series0Data dataProcessor:processor plotStyle:plotStyle startDate:startDate];
    if (self) {
        self.dataTargetIdDic = dataTargetIdDic;
        self.targetIdDic = targetIdDic;
        self.sortOrder = NSOrderedAscending;
        [self quickSort:series0Data left:0 right:series0Data.count-1];
    }
    return self;
}

-(void)quickSort:(NSMutableArray*)energyList left:(int)left right:(int)right {
    if (left >= right) return;
    int index = [self sortUnit:energyList left:left right:right];
    [self quickSort:energyList left:left right:index-1];
    [self quickSort:energyList left:index+1 right:right];
}

-(int)sortUnit:(NSMutableArray*)energyList left:(int)left right:(int)right {
    REMEnergyData* keyPoint = [energyList objectAtIndex:left];
    NSNumber* key = [self getYValueOfEnergyData:keyPoint];
    
    while (left < right) {
        while ([[self getYValueOfEnergyData:[energyList objectAtIndex:right]] isGreaterThanOrEqualTo:key] && right > left)
            --right;
        
        energyList[left] = energyList[right];
        while ([[self getYValueOfEnergyData:[energyList objectAtIndex:left]] isLessThanOrEqualTo:key] && right > left)
            ++left;
        
        energyList[right] = energyList[left];
    }
    energyList[left] = keyPoint;
    return right;
}

-(NSNumber*)getYValueOfEnergyData:(REMEnergyData*)energyPoint {
    NSNumber* yValue = energyPoint.dataValue;
    if (yValue == nil || yValue == NULL|| [yValue isEqual:[NSNull null]]) return @(-1);
    else return yValue;
}

-(NSNumber*)maxYValBetween:(int)minX and:(int)maxX {
    NSNumber* maxY = [NSNumber numberWithInt:0];
    int loopStart = MAX(0, minX);
    int loopEnd = MIN(self.energyData.count, maxX);
    if (self.sortOrder == NSOrderedDescending) {
        loopStart = self.energyData.count-maxX;
        loopStart = MAX(0,loopStart);
        loopEnd = MIN(self.energyData.count, (self.energyData.count-minX));
    }
    for (int j = loopStart; j < loopEnd; j++) {
        NSNumber* yVal = [self numberForPlot:[self getPlot] field:CPTBarPlotFieldBarTip recordIndex:j];
        if (yVal == nil || yVal == NULL || [yVal isEqual:[NSNull null]] || [yVal isLessThan:([NSNumber numberWithInt:0])]) continue;
        if ([maxY isLessThan:yVal]) {
            maxY = yVal;
        }
    }
    return maxY;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    if (fieldEnum == CPTBarPlotFieldBarLocation) {
        return [NSNumber numberWithUnsignedInteger:((self.sortOrder == NSOrderedDescending) ? (self.energyData.count-idx-1) :idx)];
    } else if (fieldEnum == CPTBarPlotFieldBarTip) {
        REMEnergyData* point = [self.energyData objectAtIndex:idx];
        return point.dataValue;
    } else {
        return nil;
    }
}
@end
