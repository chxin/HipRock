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
@property (nonatomic) double visableYMax;

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
        _visableYMax = INT32_MIN;
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
        double currentYRange = INT32_MIN;
        if (self.graphContext.stacked) {
            int start = floor(newRange.location);
            int end = ceil(newRange.length+newRange.location);
            start = MAX(0, start);
            
            for (NSUInteger i = start; i <= end; i++) {
                double yValAtIndex = 0;
                for (DCXYSeries* s in self.visableSeries) {
                    if (i >= s.datas.count) break;
                    DCDataPoint* p = s.datas[i];
                    if (p.value == nil || [p.value isEqual:[NSNull null]]) continue;
                    yValAtIndex+=p.value.doubleValue;
                }
                if (yValAtIndex > currentYRange) {
                    currentYRange = yValAtIndex;
                }
            }
        } else {
            for (DCXYSeries* s in self.visableSeries) {
                double yMax = s.visableYMax.doubleValue;
                if (yMax > currentYRange) currentYRange = yMax;
            }
        }
        // 根据maxY计算YRange并通知所有的YRangeObserver
        if (self.visableYMax != currentYRange) {
            self.visableYMax = currentYRange;
            double yInterval = [DCUtility getYInterval:currentYRange parts:self.graphContext.hGridlineAmount];
            currentYRange = yInterval * self.graphContext.hGridlineAmount * kDCReservedSpace;
            self.yRange = [[DCRange alloc]initWithLocation:0 length:currentYRange];
            self.yInterval = yInterval;
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


@end
