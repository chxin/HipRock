//
//  DCContext.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/12/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "DCContext.h"
#import "DCUtility.h"

NSString* const kDCMaxLabel = @"999,999T";
double const kDCReservedSpace = 1.1;   // 纵向预留10%的高度
CGFloat const kDCColumnOffset = 0.1;    // 柱图的横向预留空间
CGFloat const kDCAnimationDuration = 0.4;    // 柱图的横向预留空间
int const kDCLabelToLine = 5;              // label到轴线的距离
int const kDCFramesPerSecord = 60;          // 动画帧数
double const kDCYRangeChangeDetection = 1.05;          // 在设定YRange的时候，如果新的YRange.length的变化不超过5%，则放弃此次设定。必须小于kDCReservedSpace。为改善动画效果

@interface DCContext()
@property (nonatomic) NSMutableArray* hRangeObservers;
@property (nonatomic) NSMutableArray* y0RangeObservers;
@property (nonatomic) NSMutableArray* y1RangeObservers;
@property (nonatomic) NSMutableArray* y2RangeObservers;
@property (nonatomic) NSMutableArray* y0IntervalObservers;
@property (nonatomic) NSMutableArray* y1IntervalObservers;
@property (nonatomic) NSMutableArray* y2IntervalObservers;
@end

@implementation DCContext
-(id)initWithStacked:(BOOL)stacked {
    self = [super init];
    if (self) {
        _stacked = stacked;
    }
    return self;
}
-(void)addHRangeObsever:(id<DCContextHRangeObserverProtocal>)observer {
    if (self.hRangeObservers == nil) self.hRangeObservers = [[NSMutableArray alloc]init];
    [self.hRangeObservers addObject:observer];
}
-(void)removeHRangeObsever:(id<DCContextHRangeObserverProtocal>)observer {
    if (self.hRangeObservers == nil || self.hRangeObservers.count==0) return;
    for (id o in self.hRangeObservers) {
        if (o == observer) {
            [self.hRangeObservers removeObject:o];
            break;
        }
    }
}
-(void)addY0RangeObsever:(id<DCContextYRangeObserverProtocal>)observer {
    if (self.y0RangeObservers == nil) self.y0RangeObservers = [[NSMutableArray alloc]init];
    [self.y0RangeObservers addObject:observer];
}
-(void)removeY0RangeObsever:(id<DCContextYRangeObserverProtocal>)observer {
    if (self.y0RangeObservers == nil || self.y0RangeObservers.count==0) return;
    for (id o in self.y0RangeObservers) {
        if (o == observer) {
            [self.y0RangeObservers removeObject:o];
            break;
        }
    }
}
-(void)addY1RangeObsever:(id<DCContextYRangeObserverProtocal>)observer {
    if (self.y1RangeObservers == nil) self.y1RangeObservers = [[NSMutableArray alloc]init];
    [self.y1RangeObservers addObject:observer];
}
-(void)removeY1RangeObsever:(id<DCContextYRangeObserverProtocal>)observer {
    if (self.y1RangeObservers == nil || self.y1RangeObservers.count==0) return;
    for (id o in self.y1RangeObservers) {
        if (o == observer) {
            [self.y1RangeObservers removeObject:o];
            break;
        }
    }
}
-(void)addY2RangeObsever:(id<DCContextYRangeObserverProtocal>)observer {
    if (self.y2RangeObservers == nil) self.y2RangeObservers = [[NSMutableArray alloc]init];
    [self.y2RangeObservers addObject:observer];
}
-(void)removeY2RangeObsever:(id<DCContextYRangeObserverProtocal>)observer {
    if (self.y2RangeObservers == nil || self.y2RangeObservers.count==0) return;
    for (id o in self.y2RangeObservers) {
        if (o == observer) {
            [self.y2RangeObservers removeObject:o];
            break;
        }
    }
}


