//
//  _DCCoordinateSystem.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/12/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "_DCCoordinateSystem.h"
#import "DCDataPoint.h"
#import "DCXYSeries.h"
#import "DCUtility.h"
#import "_DCColumnsLayer.h"
#import "DCXYChartView.h"
#import "_DCYAxisLabelLayer.h"
#import "REMNumberExtension.h"

@interface _DCCoordinateSystem()

@property (nonatomic, strong) NSMutableArray* yIntervalObservers;

//@property (nonatomic, strong) NSNumber* currentYMaxValue;
//@property (nonatomic, strong) NSNumber* currentYMinValue;
@property (nonatomic, strong) DCRange* latestValueRange; // The latest xRange when recalculatorYMaxInRange called

@end

@implementation _DCCoordinateSystem

-(id)initWithChartView:(DCXYChartView*)chartView name:(NSString *)name {
    self = [self init];
    if (self) {
        _graphContext = chartView.graphContext;
        _seriesList = [[NSMutableArray alloc]init];
        _xAxis = chartView.xAxis;
        _chartView = chartView;
        _name = name;
        
        DCAxis* y = [[DCAxis alloc]init];
        y.coordinate = DCAxisCoordinateY;
        y.coordinateSystem = self;
        
        _yAxis = y;
        _columnGroupSeriesDic = [[NSMutableDictionary alloc]init];
        
        [self.graphContext addHRangeObsever:self];
        
        _DCYAxisLabelLayer* yLabelLayer = [[_DCYAxisLabelLayer alloc]initWithContext:self.graphContext view:self.chartView];
        yLabelLayer.axis = self.yAxis;
        _yAxisLabelLayer = yLabelLayer;
        [self addYIntervalObsever:yLabelLayer];
    }
    return self;
}

-(void)attachSeries:(DCXYSeries*)series {
    if (![self.seriesList containsObject:series]) {
        series.coordinate = self;
        NSMutableArray* seriesList= (NSMutableArray*)self.seriesList;
        [seriesList addObject:series];
//        [self.graphContext addHRangeObsever:series];
        
        if (series.type == DCSeriesTypeColumn) {
            DCColumnSeriesGroup* groupSeriesList = self.columnGroupSeriesDic[series.groupName];
            if (REMIsNilOrNull(groupSeriesList)) {
                groupSeriesList = [[DCColumnSeriesGroup alloc]initWithGroupName:series.groupName coordinateSystem:self];
                [self.columnGroupSeriesDic setObject:groupSeriesList forKey:series.groupName];
            }
            if (![groupSeriesList containsSeries:series]) {
                [groupSeriesList addSeries:series];
            }
            series.seriesGroup = groupSeriesList;
        }
    }
}

-(void)detachSeries:(DCXYSeries*)series {
    if ([self.seriesList containsObject:series]) {
        series.coordinate = nil;
        NSMutableArray* seriesList= (NSMutableArray*)self.seriesList;
        [seriesList removeObject:series];
//        [self.graphContext removeHRangeObsever:series];
        
        if (series.type == DCSeriesTypeColumn) {
            DCColumnSeriesGroup* groupSeriesList = self.columnGroupSeriesDic[series.groupName];
            if (!REMIsNilOrNull(groupSeriesList) && [groupSeriesList containsSeries:series]) {
                [groupSeriesList removeSeries:series];
                if (groupSeriesList.count == 0) {
                    [self.columnGroupSeriesDic removeObjectForKey:series.groupName];
                }
            }
        }
    }
}

-(void)willHRangeChanged:(DCRange *)oldRange newRange:(DCRange *)newRange {
    if ([DCRange isRange:oldRange equalTo:newRange]) return;
    
    if (self.graphContext) {
        if (REMIsNilOrNull(self.latestValueRange) ||
            ceil(self.latestValueRange.location) != ceil(newRange.location) ||
            ceil(self.latestValueRange.end) != ceil(newRange.end)) {
            [self recalculatorYMaxInRange:newRange];
        }
    }
}

