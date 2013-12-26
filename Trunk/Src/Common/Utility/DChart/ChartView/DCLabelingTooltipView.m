//
//  DCLabelingTooltipView.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/17/13.
//
//

#import "DCLabelingTooltipView.h"
#import "DCUtility.h"
#import "REMColor.h"

@interface DCLabelingTooltipView()
@property (nonatomic, strong) CAShapeLayer* triangleLayer;
//@property (nonatomic, strong) CAShapeLayer* dotLayer;
//@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UILabel* benchmarkLabel;
@property (nonatomic, strong) UILabel* labelTextLabel;

@property (nonatomic, assign) CGPoint focusPoint;
//@property (nonatomic, assign) CGFloat triangleSize;
//@property (nonatomic, assign) CGFloat iconSize;
//
//@property (nonatomic, assign) CGFloat width;
@end



@implementation DCLabelingTooltipView

- (id)initWithStyle:(REMChartStyle*)style
{
    self = [super init];
    if (self) {
        self.style = style;
        self.hidden = YES;
        self.alpha = 0;
        
        // Initialization code
//        self.layer.shadowOffset = CGSizeMake(5, 5);
//        self.layer.shadowRadius = 5;
//        self.layer.shadowOpacity = 0.6;
//        self.layer.shadowColor = [UIColor blackColor].CGColor;
        
        self.triangleLayer = [[CAShapeLayer alloc]init];
        self.triangleLayer.contentsScale = [UIScreen mainScreen].scale;
        self.triangleLayer.fillColor = [REMColor colorByHexString:@"#F2F2F2F2"].CGColor;
        [self.layer addSublayer:self.triangleLayer];

        self.benchmarkLabel = [[UILabel alloc]init];
        self.benchmarkLabel.font = [UIFont fontWithName:self.style.labelingFontName size:self.style.labelingTooltipViewFontSize];
        self.benchmarkLabel.textColor = self.style.labelingTooltipViewFontColor;
        self.benchmarkLabel.backgroundColor = [UIColor clearColor];
        self.benchmarkLabel.textAlignment = NSTextAlignmentLeft;
        self.benchmarkLabel.text = @"  ";
        [self addSubview:self.benchmarkLabel];
        self.labelTextLabel = [[UILabel alloc]init];
        self.labelTextLabel.font = self.benchmarkLabel.font;
        self.labelTextLabel.textColor = self.style.labelingTooltipViewFontColor;
        self.labelTextLabel.backgroundColor = [UIColor clearColor];
        self.labelTextLabel.textAlignment = NSTextAlignmentLeft;
        self.labelTextLabel.text = @"  ";
        [self addSubview:self.labelTextLabel];
        [self.labelTextLabel sizeToFit];
        [self.benchmarkLabel sizeToFit];
        CGFloat hPadding = self.style.labelingTooltipViewHPadding;
        CGFloat vPadding = self.style.labelingTooltipViewVPadding;
        CGSize benchmarkSize = self.benchmarkLabel.frame.size;
        CGSize labelTextSize = self.labelTextLabel.frame.size;
        self.benchmarkLabel.frame = CGRectMake(hPadding, vPadding, benchmarkSize.width, benchmarkSize.height);
        self.labelTextLabel.frame = CGRectMake(hPadding, vPadding*2+benchmarkSize.height, labelTextSize.width, labelTextSize.height);
        
    }
    return self;
}

-(void)setLabelText:(NSString *)labelText {
    _labelText = labelText;
    self.labelTextLabel.text = labelText;
    [self.labelTextLabel sizeToFit];
}

-(void)setBenchmarkText:(NSString *)benchmarkText {
    _benchmarkText = benchmarkText;
    self.benchmarkLabel.text = benchmarkText;
    [self.benchmarkLabel sizeToFit];
}

-(void)showAt:(CGPoint)point {
    CGFloat hPadding = self.style.labelingTooltipViewHPadding;
    CGFloat vPadding = self.style.labelingTooltipViewVPadding;
    CGSize benchmarkSize = self.benchmarkLabel.frame.size;
    CGSize labelTextSize = self.labelTextLabel.frame.size;
    self.benchmarkLabel.frame = CGRectMake(hPadding, vPadding, benchmarkSize.width, benchmarkSize.height);
    self.labelTextLabel.frame = CGRectMake(hPadding, vPadding*2+benchmarkSize.height, labelTextSize.width, labelTextSize.height);
    
    CGFloat toWidth = hPadding*2+MAX(labelTextSize.width, benchmarkSize.width);
    CGFloat toHeight = vPadding*3+benchmarkSize.height+labelTextSize.height+self.style.labelingTooltipViewTriangleHeight;
    CGFloat toX = point.x - toWidth / 2;
    CGFloat toY = point.y - toHeight;
    if (toX < 5) toX = 5;
    if (toX + toWidth > self.superview.frame.size.width) toX = self.superview.frame.size.width - toWidth;
    if (toY < 0) toY = 0;
    if (toY + toHeight > self.superview.frame.size.height) toY = self.superview.frame.size.height - toHeight;
    CGRect toFrame = CGRectMake(toX, toY, toWidth, toHeight);
    self.focusPoint = CGPointMake(MAX(point.x-toFrame.origin.x, self.style.labelingTooltipViewTriangleMinPaddingToEdge+self.style.labelingTooltipViewTriangleWidth/2), toHeight);
    if (self.hidden) {
        self.hidden = NO;
        self.frame = toFrame;
        [UIView animateWithDuration:0.2 animations:^(void){
            self.alpha = 1;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^(void){
            self.alpha = 1;
            self.frame = toFrame;
        }];
    }
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    CGFloat cornerRadius = self.style.labelingTooltipViewCornerRadius;
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat rectangleHeight = height - self.style.labelingTooltipViewTriangleHeight;
    [aPath moveToPoint:CGPointMake(width-cornerRadius, 0)];
    //右上圆角
    [aPath addQuadCurveToPoint:CGPointMake(width,cornerRadius) controlPoint:CGPointMake(width, 0)];
    //右边线
    [aPath addLineToPoint:CGPointMake(width,rectangleHeight-cornerRadius)];
    //右下圆角
    [aPath addQuadCurveToPoint:CGPointMake(width-cornerRadius,rectangleHeight) controlPoint:CGPointMake(width,rectangleHeight)];
    //下边线在三角的右部分
    [aPath addLineToPoint:CGPointMake(self.focusPoint.x+self.style.labelingTooltipViewTriangleWidth/2,rectangleHeight)];
    //三角形右边
    [aPath addLineToPoint:CGPointMake(self.focusPoint.x,height)];
    //三角形左边
    [aPath addLineToPoint:CGPointMake(self.focusPoint.x-self.style.labelingTooltipViewTriangleWidth/2,rectangleHeight)];
    //下边线在三角的左部分
    [aPath addLineToPoint:CGPointMake(cornerRadius,rectangleHeight)];
    //左下圆角
    [aPath addQuadCurveToPoint:CGPointMake(0,rectangleHeight-cornerRadius) controlPoint:CGPointMake(0,rectangleHeight)];
    //左边
    [aPath addLineToPoint:CGPointMake(0,cornerRadius)];
    //左上圆角
    [aPath addQuadCurveToPoint:CGPointMake(cornerRadius,0) controlPoint:CGPointMake(0,0)];
    [aPath closePath];
//    [aPath fill];
    self.triangleLayer.path = aPath.CGPath;
}

@end