-(void)setHRange:(DCRange *)hRange {
    if ([DCRange isRange:hRange equalTo:self.hRange]) return;
    DCRange* oldRange = self.hRange;
    _hRange = hRange;
    
    for (id o in self.hRangeObservers) {
        if ([o respondsToSelector:@selector(didHRangeChanged:newRange:)]) {
            [o didHRangeChanged:oldRange newRange:self.hRange];
        }
    }
}
-(void)setY0Range:(DCRange *)y0Range {
    if ([DCRange isRange:y0Range equalTo:self.y0Range]) return;
    if ([DCUtility isMinorChangeForYRange:self.y0Range new:y0Range]) return;
    DCRange* oldRange = self.y0Range;
    _y0Range = y0Range;
    
    for (id o in self.y0RangeObservers) {
        if ([o respondsToSelector:@selector(didYRangeChanged:newRange:)]) {
            [o didYRangeChanged:oldRange newRange:self.y0Range];
        }
    }
}
-(void)setY1Range:(DCRange *)y1Range {
    if ([DCRange isRange:y1Range equalTo:self.y1Range]) return;
    if ([DCUtility isMinorChangeForYRange:self.y1Range new:y1Range]) return;
    DCRange* oldRange = self.y1Range;
    _y1Range = y1Range;
    
    for (id o in self.y1RangeObservers) {
        if ([o respondsToSelector:@selector(didYRangeChanged:newRange:)]) {
            [o didYRangeChanged:oldRange newRange:self.y1Range];
        }
    }
}
-(void)setY2Range:(DCRange *)y2Range {
    if ([DCRange isRange:y2Range equalTo:self.y2Range]) return;
    if ([DCUtility isMinorChangeForYRange:self.y2Range new:y2Range]) return;
    DCRange* oldRange = self.y2Range;
    _y2Range = y2Range;
    
    for (id o in self.y2RangeObservers) {
        if ([o respondsToSelector:@selector(didYRangeChanged:newRange:)]) {
            [o didYRangeChanged:oldRange newRange:self.y2Range];
        }
    }
}
-(void)setY0Interval:(double)y0Interval {
    if (_y0Interval == y0Interval) return;
    double oldInterval = self.y0Interval;
    _y0Interval = y0Interval;
    
    for (id o in self.y0IntervalObservers) {
        if ([o respondsToSelector:@selector(didYIntervalChanged:newInterval:yRange:)]) {
            [o didYIntervalChanged:oldInterval newInterval:y0Interval yRange:self.y0Range];
        }
    }
}
-(void)addY0IntervalObsever:(id<DCContextYIntervalObserverProtocal>)observer {
    if (self.y0IntervalObservers == nil) self.y0IntervalObservers = [[NSMutableArray alloc]init];
    [self.y0IntervalObservers addObject:observer];
}
-(void)removeY0IntervalObsever:(id<DCContextYIntervalObserverProtocal>)observer {
    if (self.y0IntervalObservers == nil || self.y0IntervalObservers.count==0) return;
    for (id o in self.y0IntervalObservers) {
        if (o == observer) {
            [self.y0IntervalObservers removeObject:o];
            break;
        }
    }
}
-(void)setY1Interval:(double)y1Interval {
    if (_y1Interval == y1Interval) return;
    double oldInterval = self.y1Interval;
    _y1Interval = y1Interval;
    
    for (id o in self.y1IntervalObservers) {
        if ([o respondsToSelector:@selector(didYIntervalChanged:newInterval:yRange:)]) {
            [o didYIntervalChanged:oldInterval newInterval:y1Interval yRange:self.y1Range];
        }
    }
}
-(void)addY1IntervalObsever:(id<DCContextYIntervalObserverProtocal>)observer {
    if (self.y1IntervalObservers == nil) self.y1IntervalObservers = [[NSMutableArray alloc]init];
    [self.y1IntervalObservers addObject:observer];
}
-(void)removeY1IntervalObsever:(id<DCContextYIntervalObserverProtocal>)observer {
    if (self.y1IntervalObservers == nil || self.y1IntervalObservers.count==0) return;
    for (id o in self.y1IntervalObservers) {
        if (o == observer) {
            [self.y1IntervalObservers removeObject:o];
            break;
        }
    }
}
-(void)setY2Interval:(double)y2Interval {
    if (_y2Interval == y2Interval) return;
    double oldInterval = self.y2Interval;
    _y2Interval = y2Interval;
    
    for (id o in self.y2IntervalObservers) {
        if ([o respondsToSelector:@selector(didYIntervalChanged:newInterval:yRange:)]) {
            [o didYIntervalChanged:oldInterval newInterval:y2Interval yRange:self.y2Range];
        }
    }
}
-(void)addY2IntervalObsever:(id<DCContextYIntervalObserverProtocal>)observer {
    if (self.y2IntervalObservers == nil) self.y2IntervalObservers = [[NSMutableArray alloc]init];
    [self.y2IntervalObservers addObject:observer];
}
-(void)removeY2IntervalObsever:(id<DCContextYIntervalObserverProtocal>)observer {
    if (self.y2IntervalObservers == nil || self.y2IntervalObservers.count==0) return;
    for (id o in self.y2IntervalObservers) {
        if (o == observer) {
            [self.y2IntervalObservers removeObject:o];
            break;
        }
    }
}
@end
