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
        _series = s;
        self.masksToBounds = YES;
        _visableSeries = s.mutableCopy;
        _coordinateSystem = coordinateSystem;
    }
    return self;
}

-(void)didYRangeChanged:(DCRange*)oldRange newRange:(DCRange*)newRange {
    _yRange = newRange;
}

-(void)didHRangeChanged:(DCRange *)oldRange newRange:(DCRange *)newRange {
    if (oldRange == Nil) self.enableGrowAnimation = YES;
    _xRange = newRange;
}

-(void)removeFromSuperlayer {
    self.series = nil;
    [self.visableSeries removeAllObjects];
    [super removeFromSuperlayer];
}

-(BOOL)isValidSeriesForMe:(DCXYSeries*)series {
    return NO;
}

- (void)setSeries:(DCXYSeries*)series hidden:(BOOL)hidden {
    if ([self.series containsObject:series]) {
        if (hidden == [self.visableSeries containsObject:series]) {
            if (hidden) {
                [self.visableSeries removeObject:series];
                series.yAxis.visableSeriesAmount--;
                series.xAxis.visableSeriesAmount--;
            } else {
                [self.visableSeries addObject:series];
                series.yAxis.visableSeriesAmount++;
                series.xAxis.visableSeriesAmount++;
            }
            [self setNeedsDisplay];
        }
    }
}
@end
