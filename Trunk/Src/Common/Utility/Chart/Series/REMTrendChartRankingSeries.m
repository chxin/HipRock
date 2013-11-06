/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTrendChartRankingSeries.m
 * Created      : Zilong-Oscar.Xu on 10/23/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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

-(void)cacheDataOfRange {
    NSUInteger loopEnd = MIN(self.visableRange.location+self.visableRange.length, self.energyData.count);
    NSUInteger loopStart = MAX(0, self.visableRange.location);
    if (self.sortOrder == NSOrderedDescending) {
        for (NSUInteger i = loopEnd-1; i >= loopStart; i--) {
            REMEnergyData* data = self.energyData[i];
            [source addObject:@{@"x":@(self.energyData.count - i - 1), @"y":data.dataValue, @"enenrgydata":data}];
            if (i==0)break;
        }
    } else {
        for (NSUInteger i = loopStart; i < loopEnd; i++) {
            REMEnergyData* data = self.energyData[i];
            [source addObject:@{@"x":@(i), @"y":data.dataValue, @"enenrgydata":data}];
        }
    }
    [[self getPlot]reloadData];
}
@end
