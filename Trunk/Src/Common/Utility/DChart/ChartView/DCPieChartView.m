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

@property (nonatomic,assign) int panState; // 1表示已经开始，0表示正在Pan，-1表示Pan已经停止
@property (nonatomic,assign) CGFloat panSpeed;

@property (nonatomic,assign) CGPoint indicatorPoint; // indicator针尖的点位置

@property (nonatomic,strong) DCPieChartAnimationManager* animationManager;
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
        
        _series = series;
    }
    return self;
}
                               
-(void)didMoveToSuperview {
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
        targetFrame.radius = @(self.radius);
        targetFrame.radiusForShadow = @(self.radiusForShadow);
        targetFrame.rotationAngle = @(1.5-targetRotation); // Indicator在1.5*PI的位置
        targetFrame.fullAngle = @(2);
        targetFrame.indicatorAlpha = @(0.8);
        self.radius = 0;
        self.radiusForShadow = 0;
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
        
        self.panSpeed = rotation;
        [self setNeedsDisplay];
    }
}

-(BOOL)isPointInPie:(CGPoint)point {
    CGFloat panStart = pow(pow((point.x - self.center.x), 2) + pow(point.y-self.center.y, 2),0.5);
    return panStart <= self.radiusForShadow;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (self.series.sumVisableValue <= 0) return;
    if (self.panSpeed != 0) {
        [self.animationManager rotateWithInitialSpeed:self.panSpeed];
        self.panSpeed = 0;
    }
}

-(NSUInteger)sumFrom1To:(NSUInteger)i {
    return (1 + i) * i / 2;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.animationManager stopTimer];
    self.panSpeed = 0;
}

-(void)setRotationAngle:(CGFloat)rotationAngle {
    if (rotationAngle >= 2) rotationAngle -= 2;
    if (rotationAngle < 0) rotationAngle += 2;
    _rotationAngle = rotationAngle;
}

-(void)setFullAngle:(CGFloat)fullAngle {
    if (fullAngle > 2) fullAngle = 2;
    if (fullAngle < 0) fullAngle = 0;
    if (_fullAngle == fullAngle) return;
    _fullAngle = fullAngle;
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
        
        if(self.indicatorAlpha > 0 && self.showIndicator) {
            UIColor* indicatorColor = [REMColor colorByHexString:kDCPieIndicatorColor alpha:self.indicatorAlpha];
            CGContextSetFillColorWithColor(ctx, indicatorColor.CGColor);
            CGContextMoveToPoint(ctx, self.indicatorPoint.x, self.indicatorPoint.y);
            CGContextAddArc(ctx, self.center.x, self.center.y, self.radius+.2, -M_PI/20-M_PI/2, M_PI/20-M_PI/2, 0);
            CGContextDrawPath(ctx, kCGPathFill);
        }
    }
}

@end
