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
        if (coordinateSystem.graphContext) {
            [coordinateSystem.graphContext addHRangeObsever:self];
        }
    }
    return self;
}

-(void)didYRangeChanged:(DCRange*)oldRange newRange:(DCRange*)newRange {
    if ([DCRange isRange:oldRange equalTo:newRange]) return;
    [self redraw:self.xRange y:newRange];
    _yRange = [newRange copy];
}

-(void)didHRangeChanged:(DCRange *)oldRange newRange:(DCRange *)newRange {
    if ([DCRange isRange:oldRange equalTo:newRange]) return;
    if (oldRange == Nil) self.enableGrowAnimation = YES;
    [self redraw:newRange y:self.xRange];
    _xRange = [newRange copy];
    
}

-(void)redraw:(DCRange*)xRange y:(DCRange*)yRange {
    if ([DCRange isRange:xRange equalTo:self.xRange] && [DCRange isRange:yRange equalTo:self.yRange]) return;
    [self setNeedsDisplay];
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
