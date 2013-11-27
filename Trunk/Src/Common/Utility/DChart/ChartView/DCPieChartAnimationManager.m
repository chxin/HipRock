//
//  DCPieChartAnimationManager.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/26/13.
//
//

#import "DCPieChartAnimationManager.h"
#import "DCPieChartView.h"

@interface DCPieChartAnimationManager()
@property (nonatomic, weak) DCPieChartView* view;

@property (nonatomic,strong) NSTimer* animationTimer;
@end

@implementation DCPieChartAnimationManager
-(id)initWithPieView:(DCPieChartView *)view {
    self = [super init];
    if (self) {
        _view = view;
    }
    return self;
}
//@property (nonatomic,assign) NSNumber* radius;            // 圆形区域半径
//@property (nonatomic,assign) NSNumber* radiusForShadow;   // 投影半径
//@property (nonatomic,assign) NSNumber* rotationAngle;     // 扇图已经旋转的角度，值域为[0-2)，例如需要旋转90°，rotationAngle=0.5
//@property (nonatomic,assign) NSNumber* fullAngle;         // 扇图的总体的角度和，值域为[0-2]，例如如果只需要画半圆，fullAngle=1
//@property (nonatomic,assign) NSNumber* indicatorAlpha;
-(void)playGrowUpAnimation {
    DCPieChartAnimationFrame* startFrame = [[DCPieChartAnimationFrame alloc]init];
    startFrame.radius = @(0);
    startFrame.radiusForShadow = @(0);
    startFrame.rotationAngle = @(0);
    startFrame.fullAngle = @(0);
    startFrame.indicatorAlpha = @(0);

}

/**计算等差数列**/
-(int)sumFrom:(NSUInteger)a to:(NSUInteger)b {
    if (a > b) {
        NSUInteger c = a;
        a = b;
        b = c;
    }
    return (b + a) * (b - a + 1) / 2;
}

-(void)animateToFrame:(DCPieChartAnimationFrame*)targetFrame {
    if (self.view == Nil) return;
    
    double frames = kDCAnimationDuration * kDCFramesPerSecord;
    
    double radiusStep = 0;
    double shadowRadiusStep = 0;
    double rotationAngleStep = 0;
    double fullAngleStep = 0;
    double indicatorAlphaStep = 0;
    int stepDiv = [self sumFrom:0 to:frames];
    if (targetFrame.radius) {
        radiusStep = (targetFrame.radius.doubleValue - self.view.radius) / stepDiv;
    }
    if (targetFrame.radiusForShadow) {
        shadowRadiusStep = (targetFrame.radiusForShadow.doubleValue - self.view.radiusForShadow) / stepDiv;
    }
    if (targetFrame.rotationAngle) {
        rotationAngleStep = (targetFrame.rotationAngle.doubleValue - self.view.rotationAngle) / stepDiv;
    }
    if (targetFrame.fullAngle) {
        fullAngleStep = (targetFrame.fullAngle.doubleValue - self.view.fullAngle) / stepDiv;
    }
    if (targetFrame.indicatorAlpha) {
        indicatorAlphaStep = (targetFrame.indicatorAlpha.doubleValue - self.view.indicatorAlpha) / stepDiv;
    }
    
    NSMutableArray* animationFrames = [[NSMutableArray alloc]init];
    for (int i = 0; i < frames; i++) {
        DCPieChartAnimationFrame* aframe = [[DCPieChartAnimationFrame alloc]init];
        int stepMulti = [self sumFrom:frames - i to:frames] ;
        if (targetFrame.radius) {
            aframe.radius = @(self.view.radius + stepMulti * radiusStep);
        }
        if (targetFrame.radiusForShadow) {
            aframe.radiusForShadow = @(self.view.radiusForShadow + stepMulti * shadowRadiusStep);
        }
        if (targetFrame.rotationAngle) {
            aframe.rotationAngle = @(self.view.rotationAngle + stepMulti * rotationAngleStep);
        }
        if (targetFrame.fullAngle) {
            aframe.fullAngle = @(self.view.fullAngle + stepMulti * fullAngleStep);
        }
        if (targetFrame.indicatorAlpha) {
            aframe.indicatorAlpha = @(self.view.indicatorAlpha + stepMulti * fullAngleStep);
        }
        [animationFrames addObject:aframe];
    }
    [animationFrames addObject:targetFrame];
    [self playFrames:animationFrames];
}

