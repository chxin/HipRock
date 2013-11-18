//
//  _DCCoordinateSystem.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/12/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "_DCCoordinateSystem.h"
#import "DCXYSeries.h"
#import "DCColumnSeries.h"
#import "DCUtility.h"

@interface _DCCoordinateSystem()
@property (nonatomic, strong) NSMutableArray* visableSeries;
@property (nonatomic) double visableYMax;
@end

@implementation _DCCoordinateSystem

-(id)initWithSeries:(NSArray*)series x:(DCAxis*)x y:(DCAxis*)y index:(NSUInteger)index{
    self = [super init];
    if (self) {
        _index = index;
        _visableYMax = INT32_MIN;
        _seriesList = series;
        _visableSeries = [series mutableCopy];
        _xAxis = x;
        _yAxis = y;
        y.visableSeriesAmount = series.count;
    }
    return self;
}

-(void)didHRangeChanged:(DCRange *)oldRange newRange:(DCRange *)newRange {
    if ([DCRange isRange:oldRange equalTo:newRange]) return;
    
    if (self.graphContext) {
        double currentYRange = INT32_MIN;
        if (self.graphContext.stacked) {
            int start = floor(newRange.location);
            int end = ceil(newRange.length+newRange.location);
            start = MAX(0, start);
            
            for (NSUInteger i = start; i <= end; i++) {
                double yValAtIndex = 0;
                for (DCXYSeries* s in self.visableSeries) {
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
        if (self.visableYMax == currentYRange) {
            return;
        } else {
            self.visableYMax = currentYRange;
            double yInterval = [DCUtility getYInterval:currentYRange parts:self.graphContext.hGridlineAmount];
            currentYRange = yInterval * self.graphContext.hGridlineAmount * kDCReservedSpace;
            DCRange* range = [[DCRange alloc]initWithLocation:0 length:currentYRange];
            NSLog(@"round y to:%f %f", self.visableYMax, currentYRange);
            if (self.index == 0 && ![DCRange isRange:self.graphContext.y0Range equalTo:range]) {
                self.graphContext.y0Range = range;
                self.graphContext.y0Interval = yInterval;
            }
            if (self.index == 1 && ![DCRange isRange:self.graphContext.y1Range equalTo:range]) {
                self.graphContext.y1Range = range;
                self.graphContext.y1Interval = yInterval;
            }
            if (self.index == 2 && ![DCRange isRange:self.graphContext.y2Range equalTo:range]) {
                self.graphContext.y2Range = range;
                self.graphContext.y2Interval = yInterval;
            }
        }
    }
}

//-(double)getMaxVisableY {
//    double currentYRange = INT32_MIN;
//    if (self.graphContext.stacked) {
//        int start = floor(self.graphContext.hRange.location);
//        int end = ceil(self.graphContext.hRange.length+self.graphContext.hRange.location);
//        start = MAX(0, start);
//        
//        for (NSUInteger i = start; i <= end; i++) {
//            double yValAtIndex = 0;
//            for (DCXYSeries* s in self.visableSeries) {
//                DCDataPoint* p = s.datas[i];
//                if (p.value == nil || [p.value isEqual:[NSNull null]]) continue;
//                yValAtIndex+=p.value.doubleValue;
//            }
//            if (yValAtIndex > currentYRange) {
//                currentYRange = yValAtIndex;
//            }
//        }
//    } else {
//        for (DCXYSeries* s in self.visableSeries) {
//            double yMax = s.visableYMax.doubleValue;
//            if (yMax > currentYRange) currentYRange = yMax;
//        }
//    }
//    
//    return currentYRange;
//}

//-(void)addToSuperLayer:(CALayer*)superLayer {
//    self.columnLayer = [[CALayer alloc]init];
//    for (DCXYSeries* s in self.visableSeries) {
//        if ([s isKindOfClass:[DCColumnSeries class]]) {
//            [s drawLayer:self.columnLayer inContext:UIGraphicsGetCurrentContext()];
//        }
//    }
//    [superLayer addSublayer:self.columnLayer];
//}
//
//-(void)removeFromSuperLayer {
//    [self.columnLayer removeFromSuperlayer];
//    self.columnLayer = nil;
//}
@end
