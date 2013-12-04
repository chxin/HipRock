//
//  DCXYSeries.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/8/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "DCXYSeries.h"
#import "DCDataPoint.h"

@implementation DCXYSeries

-(DCSeries*)initWithEnergyData:(NSArray*)seriesData {
    self = [super initWithEnergyData:seriesData];
    if (self) {
        _hidden = NO;
//        _pointXOffset = 0;
    }
    return self;
}

-(void)willHRangeChanged:(DCRange *)oldRange newRange:(DCRange *)newRange {
    if ([DCRange isRange:oldRange equalTo:newRange]) return;
    if (newRange != nil && newRange.location < -0.5) return;
    int start = floor(newRange.location);
    int end = ceil(newRange.length+newRange.location);
    DCRange* newVisableRange = [[DCRange alloc]initWithLocation:start length:end-start+1];
    if ([DCRange isRange:self.visableRange equalTo:newVisableRange]) return;
    _visableRange = newVisableRange;
    
    start = start < 0 ? 0 : start;
    end = end >= self.datas.count ? (self.datas.count - 1) : end;
    if (start >= self.datas.count) return;
    NSNumber* y = @(0);
    // 从RangeStart向前再搜索一个非空点
    for (int j = start-1; j >= 0; j--) {
        DCDataPoint* point = self.datas[j];
        if (point.pointType == DCDataPointTypeEmpty) {
            continue;
        } else if (point.pointType == DCDataPointTypeBreak) {
            break;
        } else {
            if ([y compare:point.value] == NSOrderedAscending) {
                y = point.value;
            }
            break;
        }
    }
    // 搜索图形的主要部分
    for (int j = start; j <= end; j++) {
        DCDataPoint* point = self.datas[j];
        if (point.pointType == DCDataPointTypeNormal) {
            if ([y compare:point.value] == NSOrderedAscending) {
                y = point.value;
            }
        }
    }
    // 从RangeEnd向前后搜索一个非空点
    for (int j = end+1; j < self.datas.count; j++) {
        DCDataPoint* point = self.datas[j];
        if (point.pointType == DCDataPointTypeEmpty) {
            continue;
        } else if (point.pointType == DCDataPointTypeBreak) {
            break;
        } else {
            if ([y compare:point.value] == NSOrderedAscending) {
                y = point.value;
            }
            break;
        }
    }
    _visableYMax = y;
}

-(void)didHRangeChanged:(DCRange*)oldRange newRange:(DCRange*)newRange {
    // Nothing to do.
}

-(void)setHidden:(BOOL)hidden {
    if (hidden == self.hidden) return;
    if (hidden) {
        self.yAxis.visableSeriesAmount--;
        self.xAxis.visableSeriesAmount--;
    } else {
        self.yAxis.visableSeriesAmount++;
        self.xAxis.visableSeriesAmount++;
    }
    _hidden = hidden;
    if (self.seriesLayer) [self.seriesLayer setNeedsDisplay];
}

@end
