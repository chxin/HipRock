//
//  DCPieChartView.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/24/13.
//
//

#import "DCPieChartView.h"
#import "REMColor.h"
#import "DCPieChartAnimationManager.h"

@interface DCPieChartView()
@property (nonatomic,strong) UIPanGestureRecognizer* panGesRec;
@property (nonatomic,strong) UISwipeGestureRecognizer* swipeGesRec;

@property (nonatomic,assign) int panState; // 1表示已经开始，0表示正在Pan，-1表示Pan已经停止
@property (nonatomic,assign) CGFloat panSpeed;
@property (nonatomic,assign) CGFloat panStep; // Pan松手时，speed减速的步长

@property (nonatomic, assign) CGFloat animationTargetAngle;
//@property (nonatomic, assign) CGFloat animationAngleSpeed;
//@property (nonatomic, assign) CGFloat animationSpeedMax;

@property (nonatomic, strong) NSMutableArray* animationSteps;

@property (nonatomic,assign) CGPoint indicatorPoint; // indicator针尖的点位置

@property (nonatomic,strong) NSTimer* beginAnimTimer;
@property (nonatomic,assign) NSTimer* panInertnessAnimTimer;
@property (nonatomic,assign) NSTimer* rotationAnimTimer;

@property (nonatomic,strong) DCPieChartAnimationManager* animationManager;
@end

@implementation DCPieChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _animationManager = [[DCPieChartAnimationManager alloc]initWithPieView:self];
        _rotationAngle = 0;
        _fullAngle = 0;
        _indicatorAlpha = 0;
        _radius = 0;
        _radiusForShadow = 0;
//        @property (nonatomic,assign) CGFloat radius;            // 圆形区域半径
//        @property (nonatomic,assign) CGFloat radiusForShadow;   // 投影半径
//        @property (nonatomic,assign) CGFloat rotationAngle;     // 扇图已经旋转的角度，值域为[0-2)，例如需要旋转90°，rotationAngle=0.5
//        @property (nonatomic,assign) CGFloat fullAngle;         // 扇图的总体的角度和，值域为[0-2]，例如如果只需要画半圆，fullAngle=1
//        @property (nonatomic,assign) CGFloat indicatorAlpha;
        _panState = -1;
        _animationTargetAngle = self.rotationAngle;
//        _animationAngleSpeed = 0;
        _animationSteps = [[NSMutableArray alloc]init];
        self.backgroundColor = [UIColor whiteColor];
        
        NSMutableArray* datas = [[NSMutableArray alloc]init];
        for (int i = 0; i < 10; i++) {
            DCPieDataPoint* p = [[DCPieDataPoint alloc]init];
            p.value = @(i+1);
            [datas addObject:p];
        }
        _series = [[DCPieSeries alloc]initWithEnergyData:datas];
    }
    return self;
}
                               
-(void)didMoveToSuperview {
//    self.beginAnimTimer = [NSTimer scheduledTimerWithTimeInterval:1/kDCFramesPerSecord target:self selector:@selector(animateFullAngle) userInfo:nil repeats:YES];
//    [self.beginAnimTimer fire];
    [super didMoveToSuperview];
    if (self.userInteractionEnabled) {
        self.panGesRec = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(viewPan:)];
        self.panGesRec.cancelsTouchesInView = NO;
        [self addGestureRecognizer:self.panGesRec];
    }
    if (self.series.sumVisableValue > 0) {
        double targetRotation = 0;
        for (int i = 0; i < self.series.pieSlices.count; i++) {
            if (REMIsNilOrNull(self.series.pieSlices[i])) continue;
            DCPieSlice slice;
            [self.series.pieSlices[i] getValue:&slice];
            targetRotation = slice.sliceCenter;
            break;
        }
        DCPieChartAnimationFrame* targetFrame = [[DCPieChartAnimationFrame alloc]init];
        targetFrame.radius = @(180);
        targetFrame.radiusForShadow = @(190);
        targetFrame.rotationAngle = @(1.5-targetRotation); // Indicator在1.5*PI的位置
        targetFrame.fullAngle = @(2);
        targetFrame.indicatorAlpha = @(0.8);
        [self.animationManager animateToFrame:targetFrame];
    }
}

-(void)viewPan:(UIPanGestureRecognizer*)gesture {
    CGPoint panPoint = [gesture locationInView:self];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if ([self isPointInPie:panPoint]) {
            self.panState = 1;
        }
    }
    if (self.panState == 1) {
        CGPoint translation = [gesture translationInView:self];
        if (translation.x == 0 && translation.y == 0) return;
        CGPoint previousPoint = CGPointMake(panPoint.x - translation.x, panPoint.y - translation.y);
        double rotation =(atan((previousPoint.x-self.center.x)/(previousPoint.y-self.center.y))-atan((panPoint.x-self.center.x)/(panPoint.y-self.center.y)))/M_PI;
        if (fabs(rotation) > 0.5) {
            rotation = rotation + (rotation > 0 ? -1 : 1);
        }
        self.rotationAngle += rotation;
        [gesture setTranslation:CGPointMake(0, 0) inView:self];
        
        self.panStep = rotation/kDCAnimationDuration/kDCFramesPerSecord;
        self.panSpeed = rotation;
    }
}

