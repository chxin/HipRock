//
//  DCPieChartView.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/24/13.
//
//

#import "DCPieChartView.h"
#import "REMColor.h"
#import "DCPieDataPoint.h"
#import "DCPieSeries.h"

@interface DCPieChartView()
@property (nonatomic,strong) NSTimer* beginAnimTimer;
@property (nonatomic,assign) CGFloat fullAngle;         // 扇图的总体的角度和，值域为0-2，例如如果只需要画半圆，fullAngle=1
@property (nonatomic,assign) CGFloat radius;
@property (nonatomic,assign) CGFloat radiusForShadow;
@property (nonatomic,strong) DCPieSeries* series;
@property (nonatomic,assign) CGFloat rotationAngle;     // 扇图已经旋转的角度，值域为0-2，例如需要旋转90°，rotationAngle=0.5
@property (nonatomic,assign) CGFloat indicatorAlpha;
@property (nonatomic,assign) NSTimer* panInertnessAnimTimer;
@property (nonatomic,strong) UIPanGestureRecognizer* panGesRec;
@property (nonatomic,strong) UISwipeGestureRecognizer* swipeGesRec;

@property (nonatomic,assign) int panState; // 1表示已经开始，0表示正在Pan，-1表示Pan已经停止
@property (nonatomic,assign) CGFloat panSpeed;
@property (nonatomic,assign) CGFloat panStep; // Pan松手时，speed减速的步长
@end

@implementation DCPieChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _panState = -1;
        _rotationAngle = 0;
        _fullAngle = 0;
        _indicatorAlpha = 0.5;
        self.backgroundColor = [UIColor whiteColor];
        self.radius = 180;
        self.radiusForShadow = 190;
        
        NSMutableArray* datas = [[NSMutableArray alloc]init];
        for (int i = 0; i < 10; i++) {
            DCPieDataPoint* p = [[DCPieDataPoint alloc]init];
            p.value = @(i+1);
            [datas addObject:p];
        }
        self.series = [[DCPieSeries alloc]initWithEnergyData:datas];
    }
    return self;
}
                               
-(void)didMoveToSuperview {
    self.beginAnimTimer = [NSTimer scheduledTimerWithTimeInterval:1/kDCFramesPerSecord target:self selector:@selector(animateFullAngle) userInfo:nil repeats:YES];
    [self.beginAnimTimer fire];
    [super didMoveToSuperview];
    if (self.userInteractionEnabled) {
        self.panGesRec = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(viewPan:)];
        self.panGesRec.cancelsTouchesInView = NO;
        [self addGestureRecognizer:self.panGesRec];
    }
}

-(void)viewPan:(UIPanGestureRecognizer*)gesture {
    CGPoint panPoint = [gesture locationInView:self];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGFloat panStart = pow(pow((panPoint.x - self.center.x), 2) + pow(panPoint.y-self.center.y, 2),0.5);
        if (panStart <= self.radiusForShadow) {
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
        
        self.panStep  = rotation/kDCAnimationDuration/kDCFramesPerSecord;
        self.panSpeed = rotation;
        
    }
}


/***
 * 停止Pan的惯性动画
 */
-(void)stopPanInertness {
    if (self.panInertnessAnimTimer && [self.panInertnessAnimTimer isValid]) {
        [self.panInertnessAnimTimer invalidate];
        self.panInertnessAnimTimer = nil;
        self.panStep = 0;
        self.panSpeed = 0;
        self.panState = 0;
    }
}

-(void)panInertnessAnimTimerTarget {
    if (fabs(self.panSpeed) <= fabs(self.panStep)) {
        [self stopPanInertness];
    } else {
        self.rotationAngle+=self.panSpeed;
        self.panSpeed -= self.panStep;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.panInertnessAnimTimer = [NSTimer scheduledTimerWithTimeInterval:1/kDCFramesPerSecord target:self selector:@selector(panInertnessAnimTimerTarget) userInfo:nil repeats:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self stopPanInertness];
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
    if (rotationAngle > M_PI * 2) rotationAngle -= M_PI*2;
    _rotationAngle = rotationAngle;
    [self setNeedsDisplay];
}

-(void)setFullAngle:(CGFloat)fullAngle {
    if (fullAngle > 2) fullAngle = 2;
    if (fullAngle < 0) fullAngle = 0;
    if (_fullAngle == fullAngle) return;
    _fullAngle = fullAngle;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect {
    // Nothing to do but cannot be removed.
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    layer.contentsScale = [[UIScreen mainScreen] scale];
    [super drawLayer:layer inContext:ctx];
    
    UIColor* shadowColor = [REMColor colorByHexString:kDCPieShadowColor alpha:self.fullAngle/2];
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
        UIColor* indicatorColor = [REMColor colorByHexString:kDCPieIndicatorColor alpha:self.indicatorAlpha*self.fullAngle/2];
        CGContextSetFillColorWithColor(ctx, indicatorColor.CGColor);
        CGContextMoveToPoint(ctx, self.center.x, self.center.y-self.radius*2/3);
        CGContextAddArc(ctx, self.center.x, self.center.y, self.radius, -M_PI/20-M_PI/2, M_PI/20-M_PI/2, 0);
        CGContextDrawPath(ctx, kCGPathFill);
    }
}

@end
