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

-(void)rotateWithInitialSpeed:(double)speed {
    if (self.view == Nil) return;
    NSMutableArray* animationFrames = [[NSMutableArray alloc]init];
    if (fabs(speed) < 0.05) {
        double indicationAngle = 1.5 - self.view.rotationAngle;
        if (indicationAngle < 0) {
            indicationAngle += 2;
        }
        // 找到预计旋转角度对应的扇区的中线位置
        double targetRotation = 0;  // 预计对准的扇区的中线位置
        for (int i = 0; i < self.view.series.pieSlices.count; i++) {
            if (REMIsNilOrNull(self.view.series.pieSlices)) continue;
            DCPieSlice slice;
            [self.view.series.pieSlices[i] getValue:&slice];
            if (slice.sliceEnd > indicationAngle) {
                targetRotation = slice.sliceCenter;
                //            NSLog(@"index:%i slice:%f indicator:%f", i, targetRotation, indicationAngle);
                break;
            }
        }
        targetRotation = 1.5 - targetRotation;
        if (targetRotation >= 2) targetRotation -= 2;
        else if (targetRotation < 0) targetRotation += 2;
        
        double frames = kDCAnimationDuration * kDCFramesPerSecord;
        double step = (targetRotation - self.view.rotationAngle) / frames;
        for (int i = 0; i < frames; i++) {
            DCPieChartAnimationFrame* aframe = [[DCPieChartAnimationFrame alloc]init];
            aframe.rotationAngle = @(self.view.rotationAngle + step * i);
            [animationFrames addObject:aframe];
        }
        DCPieChartAnimationFrame* frame = [[DCPieChartAnimationFrame alloc]init];
        frame.rotationAngle = @(targetRotation);
        [self animateToFrame:frame];
        [animationFrames addObject:frame];
    } else {
        // 预计最后一帧的旋转的角度。并预先计算出所有帧的旋转。
        double theSpeed = speed;
        double rotation = self.view.rotationAngle;
        double speedDown = 0.9;
        theSpeed *= speedDown;
        NSMutableArray* speedArray = [[NSMutableArray alloc]init];
        while (fabs(theSpeed) > 0.00001) {
            rotation += theSpeed;
            [speedArray addObject:@(theSpeed)];
            theSpeed*=speedDown;
        }
        
        // 将最后一帧的角度与indicator对齐，并改成0-2的值域范围内
        double indicationAngle = 1.5 - rotation;
        int a = (indicationAngle)/2;
        if (indicationAngle < 0) {
            indicationAngle -= 2*(a-1);
        } else if (a > 0) {
            indicationAngle -= 2*a;
        }
        
        // 找到预计旋转角度对应的扇区的中线位置
        double targetRotation = 0;  // 预计对准的扇区的中线位置
        for (int i = 0; i < self.view.series.pieSlices.count; i++) {
            if (REMIsNilOrNull(self.view.series.pieSlices)) continue;
            DCPieSlice slice;
            [self.view.series.pieSlices[i] getValue:&slice];
            if (slice.sliceEnd > indicationAngle) {
                targetRotation = slice.sliceCenter;
    //            NSLog(@"index:%i slice:%f indicator:%f", i, targetRotation, indicationAngle);
                break;
            }
        }
        double r = self.view.rotationAngle;

        for (int i = 0; i < speedArray.count;i++) {
            DCPieChartAnimationFrame* frame = [[DCPieChartAnimationFrame alloc]init];
            r+=[speedArray[i] doubleValue];
            frame.rotationAngle = @(r*(rotation - targetRotation + indicationAngle)/rotation);
            [animationFrames addObject:frame];
        }
        DCPieChartAnimationFrame* frame = [[DCPieChartAnimationFrame alloc]init];
        frame.rotationAngle = @(1.5-targetRotation);
        [animationFrames addObject:frame];
    //    NSLog(@"selfViewRotate:%f speed:%f rotation:%f", self.view.rotationAngle, speed, rotation);
    //    for (DCPieChartAnimationFrame* f in animationFrames) {
    //        NSLog(@"%f", f.rotationAngle.doubleValue);
    //    }
    }
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
