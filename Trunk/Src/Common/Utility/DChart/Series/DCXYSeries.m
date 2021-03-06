//
//  DCXYSeries.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/8/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "DCXYSeries.h"
#import "DCDataPoint.h"
#import "_DCSeriesLayer.h"

@implementation DCXYSeries

-(DCSeries*)initWithEnergyData:(NSArray*)seriesData {
    self = [super initWithEnergyData:seriesData];
    if (self) {
        _hidden = NO;
        _lineWidth = 2;
        _symbolType = DCLineSymbolTypeNone;
        _symbolSize = 4;
        self.type = DCSeriesTypeLine;
    }
    return self;
}

//-(void)copyFromSeries:(DCXYSeries*)series {
//    _coordinate = series.coordinate;
//    _target = series.target;
//    self.color = series.color;
//    _visableYMaxThreshold = series.visableYMaxThreshold;
//    self.datas = series.datas;
//    for (DCDataPoint* p in self.datas) {
//        p.series = self;
//    }
//    [self willHRangeChanged:nil newRange:series.visableRange];
//}

//-(void)willHRangeChanged:(DCRange *)oldRange newRange:(DCRange *)newRange {
//    if ([DCRange isRange:oldRange equalTo:newRange]) return;
//    if (REMIsNilOrNull(newRange)) return;
//    int start = floor(newRange.location);
//    start = start < 0 ? 0 : start;
//    int end = ceil(newRange.end);
//    end = end >= self.datas.count ? (self.datas.count - 1) : end;
//    DCRange* newVisableRange = [[DCRange alloc]initWithLocation:start length:end-start+1];
//    if ([DCRange isRange:self.visableRange equalTo:newVisableRange]) return;
//    _visableRange = newVisableRange;
//    
//    if (start >= self.datas.count) return;
//    NSNumber* yMax = nil;
//    NSNumber* yMin = nil;
//    if (self.type == DCSeriesTypeLine) {
//        // 从RangeStart向前再搜索一个非空点
//        for (int j = start-1; j >= 0; j--) {
//            DCDataPoint* point = self.datas[j];
//            if (point.pointType == DCDataPointTypeEmpty) {
//                continue;
//            } else if (point.pointType == DCDataPointTypeBreak) {
//                break;
//            } else {
//                if (REMIsNilOrNull(yMax) || [yMax compare:point.value] == NSOrderedAscending) {
//                    yMax = point.value;
//                }
//                if (REMIsNilOrNull(yMin) || [yMin compare:point.value] == NSOrderedDescending) {
//                    yMin = point.value;
//                }
//                break;
//            }
//        }
//    }
//    // 搜索图形的主要部分
//    for (int j = start; j <= end; j++) {
//        DCDataPoint* point = self.datas[j];
//        if (point.pointType == DCDataPointTypeNormal) {
//            if (REMIsNilOrNull(yMax) ||[yMax compare:point.value] == NSOrderedAscending) {
//                yMax = point.value;
//            }
//            if (REMIsNilOrNull(yMin) || [yMin compare:point.value] == NSOrderedDescending) {
//                yMin = point.value;
//            }
//        }
//    }
//    if (self.type == DCSeriesTypeLine) {
//        // 从RangeEnd向前后搜索一个非空点
//        for (int j = end+1; j < self.datas.count; j++) {
//            DCDataPoint* point = self.datas[j];
//            if (point.pointType == DCDataPointTypeEmpty) {
//                continue;
//            } else if (point.pointType == DCDataPointTypeBreak) {
//                break;
//            } else {
//                if (REMIsNilOrNull(yMax) || [yMax compare:point.value] == NSOrderedAscending) {
//                    yMax = point.value;
//                }
//                if (REMIsNilOrNull(yMin) || [yMin compare:point.value] == NSOrderedDescending) {
//                    yMin = point.value;
//                }
//                break;
//            }
//        }
//    }
//    _visableYMax = yMax;
//    _visableYMin = yMin;
//}

//-(void)setHidden:(BOOL)hidden {
//    if (hidden == _hidden) return;
//    _hidden = hidden;
//    [self.seriesLayer redraw];
//}
@end
