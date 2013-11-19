//
//  MyLayer.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/18/13.
//
//

#import "_DCContextAnimationLayer.h"

@interface _DCContextAnimationLayer() {
    BOOL _isPresenting; /* TRUE for presentation layer */
    DCContext* ccc;
    int fff;
}
@end
@implementation _DCContextAnimationLayer
@synthesize hRangeLocation = _hRangeLocation;
- (void)setHRangeLocation:(double)hRangeLocation {
    if (_isPresenting) {
        _hRangeLocation = hRangeLocation;
        return;
    }
    if ([self animationForKey:@"animateHRangeLocation"]) {
        _hRangeLocation = [[self presentationLayer] hRangeLocation];
        [self removeAnimationForKey:@"animateHRangeLocation"];
    }
    CABasicAnimation *a = (CABasicAnimation *)[self actionForKey:@"hRangeLocation"];
    if (a) {
        if ([[a valueForKey:@"hRangeLocation"] isEqualToString:@"defaultAction"]) {
            [a setFromValue:[NSNumber numberWithFloat:_hRangeLocation]];
            [a setToValue:[NSNumber numberWithFloat:hRangeLocation]];
            /* Set other animation properties */
        }
        [self addAnimation:a forKey:@"animateProperty"];
    }
    _hRangeLocation = hRangeLocation;
}
+ (id<CAAction>)defaultActionForKey:(NSString *)key {
    if ([key isEqualToString:@"hRangeLocation"]) {
        CABasicAnimation *a = [CABasicAnimation animationWithKeyPath:@"hRangeLocation"];
        [a setValue:@"defaultAction" forKey:@"animateHRangeLocation"];
        return a;
    }
    return [super defaultActionForKey:key];
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"hRangeLocation"]) {
        return YES;
    }
    if ([key isEqualToString:@"graphContext.hRange"]) {
        return YES;
    }
//    NSLog(key);
    return [super needsDisplayForKey:key];
}
- (id)init {
    if (self = [super init]) {
        _hRangeLocation = 10; /* initial value */
        fff = 10000;
    }
    return  self;
}
- (id)initWithLayer:(id)layer {
    if (self = [super initWithLayer:layer]) {
        _DCContextAnimationLayer *l = (_DCContextAnimationLayer *)layer;
        _isPresenting = TRUE;
        _hRangeLocation = l.hRangeLocation;
    }
    return self;
}
- (void)drawInContext:(CGContextRef)ctx {
    DCRange* hRange = [[DCRange alloc]initWithLocation:_hRangeLocation length:self.graphContext.hRange.length];
    NSLog(@"HRANGE FOR ANIM:%f %f", _hRangeLocation, hRange.location);
    CALayer* superLayer = self.superlayer;
    [ccc setHRange:hRange];
//    if (_graphContext) {
//        _graphContext.hRange = [[DCRange alloc]initWithLocation:self.hRangeLocation length:self.graphContext.hRange.length];
//    }
//    [super drawInContext:ctx];
}
-(void)animateHRangeLocationFrom:(double)from to:(double)to {
    _hRangeLocation = from;
    self.hRangeLocation = to;
}

@end