-(void)rotateAngle:(double)angle withInitialSpeed:(double)speed {
    if (self.view == Nil) return;
    if (speed * angle < 0) return;  // 速度和方向想法，动画很乱，不考虑
    
    double frames = kDCAnimationDuration * kDCFramesPerSecord;
    int halfFrames = frames / 2;
    double rotationAngleStep = 0;
    double halfAngle = angle / 2;
    
    NSMutableArray* animationFrames = [[NSMutableArray alloc]init];
    
    // 前半程，加速旋转到halfAngle
    rotationAngleStep = (halfAngle - (speed * halfFrames)) / [self sumFrom:1 to:halfFrames];
    DCPieChartAnimationFrame* halfTarget = [[DCPieChartAnimationFrame alloc]init];
    halfTarget.rotationAngle = @(self.view.rotationAngle + halfAngle);
    for (int i = 0; i < halfFrames; i++) {
        DCPieChartAnimationFrame* aframe = [[DCPieChartAnimationFrame alloc]init];
        int stepMulti = [self sumFrom:0 to:i+1] ;
        aframe.rotationAngle = @(self.view.rotationAngle + speed * i + stepMulti * rotationAngleStep);
        [animationFrames addObject:aframe];
        NSLog(@"%i %f", animationFrames.count - 1, [(DCPieChartAnimationFrame*)animationFrames[animationFrames.count - 1] rotationAngle].doubleValue);
    }
//    [animationFrames addObject:halfTarget];
    NSLog(@"%i %f", animationFrames.count - 1, [(DCPieChartAnimationFrame*)animationFrames[animationFrames.count - 1] rotationAngle].doubleValue);
    
    double currentSpeed = speed + rotationAngleStep * halfFrames;
    // 后半程，减速到0
    rotationAngleStep = (halfAngle - (currentSpeed * halfFrames)) / [self sumFrom:1 to:halfFrames];
    DCPieChartAnimationFrame* target = [[DCPieChartAnimationFrame alloc]init];
    target.rotationAngle = @(self.view.rotationAngle + angle);
    for (int i = 0; i < halfFrames; i++) {
        DCPieChartAnimationFrame* aframe = [[DCPieChartAnimationFrame alloc]init];
        int stepMulti = [self sumFrom:0 to:i+1] ;
        aframe.rotationAngle = @(halfTarget.rotationAngle.doubleValue + currentSpeed * (i+1) + stepMulti * rotationAngleStep);
        [animationFrames addObject:aframe];
        NSLog(@"%i %f", animationFrames.count - 1, [(DCPieChartAnimationFrame*)animationFrames[animationFrames.count - 1] rotationAngle].doubleValue);
    }
    [animationFrames addObject:target];
    NSLog(@"%i %f", animationFrames.count - 1, [(DCPieChartAnimationFrame*)animationFrames[animationFrames.count - 1] rotationAngle].doubleValue);
    
    // 应用动画
    [self playFrames:animationFrames];
}

-(void)playFrames:(NSMutableArray*)frames {
    if (frames == nil || frames.count == 0) return;
    if (self.animationTimer && [self.animationTimer isValid]) [self.animationTimer invalidate];
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:1/kDCFramesPerSecord target:self selector:@selector(animationTimerTarget) userInfo:frames repeats:YES];
}

-(void)animationTimerTarget {
    if (self.view == nil) {
        [self stopTimer];
        return;
    }
    if (self.animationTimer && [self.animationTimer isValid]) {
        NSMutableArray* frames = self.animationTimer.userInfo;
        if (frames.count == 0) {
            [self stopTimer];
        } else {
            DCPieChartAnimationFrame* theFrame = frames[0];
            [frames removeObjectAtIndex:0];
            if (theFrame.radius) {
                self.view.radius = theFrame.radius.doubleValue;
            }
            if (theFrame.radiusForShadow) {
                self.view.radiusForShadow = theFrame.radiusForShadow.doubleValue;
            }
            if (theFrame.rotationAngle) {
                self.view.rotationAngle = theFrame.rotationAngle.doubleValue;
            }
            if (theFrame.fullAngle) {
                self.view.fullAngle = theFrame.fullAngle.doubleValue;
            }
            if (theFrame.indicatorAlpha) {
                self.view.indicatorAlpha = theFrame.indicatorAlpha.doubleValue;
            }
            [self.view setNeedsDisplay];
        }
    }
}

-(void)stopTimer {
    if (self.animationTimer && [self.animationTimer isValid]) {
        [self.animationTimer invalidate];
        self.animationTimer = nil;
    }
}

@end