-(BOOL)isPointInPie:(CGPoint)point {
    CGFloat panStart = pow(pow((point.x - self.center.x), 2) + pow(point.y-self.center.y, 2),0.5);
    return panStart <= self.radiusForShadow;
}

//-(NSNumber*)findDataPointIndexByPoint:(CGPoint)point {
//    if (![self isPointInPie:point]) return nil;
//    DCPieSeries* series = self.series;
//    if (series.sumVisableValue == 0) return nil;
//    CGFloat pointAngle = asin((point.y-self.center.y)/pow(pow((point.x - self.center.x), 2) + pow(point.y-self.center.y, 2),0.5))*180/M_PI - self.rotationAngle*180;
//    if (pointAngle < 0) pointAngle+=360;
//    double sumPreviousPointValue = 0;
//    NSUInteger i = 0;
//    for (; i < series.datas.count; i++) {
//        DCPieDataPoint* point = series.datas[i];
//        if (point.hidden || point.pointType!=DCDataPointTypeNormal) continue;
//        double selfAngle = point.value.doubleValue / series.sumVisableValue * 360;
//        sumPreviousPointValue += selfAngle;
//        if (sumPreviousPointValue > pointAngle) {
//            NSLog(@"Found point which index is %i, its value is %f", i, point.value.doubleValue);
//            break;
//        }
//    }
//    return @(i);
//}
//
//// 动画停止后，将饼图旋转到和Indicator对齐的位置
//-(void)align {
//    NSNumber* indicatorIsAtNSNum = [self findDataPointIndexByPoint:self.indicatorPoint];
//    if (REMIsNilOrNull(indicatorIsAtNSNum)) return;
//    int indicatorIsAt = indicatorIsAtNSNum.intValue;
//    
//    CGFloat indicatorAngle = 270 - self.rotationAngle*180;
//    if (indicatorAngle<0) indicatorAngle+=360;
//    double sumPreviousPointValue = 0;
//    NSUInteger i = 0;
//    for (; i < indicatorIsAt; i++) {
//        DCPieDataPoint* point = self.series.datas[i];
//        if (point.hidden || point.pointType!=DCDataPointTypeNormal) continue;
//        sumPreviousPointValue += point.value.doubleValue;
//    }
//    sumPreviousPointValue = sumPreviousPointValue / self.series.sumVisableValue * 360;
//    CGFloat selfAngle = [(DCPieDataPoint*)self.series.datas[indicatorIsAt] value].doubleValue / self.series.sumVisableValue * 360;
//    CGFloat angelNeedToRotate = indicatorAngle - selfAngle/2 - sumPreviousPointValue;
//    NSLog(@"indicator: %f. Self rotation: %f. Slice: %f. PrePointsSum: %f. Need Rotation: %f. Index: %i.", indicatorAngle, self.rotationAngle*180, selfAngle, sumPreviousPointValue,angelNeedToRotate, i);
//}


/***
 * 停止Pan的惯性动画
 */
//-(void)stopPanInertness {
//    if (self.panInertnessAnimTimer && [self.panInertnessAnimTimer isValid]) {
//        [self.panInertnessAnimTimer invalidate];
//        self.panInertnessAnimTimer = nil;
//        self.panStep = 0;
//        self.panSpeed = 0;
//        self.panState = 0;
//    }
//}