-(void)recalculatorYMaxInRange:(DCRange*)range {
    self.latestValueRange = [[DCRange alloc]initWithLocation:range.location length:range.length];
    
    // 计算可视区域内的Y的最大值currentYRange
    double currentYMax = INT32_MIN;
    double currentYMin = INT32_MAX;
    
    
    int start = floor(range.location);
    int end = ceil(range.end);
    start = start < 0 ? 0 : start;
    
    // Column序列
    for (DCColumnSeriesGroup* groupSeriesList in self.columnGroupSeriesDic.allValues) {
        for (int i = start; i <= end; i++) {
            double yValAtIndex = 0;
            for (DCXYSeries* s in groupSeriesList.allSeries) {
                if (s.hidden) continue;
                if (i >= s.datas.count) break;
                DCDataPoint* p = s.datas[i];
                if (p.value == nil || [p.value isEqual:[NSNull null]]) continue;
                yValAtIndex+=p.value.doubleValue;
            }
            if (yValAtIndex > currentYMax) {
                currentYMax = yValAtIndex;
            }
            if (yValAtIndex < currentYMin) {
                currentYMin = yValAtIndex;
            }
        }
    }
    
    
    // Line序列
    for (DCXYSeries* series in self.seriesList) {
        if (series.type != DCSeriesTypeLine || start >= series.datas.count) continue;
        int seriesEnd = (end >= series.datas.count ? (series.datas.count - 1) : end);
        if(!REMIsNilOrNull(series.visableYMaxThreshold) && currentYMax < series.visableYMaxThreshold.doubleValue) {
            currentYMax = series.visableYMaxThreshold.doubleValue;
        }
        // 从RangeStart向前再搜索一个非空点
        for (int j = start-1; j >= 0; j--) {
            DCDataPoint* point = series.datas[j];
            if (point.pointType == DCDataPointTypeEmpty) {
                continue;
            } else if (point.pointType == DCDataPointTypeBreak) {
                break;
            } else {
                double pointValue = point.value.doubleValue;
                if (pointValue > currentYMax) {
                    currentYMax = pointValue;
                }
                if (pointValue < currentYMin) {
                    currentYMin = pointValue;
                }
                break;
            }
        }
        // 搜索图形的主要部分
        for (int j = start; j <= seriesEnd; j++) {
            DCDataPoint* point = series.datas[j];
            if (point.pointType == DCDataPointTypeNormal) {
                double pointValue = point.value.doubleValue;
                if (pointValue > currentYMax) {
                    currentYMax = pointValue;
                }
                if (pointValue < currentYMin) {
                    currentYMin = pointValue;
                }
            }
        }
        // 从RangeEnd向前后搜索一个非空点
        for (int j = seriesEnd+1; j < series.datas.count; j++) {
            DCDataPoint* point = series.datas[j];
            if (point.pointType == DCDataPointTypeEmpty) {
                continue;
            } else if (point.pointType == DCDataPointTypeBreak) {
                break;
            } else {
                double pointValue = point.value.doubleValue;
                if (pointValue > currentYMax) {
                    currentYMax = pointValue;
                }
                if (pointValue < currentYMin) {
                    currentYMin = pointValue;
                }
                break;
            }
        }
    }
    
    if (currentYMax == INT32_MIN) currentYMax = 0;
    if (currentYMin == INT32_MAX) currentYMin = 0;
    
    // 根据maxY计算YRange并通知所有的YRangeObserver
    DCYAxisIntervalCalculation calResult = [DCUtility calculatorYAxisByMin:currentYMin yMax:currentYMax parts:self.graphContext.hGridlineAmount];
    DCRange* newYRange = [[DCRange alloc]initWithLocation:0 length:calResult.yMax];
    if ([self testYRange:newYRange visableMax:currentYMax visableMin:currentYMin]) {
        _yRange = newYRange;
        self.heightUnitInScreen = (self.yRange != nil && self.yRange.length > 0) ? (self.graphContext.plotRect.size.height / self.yRange.length) : 0;
        self.yInterval = calResult.yInterval;
    }
}

-(void)setYInterval:(double)yInterval {
    if (_yInterval == yInterval) return;
    double oldInterval = self.yInterval;
    _yInterval = yInterval;
    
    for (id o in self.yIntervalObservers) {
        if ([o respondsToSelector:@selector(didYIntervalChanged:newInterval:yRange:)]) {
            [o didYIntervalChanged:oldInterval newInterval:yInterval yRange:self.yRange];
        }
    }
    DCXYChartView* chartView = (DCXYChartView*)self.chartView;
    if (chartView.delegate != nil && [chartView.delegate respondsToSelector:@selector(didYIntervalChange:forAxis:range:)]) {
        [chartView.delegate didYIntervalChange:yInterval forAxis:self.yAxis range:self.yRange];
    }
}
-(void)addYIntervalObsever:(id<DCContextYIntervalObserverProtocal>)observer {
    if (observer == nil) return;
    if (self.yIntervalObservers == nil) self.yIntervalObservers = [[NSMutableArray alloc]init];
    if (![self.yIntervalObservers containsObject:observer]) [self.yIntervalObservers addObject:observer];
}
-(void)removeYIntervalObsever:(id<DCContextYIntervalObserverProtocal>)observer {
    if (self.yIntervalObservers == nil || self.yIntervalObservers.count==0) return;
    for (id o in self.yIntervalObservers) {
        if (o == observer) {
            [self.yIntervalObservers removeObject:o];
            break;
        }
    }
}
-(void)clearYIntervalObsevers {
    [self.yIntervalObservers removeAllObjects];
}

/***
 * 测试新的YRange是否需要被更新至Context。
 * 条件：yRange的变化超过50%。
 * 或：maxY的值已经超过了现有的YRange。
 ***/
-(BOOL)testYRange:(DCRange*)newRange visableMax:(double)max visableMin:(double)min {
    if ([DCRange isRange:newRange equalTo:self.yRange]) return NO;
    if (max > self.yRange.end) {
        return YES;
    }
    if (self.yRange.end * 0.75 < (max+min)/2) {
        return YES;   // 中值超过现有Range的75%
    }
    
    // 变化是否超过50%
    double currentYLength = self.yRange.length;
    double willYLength = newRange.length;
    if (REMIsNilOrNull(self.yRange) || self.yRange.length == 0 ||
        (willYLength > currentYLength && ((willYLength - currentYLength) / currentYLength >= 0.5)) ||
        (willYLength < currentYLength && ((currentYLength - willYLength) / willYLength >= 0.5))) {
        return YES;
    }
    
    return NO;
}

@end
