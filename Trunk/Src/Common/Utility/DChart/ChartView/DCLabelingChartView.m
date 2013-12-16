//
//  DCLabelingChartView.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/16/13.
//
//

#import "DCLabelingChartView.h"
#import "REMColor.h"
#import "REMTargetEnergyData.h"

@interface DCLabelingChartView()
@property (nonatomic, assign) CGFloat labelHeight;
@property (nonatomic, assign) CGFloat stageHeight;
@property (nonatomic, assign) CGFloat stageMargin;
@end

@implementation DCLabelingChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self constructSharp:500 height:100 arc:90 radius:40 color:[REMColor colorByIndex:0].uiColor];
    }
    return self;
}



-(void)drawRect:(CGRect)rect {
    
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    if (REMIsNilOrNull(self.delegate)) return;
    NSUInteger stageCount = [self.delegate getStageCount];
    NSUInteger valCount = [self.delegate getLabelCount];
    if (stageCount == 0 || valCount == 0) return;
    
    
}

-(void)willMoveToSuperview:(UIView *)newSuperview {
    CGFloat plotHeight = CGRectGetHeight(self.frame);
    
}

-(CAShapeLayer*)constructSharp:(CGFloat)width height:(CGFloat)height arc:(CGFloat)arc radius:(CGFloat)radius color:(UIColor*)color {
    CAShapeLayer* layer = [[CAShapeLayer alloc]init];
    UIBezierPath*    aPath = [UIBezierPath bezierPath];
    // Set the starting point of the shape.
    CGFloat x = 0; //radius * sin((180-arc/2)*M_PI/180);
    
    layer.fillColor = color.CGColor;
    [aPath moveToPoint:CGPointZero];
    [aPath addLineToPoint:CGPointMake(width - height / 2 - x, 0)];
//    [aPath addArcWithCenter:CGPointMake(width - height / 2 - x, radius) radius:radius startAngle:M_PI/2*3 endAngle:M_PI*(1.5+arc/360) clockwise:YES];
    [aPath addLineToPoint:CGPointMake(width, height/2)];
//    [aPath addArcWithCenter:CGPointMake(width - height / 2 - x, height - radius) radius:radius startAngle:M_PI/2 endAngle:M_PI*(0.5-arc/360) clockwise:NO];
    [aPath addLineToPoint:CGPointMake(width - height / 2 - x, height)];
    [aPath addLineToPoint:CGPointMake(0.0, height)];
    
    [aPath closePath];
    layer.frame = CGRectMake(100, 100, width, height);
    layer.cornerRadius = 5;
    layer.path = aPath.CGPath;
    layer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:layer];
    return layer;
}

-(UIBezierPath*)getPath {
    
}
@end