//-(void)panInertnessAnimTimerTarget {
//    if (fabs(self.panSpeed) <= fabs(self.panStep)) {
//        [self stopPanInertness];
//    } else {
//        self.rotationAngle+=self.panSpeed;
//        self.panSpeed -= self.panStep;
//    }
//}
-(void)rotationAnimTimerTarget {
    if (self.animationSteps == nil || self.animationSteps.count == 0) {
        [self.rotationAnimTimer invalidate];
        self.panSpeed = 0;
//        self.rotationAngle = self.animationTargetAngle;
    } else {
        CGFloat step = [self.animationSteps[0] doubleValue];
        [self.animationSteps removeObjectAtIndex:0];
        self.rotationAngle+=step;
    }
//    if (fabs(self.panSpeed) <= fabs(self.panStep)) {
//        [self stopPanInertness];
//    } else {
//        self.rotationAngle+=self.panSpeed;
//        self.panSpeed -= self.panStep;
//    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.animationSteps removeAllObjects];
    [super touchesEnded:touches withEvent:event];
    [self.animationManager rotateAngle:4 withInitialSpeed:.0];
    if (self.series.sumVisableValue <= 0) return;
    if (self.panSpeed > 0) {
        self.animationTargetAngle = self.rotationAngle + self.panSpeed * 5;
    } else {
        self.animationTargetAngle = self.rotationAngle;
    }
//    while (self.animationTargetAngle < 0 || self.animationTargetAngle >=2) {
//        self.animationTargetAngle += (self.animationTargetAngle<0)?2:-2;
//    }
    for (int i = 0; i < self.series.pieSlices.count; i++) {
        if (REMIsNilOrNull(self.series.pieSlices)) continue;
        DCPieSlice slice;
        [self.series.pieSlices[i] getValue:&slice];
        if (slice.sliceEnd > self.animationTargetAngle) {
            self.animationTargetAngle = slice.sliceCenter;
            break;
        }
    }
    CGFloat angleNeedRotate = self.animationTargetAngle - self.rotationAngle;
    NSUInteger frames = kDCAnimationDuration * kDCFramesPerSecord;
    if (self.panSpeed > 0) {
        CGFloat step = angleNeedRotate / [self sumFrom1To:frames];;
        for (int i = 1; i <= frames; i++) {
            [self.animationSteps addObject:@(self.panSpeed - (frames - i) * step)];
        }
    } else {
        int halfFrame = 0;
        CGFloat step = 0;
        if (frames % 2 == 0) {
            halfFrame = frames / 2;
            step = angleNeedRotate / ([self sumFrom1To:halfFrame] * 2);
        } else {
            halfFrame = frames / 2 + 1;
            step = angleNeedRotate / ([self sumFrom1To:halfFrame-1] * 2 + halfFrame);
        }
        for (int i = 0; i < frames; i++) {
            if (i >= halfFrame) {
                [self.animationSteps addObject:@((frames - i) * step)];
            } else {
                [self.animationSteps addObject:@(i * step)];
            }
        }
    }
    
//    self.rotationAnimTimer = [NSTimer scheduledTimerWithTimeInterval:1/kDCFramesPerSecord target:self selector:@selector(rotationAnimTimerTarget) userInfo:nil repeats:YES];
//    self.panInertnessAnimTimer = [NSTimer scheduledTimerWithTimeInterval:1/kDCFramesPerSecord target:self selector:@selector(panInertnessAnimTimerTarget) userInfo:nil repeats:YES];
}

-(NSUInteger)sumFrom1To:(NSUInteger)i {
    return (1 + i) * i / 2;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
//    [self stopPanInertness];
//    [self findDataPointIndexByPoint:[touches.anyObject locationInView:self]];
//    [self align];
}

-(void)animateFullAngle {
    if (self.beginAnimTimer.isValid) {
        self.fullAngle+=2/kDCAnimationDuration/kDCFramesPerSecord;
        if (self.fullAngle == 2) {
            [self.beginAnimTimer invalidate];
        }
    }
}

-(void)setRotationAngle:(CGFloat)rotationAngle {
    if (rotationAngle >= 2) rotationAngle -= 2;
    if (rotationAngle < 0) rotationAngle += 2;
    _rotationAngle = rotationAngle;
//    [self setNeedsDisplay];
}

-(void)setFullAngle:(CGFloat)fullAngle {
    if (fullAngle > 2) fullAngle = 2;
    if (fullAngle < 0) fullAngle = 0;
    if (_fullAngle == fullAngle) return;
    _fullAngle = fullAngle;
//    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect {
    // Nothing to do but cannot be removed.
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    [super drawLayer:layer inContext:ctx];
    if (self.series.sumVisableValue > 0) {
        _indicatorPoint = CGPointMake(self.center.x, self.center.y-self.radius*2/3);
        UIColor* shadowColor = [REMColor colorByHexString:kDCPieShadowColor alpha:self.indicatorAlpha];
        CGContextSetFillColorWithColor(ctx, shadowColor.CGColor);
        CGContextMoveToPoint(ctx, self.center.x, self.center.y);
        CGContextAddArc(ctx, self.center.x, self.center.y, self.radiusForShadow, 0, M_PI*2, 0);
        CGContextDrawPath(ctx, kCGPathFill);
        
        CGFloat startAnglePI = self.rotationAngle * M_PI;
        for (int i = 0; i < self.series.datas.count; i++) {
            DCPieDataPoint* point = self.series.datas[i];
            if (point.hidden || point.pointType != DCDataPointTypeNormal) continue;
            CGFloat pieSlicePI = point.value.doubleValue / self.series.sumVisableValue * M_PI * self.fullAngle;
            UIColor* color = [REMColor colorByIndex:i].uiColor;
            CGContextSetFillColorWithColor(ctx, color.CGColor);
            CGContextMoveToPoint(ctx, self.center.x, self.center.y);
            CGContextAddArc(ctx, self.center.x, self.center.y, self.radius, startAnglePI, pieSlicePI+startAnglePI, 0);
            CGContextDrawPath(ctx, kCGPathFill);
            startAnglePI+=pieSlicePI;
        }
        
        if(self.indicatorAlpha > 0) {
            UIColor* indicatorColor = [REMColor colorByHexString:kDCPieIndicatorColor alpha:self.indicatorAlpha];
            CGContextSetFillColorWithColor(ctx, indicatorColor.CGColor);
            CGContextMoveToPoint(ctx, self.indicatorPoint.x, self.indicatorPoint.y);
            CGContextAddArc(ctx, self.center.x, self.center.y, self.radius+1, -M_PI/20-M_PI/2, M_PI/20-M_PI/2, 0);
            CGContextDrawPath(ctx, kCGPathFill);
        }
    }
}

@end
