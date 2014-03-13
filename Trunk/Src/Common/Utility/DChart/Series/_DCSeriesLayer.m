//
//  _DCSeriesLayer.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/19/13.
//
//

#import "_DCSeriesLayer.h"
#import "DCXYSeries.h"

@implementation _DCSeriesLayer
-(id)initWithContext:(DCContext*)graphContext view:(DCXYChartView*)view coordinateSystems:(NSArray*)coordinateSystems; {
    self = [super initWithContext:graphContext view:(DCXYChartView*)view];
    if (self) {
        self.contentsScale = [UIScreen mainScreen].scale;
        _enableGrowAnimation = YES;
        _growthAnimationDone = NO;
        NSMutableArray* s = [[NSMutableArray alloc]init];
        for (DCXYSeries* se in view.seriesList) {
            if ([self isValidSeriesForMe:se]) {
                [s addObject:se];
                se.layer = self;
            }
        }
        _series = s;
        self.masksToBounds = YES;
        _coordinateSystems = coordinateSystems;
    }
    return self;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
//    if (flag) {
        _growthAnimationDone = YES;
//        NSLog(@"view hash:%ui; layer:%@", self.view.hash, NSStringFromClass([self class]));
        [self.view subLayerGrowthAnimationDone];
//    }
}

-(NSUInteger)getVisableSeriesCount {
    NSUInteger count = 0;
    for (DCXYSeries* s in self.series) {
        if (!s.hidden) count++;
    }
    return count;
}
//-(void)didYRangeChanged:(DCRange*)oldRange newRange:(DCRange*)newRange {
//    _yRange = newRange;
//    self.heightUnitInScreen = (self.yRange != nil && self.yRange.length > 0) ? (self.frame.size.height / self.yRange.length) : 0;
//}
//
//-(void)didHRangeChanged:(DCRange *)oldRange newRange:(DCRange *)newRange {
//    if (oldRange == Nil) self.enableGrowAnimation = YES;
//    _xRange = newRange;
//}

-(BOOL)isValidSeriesForMe:(DCXYSeries*)series {
    return NO;
}

//-(void)redrawWithXRange:(DCRange*)xRange yRange:(DCRange*)yRange {
//    if ([DCRange isRange:xRange equalTo:self.xRange] && [DCRange isRange:yRange equalTo:self.yRange]) return;
//    [self redraw];
//}

-(void)redraw {
    // Template. Nothing to do.
}
@end
