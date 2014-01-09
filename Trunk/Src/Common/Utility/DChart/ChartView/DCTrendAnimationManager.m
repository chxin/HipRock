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

-(void)animateHRangeWithSpeed:(double)speed {
    if (REMIsNilOrNull(self.view) || REMIsNilOrNull(self.view.graphContext)) return;
    CGFloat graphLength = self.view.graphContext.hRange.length;
    double currentLocation = self.view.graphContext.hRange.location;
    CGFloat speedThreshold = graphLength / 100; // 速度小于此值则停止惯性，并开始计算到To位置的帧
    DCRange* globalRange = self.view.graphContext.globalHRange;
    NSMutableArray* hRangeFrames = [[NSMutableArray alloc]init];
    while (fabs(speed) >= speedThreshold) {
        speed = speed * ((currentLocation < globalRange.location || currentLocation + graphLength > globalRange.end) ? 0.5 : 0.9);
        currentLocation += speed;
        [hRangeFrames addObject:[[DCRange alloc] initWithLocation:currentLocation length:graphLength]];
    }
    
    double to = currentLocation;
    if (currentLocation < globalRange.location) {
        to = globalRange.location;
    } else if (currentLocation + graphLength > globalRange.end) {
        to = globalRange.end-graphLength;
    }

    // 计算到To位置的帧
    if (currentLocation != to) {
        double frames = kDCAnimationDuration * kDCFramesPerSecord;
        double hRangeAnimationStep = (to - currentLocation)/frames;
        while (currentLocation != to) {
            double newLocation = currentLocation + hRangeAnimationStep;
            if ((newLocation >= to && currentLocation < to) || (newLocation <= to && currentLocation > to)){
                newLocation = to;
            }
            currentLocation = newLocation;
            [hRangeFrames addObject:[[DCRange alloc] initWithLocation:currentLocation length:graphLength]];
        }
    }
    
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1/kDCFramesPerSecord target:self selector:@selector(animateFramesTarget:) userInfo:hRangeFrames repeats:YES];
}

-(void)animateFramesTarget:(NSTimer*)timer {
    NSMutableArray* frames = (NSMutableArray*)timer.userInfo;
    if (REMIsNilOrNull(self.view) || REMIsNilOrNull(frames) || frames.count == 0) {
        [timer invalidate];
        return;
    }
    DCRange* hRange = frames[0];
    self.view.graphContext.hRange = hRange;
    
    if (!REMIsNilOrNull(self.delegate) && [self.delegate respondsToSelector:@selector(didHRangeApplyToView:finalRange:)]) {
        [self.delegate didHRangeApplyToView:hRange finalRange:frames[frames.count-1]];
    }
    [frames removeObjectAtIndex:0];
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
        self.view.graphContext.hRange = newRange;
    }
}
@end
