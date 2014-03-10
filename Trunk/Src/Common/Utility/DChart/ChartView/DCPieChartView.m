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
@property (nonatomic, strong) CAShapeLayer* indicatorLayer;

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
        self.indicatorLayer = [[CAShapeLayer alloc]init];
        self.indicatorLayer.contentsScale = [UIScreen mainScreen].scale;
        self.indicatorLayer.hidden = YES;
        [self.layer addSublayer:self.indicatorLayer];
        
        _animationManager = [[DCPieChartAnimationManager alloc]initWithPieView:self];
        _rotationAngle = 0;
        _fullAngle = 0;
        _indicatorAlpha = 0;
        _radius = 0;
        _radiusForShadow = 0;
        _panState = -1;
        _showIndicator = NO;
        
        _focusPointIndex = 0;
        
        _series = series;
        
        self.animationManager.series = series;
        self.pieLayer = [[DCPieLayer alloc]init];
        self.pieLayer.animationManager = self.animationManager;
        self.pieLayer.view = self;
        self.pieLayer.frame = CGRectMake(self.center.x, self.center.y, 0, 0);
        [self.layer addSublayer:self.pieLayer];
        self.tapGsRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
        [self addGestureRecognizer:self.tapGsRec];
        self.panGsRec = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(viewPanned:)];
        [self addGestureRecognizer:self.panGsRec];
        self.panGsRec.maximumNumberOfTouches = 1;
        self.tapGsRec.cancelsTouchesInView = NO;
        self.panGsRec.cancelsTouchesInView = NO;
    }
    return self;
}

-(void)updateGestures {
    self.tapGsRec.enabled = self.chartStyle.acceptTap;
    self.panGsRec.enabled = self.chartStyle.acceptPan;
}

-(void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self updateGestures];
    
    CGFloat indicatorXCentre = CGRectGetWidth(self.bounds) / 2;
    CGFloat indicatorSize = self.chartStyle.focusSymbolIndicatorSize;
    self.indicatorLayer.fillColor = self.chartStyle.indicatorColor.CGColor;
    UIBezierPath* indicatorPath = [UIBezierPath bezierPath];
    [indicatorPath moveToPoint:CGPointMake(indicatorXCentre - indicatorSize / 2, 0)];
    [indicatorPath addLineToPoint:CGPointMake(indicatorXCentre + indicatorSize / 2, 0)];
    [indicatorPath addLineToPoint:CGPointMake(indicatorXCentre, indicatorSize / 2)];
    [indicatorPath closePath];
    self.indicatorLayer.path = indicatorPath.CGPath;
    
    double targetRotation = [self.animationManager findNearbySliceCenter:0];
    DCPieChartAnimationFrame* targetFrame = [[DCPieChartAnimationFrame alloc]init];
    targetFrame.radius = @(self.radius);
    targetFrame.radiusForShadow = @(self.radiusForShadow);
    targetFrame.rotationAngle = @(-targetRotation);
    targetFrame.fullAngle = @(2);
    targetFrame.indicatorAlpha = @(0.8);
    if (self.chartStyle.playBeginAnimation) {
        self.radius = 0;
        self.radiusForShadow = 0;
        [self.animationManager animateToFrame:targetFrame callback:^(void){
            if (!(REMIsNilOrNull(self.delegate)) && [self.delegate respondsToSelector:@selector(beginAnimationDone)]) {
                [self.delegate beginAnimationDone];
            }
        }];
    } else {
        [self.animationManager playFrames:@[targetFrame] callback:nil];
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
            [self hidePercentageTexts];
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
        [self.animationManager playFrames:[self.animationManager getAngleTurningFramesFrom:self.rotationAngle to:2-[self.animationManager findNearbySliceCenter:self.rotationAngle]] callback:nil];
    }
    self.panSpeed = 0;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
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

-(void)setIndicatorHidden:(BOOL)hidden {
    self.indicatorLayer.hidden = hidden;
}
@end
