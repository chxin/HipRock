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
#import "REMChartHeader.h"
#import "DCPieLayer.h"

@interface DCPieChartView()
@property (nonatomic,strong) UIPanGestureRecognizer* panGsRec;
@property (nonatomic,strong) UITapGestureRecognizer* tapGsRec;

@property (nonatomic,assign) int panState; // 1表示已经开始，-1表示Pan已经停止
@property (nonatomic,assign) CGFloat panSpeed;

@property (nonatomic,strong) DCPieChartAnimationManager* animationManager;

@property (nonatomic,strong) DCPieLayer* pieLayer;
@end

@implementation DCPieChartView

- (id)initWithFrame:(CGRect)frame series:(DCPieSeries*)series
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _animationManager = [[DCPieChartAnimationManager alloc]initWithPieView:self];
        _rotationAngle = 0;
        _fullAngle = 0;
        _indicatorAlpha = 0;
        _radius = 0;
        _radiusForShadow = 0;
        _panState = -1;
        _showIndicator = NO;
        _playBeginAnimation = YES;
        
        _focusPointIndex = 0;
        
        _series = series;
        
        self.animationManager.series = series;
        self.pieLayer = [[DCPieLayer alloc]init];
        self.pieLayer.animationManager = self.animationManager;
        self.pieLayer.view = self;
        self.pieLayer.frame = CGRectMake(self.center.x, self.center.y, 0, 0);
        [self.layer addSublayer:self.pieLayer];
    }
    return self;
}

-(void)updateGestures {
    if (self.userInteractionEnabled) {
        if (REMIsNilOrNull(self.tapGsRec)) {
            self.tapGsRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
            self.panGsRec = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(viewPanned:)];
            self.panGsRec.maximumNumberOfTouches = 1;
            self.tapGsRec.cancelsTouchesInView = NO;
            self.panGsRec.cancelsTouchesInView = NO;
            [self addGestureRecognizer:self.tapGsRec];
            [self addGestureRecognizer:self.panGsRec];
        }
    } else {
        if (!REMIsNilOrNull(self.tapGsRec)) {
            [self removeGestureRecognizer:self.tapGsRec];
            self.tapGsRec = nil;
            [self removeGestureRecognizer:self.panGsRec];
            self.panGsRec = nil;
        }
    }
}

-(void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    if(self.userInteractionEnabled == userInteractionEnabled) return;
    [super setUserInteractionEnabled:userInteractionEnabled];
    [self updateGestures];
}

-(void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self updateGestures];
    
    double targetRotation = [self.animationManager findNearbySliceCenter:0];
    DCPieChartAnimationFrame* targetFrame = [[DCPieChartAnimationFrame alloc]init];
    targetFrame.radius = @(self.radius);
    targetFrame.radiusForShadow = @(self.radiusForShadow);
    targetFrame.rotationAngle = @(-targetRotation);
    targetFrame.fullAngle = @(2);
    targetFrame.indicatorAlpha = @(0.8);
    if (self.playBeginAnimation) {
        self.radius = 0;
        self.radiusForShadow = 0;
        [self.animationManager animateToFrame:targetFrame];
    } else {
        [self.animationManager playFrames:@[targetFrame]];
    }
    self.pieLayer.frame = CGRectMake(self.center.x-targetFrame.radiusForShadow.doubleValue, self.center.y-targetFrame.radiusForShadow.doubleValue, targetFrame.radiusForShadow.doubleValue*2, targetFrame.radiusForShadow.doubleValue*2);
    
}

-(void)redraw {
    [self.pieLayer setNeedsDisplay];
}

-(void)viewPanned:(UIPanGestureRecognizer*)gesture {
    CGPoint panPoint = [gesture locationInView:self];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if ([self isPointInPie:panPoint]) {
            self.panState = 1;
            [self sendTouchBeganEvent];
        }
    }
    if (gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateEnded) {
        self.panState = -1;
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
        
        self.panSpeed = rotation;
        [self redraw];
    }
}

-(void)sendTouchBeganEvent {
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchBegan)]) {
        [self.delegate touchBegan];
    }
}

-(void)viewTapped:(UITapGestureRecognizer *)gesture {
    [self sendTouchBeganEvent];
    [self sendPointFocusEvent];
}

-(void)sendPointFocusEvent {
    // 找到预计旋转角度对应的扇区的中线位置
    _focusPointIndex = [self.animationManager findIndexOfSlide:self.rotationAngle];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pieRotated)]) {
        [self.delegate pieRotated];
    }
}

-(BOOL)isPointInPie:(CGPoint)point {
    CGFloat panStart = pow(pow((point.x - self.center.x), 2) + pow(point.y-self.center.y, 2),0.5);
    return panStart <= self.radiusForShadow;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if ([self.animationManager getVisableSliceSum] <= 0) return;
    if (fabs(self.panSpeed) >= 0.05) {
        [self.animationManager rotateWithInitialSpeed:self.panSpeed];
    } else {
        [self.animationManager playFrames:[self.animationManager getAngleTurningFramesFrom:self.rotationAngle to:2-[self.animationManager findNearbySliceCenter:self.rotationAngle]]];
    }
    self.panSpeed = 0;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self hidePercentageTexts];
    [self.animationManager stopTimer];
    self.panSpeed = 0;
    _rotateDirection = REMDirectionNone;
}

-(void)setRotationAngle:(CGFloat)rotationAngle {
    if (rotationAngle >= 2) rotationAngle -= 2;
    if (rotationAngle < 0) rotationAngle += 2;
    double delta = rotationAngle - self.rotationAngle;
    if (rotationAngle == self.rotationAngle) _rotateDirection = REMDirectionNone;
    else if (fabs(delta) > 1) _rotateDirection = REMDirectionLeft;
    else _rotateDirection = REMDirectionRight;
    _rotationAngle = rotationAngle;
    [self sendPointFocusEvent];
}

-(void)setFullAngle:(CGFloat)fullAngle {
    if (fullAngle > 2) fullAngle = 2;
    if (fullAngle < 0) fullAngle = 0;
    if (_fullAngle == fullAngle) return;
    _fullAngle = fullAngle;
}

-(void)setSlice:(DCPieDataPoint *)slice hidden:(BOOL)hidden {
    if (slice.hidden == hidden) return;
    [self.animationManager setPoint:slice hidden:hidden];
}

-(void)showPercentageTexts {
    self.pieLayer.percentageTextHidden = NO;
    [self.pieLayer setNeedsDisplay];
}

-(void)hidePercentageTexts {
    self.pieLayer.percentageTextHidden = YES;
    [self.pieLayer setNeedsDisplay];
}
@end
