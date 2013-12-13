//
//  DCTrendAnimationManager.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/11/13.
//
//

#import "DCTrendAnimationManager.h"
@interface DCTrendAnimationManager ()
@property (nonatomic, strong) NSTimer* timer;
@end

@implementation DCTrendAnimationManager
-(void)invalidate {
    [self.timer invalidate];
}


-(void)animateHRangeLocationFrom:(double)from to:(double)to {
    if (from == to) return;
    double frames = kDCAnimationDuration * kDCFramesPerSecord;
    NSNumber* hRangeAnimationStep = @((to - from)/frames);
    NSDictionary* hRangeUserInfo = @{@"hRangeAnimationStep":hRangeAnimationStep, @"from":@(from), @"to":@(to)};
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1/kDCFramesPerSecord target:self selector:@selector(animateHRangeLocation) userInfo:hRangeUserInfo repeats:YES];
}

-(void)animateHRangeLocation {
    if (self.timer.isValid) {
        double hRangeAnimationStep =  [self.timer.userInfo[@"hRangeAnimationStep"] doubleValue];
        double to =  [self.timer.userInfo[@"to"] doubleValue];
        double from =  [self.timer.userInfo[@"from"] doubleValue];
        double newLocation = self.view.graphContext.hRange.location + hRangeAnimationStep;
        if ((newLocation >= to && from < to) || (newLocation <= to && from > to)){
            newLocation = to;
            [self.timer invalidate];
        }
        DCRange* newRange = [[DCRange alloc]initWithLocation:newLocation length:self.view.graphContext.hRange.length];
        //        if ([self.view testHRangeChange:newRange oldRange:self.view.graphContext.hRange sendBy:DCHRangeChangeSenderByAnimation]) {
        self.view.graphContext.hRange = newRange;
        //        }
    }
}
@end
