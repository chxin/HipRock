//
//  _DCSeriesLayer.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/19/13.
//
//

#import "_DCSeriesLayer.h"

@implementation _DCSeriesLayer
-(id)initWithCoordinateSystem:(_DCCoordinateSystem*)coordinateSystem {
    self = [super init];
    if (self) {
        self.contentsScale = [UIScreen mainScreen].scale;
        _enableGrowAnimation = YES;
        NSMutableArray* s = [[NSMutableArray alloc]init];
        for (DCXYSeries* se in coordinateSystem.seriesList) {
            if ([self isValidSeriesForMe:se]) {
                [s addObject:se];
            }
        }
        _focusX = INT32_MIN;
        _series = s;
        self.masksToBounds = YES;
        _coordinateSystem = coordinateSystem;
    }
    return self;
}

-(void)didYRangeChanged:(DCRange*)oldRange newRange:(DCRange*)newRange {
    _yRange = newRange;
    self.heightUnitInScreen = (self.yRange != nil && self.yRange.length > 0) ? (self.frame.size.height / self.yRange.length) : 0;
}

-(void)didHRangeChanged:(DCRange *)oldRange newRange:(DCRange *)newRange {
    if (oldRange == Nil) self.enableGrowAnimation = YES;
    _xRange = newRange;
}

-(void)removeFromSuperlayer {
    self.series = nil;
    [super removeFromSuperlayer];
}

-(BOOL)isValidSeriesForMe:(DCXYSeries*)series {
    return NO;
}
//
//- (void)setSeries:(DCXYSeries*)series hidden:(BOOL)hidden {
//    if ([self.series containsObject:series]) {
//        if (hidden == [self.visableSeries containsObject:series]) {
//            if (hidden) {
//                [self.visableSeries removeObject:series];
//                series.yAxis.visableSeriesAmount--;
//                series.xAxis.visableSeriesAmount--;
//            } else {
//                [self.visableSeries addObject:series];
//                series.yAxis.visableSeriesAmount++;
//                series.xAxis.visableSeriesAmount++;
//            }
//            [self setNeedsDisplay];
//        }
//    }
//}
-(void)focusOnX:(int)x {
    if (self.focusX != x) {
        _focusX = x;
    }
}

-(void)defocus {
    if (self.focusX != INT32_MIN) {
        _focusX = INT32_MIN;
    }
}
@end
