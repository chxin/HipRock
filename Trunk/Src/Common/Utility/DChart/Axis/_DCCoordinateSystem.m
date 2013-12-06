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
#import "_DCLinesLayer.h"
#import "DCXYChartView.h"
#import "_DCYAxisLabelLayer.h"

@interface _DCCoordinateSystem()
@property (nonatomic, strong) NSMutableArray* visableSeries;

@property (nonatomic, strong) _DCYAxisLabelLayer* _yLabelLayer;

//@property (nonatomic, strong) NSMutableArray* yRangeObservers;
@property (nonatomic, strong) NSMutableArray* yIntervalObservers;
@end

@implementation _DCCoordinateSystem

-(id)initWithChartView:(DCXYChartView*)chartView y:(DCAxis*)y {
    self = [self init];
    if (self) {
        _graphContext = chartView.graphContext;
        NSMutableArray* seriesList = [[NSMutableArray alloc]init];
        for (DCXYSeries* s in chartView.seriesList) {
            if (s.yAxis == y) {
                [self.graphContext addHRangeObsever:s];
                [seriesList addObject:s];
            }
        }
        _seriesList = seriesList;
        _visableSeries = [self.seriesList mutableCopy];
        _xAxis = chartView.xAxis;
        _chartView = chartView;
        _yAxis = y;
        y.visableSeriesAmount = seriesList.count;
        
        [self.graphContext addHRangeObsever:self];
    }
    return self;
}

-(_DCYAxisLabelLayer*)getAxisLabelLayer {
    if (REMIsNilOrNull(self._yLabelLayer)) {
        _DCYAxisLabelLayer* _yLabelLayer = [[_DCYAxisLabelLayer alloc]initWithContext:self.graphContext];
        _yLabelLayer.axis = self.yAxis;
        _yLabelLayer.font = self.yAxis.labelFont;
        _yLabelLayer.fontColor = self.yAxis.labelColor;
        _yLabelLayer.axisTitleFontSize = self.yAxis.axisTitleFontSize;
        _yLabelLayer.axisTitleToTopLabel = self.yAxis.axisTitleToTopLabel;
        _yLabelLayer.axisTitleColor = self.yAxis.axisTitleColor;
        _yLabelLayer.isMajorAxis = self.isMajor;
        self._yLabelLayer = _yLabelLayer;
        [self addYIntervalObsever:_yLabelLayer];
    }
    return self._yLabelLayer;
}

-(void)willHRangeChanged:(DCRange *)oldRange newRange:(DCRange *)newRange {
    if ([DCRange isRange:oldRange equalTo:newRange]) return;
    
    if (self.graphContext) {
        // 计算可视区域内的Y的最大值currentYRange
        double currentYMax = INT32_MIN;
        double currentYMin = INT32_MAX;
        if (self.graphContext.stacked) {
            int start = floor(newRange.location);
            int end = ceil(newRange.end);
            start = MAX(0, start);
            
            for (NSUInteger i = start; i <= end; i++) {
                double yValAtIndex = 0;
                for (DCXYSeries* s in self.visableSeries) {
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
        } else {
            for (DCXYSeries* s in self.visableSeries) {
                if (!REMIsNilOrNull(s.visableYMin)) {
                    double yMax = s.visableYMax.doubleValue;
                    if (yMax > currentYMax) currentYMax = yMax;
                }
                if (!REMIsNilOrNull(s.visableYMin)) {
                    double yMin = s.visableYMin.doubleValue;
                    if (yMin < currentYMin) currentYMin = yMin;
                }
            }
        }
        if (currentYMax == INT32_MIN) currentYMax = 0;
        if (currentYMin == INT32_MIN) currentYMin = 0;
        
        // 根据maxY计算YRange并通知所有的YRangeObserver
        DCYAxisIntervalCalculation calResult = [DCUtility calculatorYAxisByMin:currentYMin yMax:currentYMax parts:self.graphContext.hGridlineAmount];
        DCRange* newYRange = [[DCRange alloc]initWithLocation:0 length:calResult.yMax];
        if ([self testYRange:newYRange visableMax:currentYMax visableMin:currentYMin]) {
            [self setYRange:newYRange];
            self.yInterval = calResult.yInterval;
        }
    }
}

-(void)didHRangeChanged:(DCRange *)oldRange newRange:(DCRange *)newRange {
    // Nothing to do.
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
}
-(void)addYIntervalObsever:(id<DCContextYIntervalObserverProtocal>)observer {
    if (observer == nil) return;
    if (self.yIntervalObservers == nil) self.yIntervalObservers = [[NSMutableArray alloc]init];
    [self.yIntervalObservers addObject:observer];
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
