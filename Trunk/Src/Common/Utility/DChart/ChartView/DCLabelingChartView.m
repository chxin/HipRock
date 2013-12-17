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
#import "DCUtility.h"
#import "DCLabelingLabel.h"

@interface DCLabelingChartView()
@property (nonatomic, assign) CGFloat labelHeight;
@property (nonatomic, assign) CGFloat stageHeight;
@property (nonatomic, assign) CGFloat stageVerticalMargin;

@property (nonatomic, assign) CGFloat labelWidth;
@property (nonatomic, assign) CGFloat labelHorizentalMargin;
@property (nonatomic, assign) CGFloat stageWidth;
@property (nonatomic, assign) CGFloat stageHorizentalMargin;

@end

//CGFloat const kDCLabelingTooltipArcWidth = 2;

CGFloat const kDCLabelingStageVerticalMargin = 0.5;
CGFloat const kDCLabelingLabelToStageHeight = 2;

CGFloat const kDCLabelingStageHorizentalMargin = 0.05;
CGFloat const kDCLabelingLabelToStageWidth = 1;
CGFloat const kDCLabelingLabelHorizentalMargin = 0.05;

@implementation DCLabelingChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        // Initialization code
//        [self constructSharp:500 height:100 arc:90 radius:40 color:[REMColor colorByIndex:0].uiColor];
    }
    return self;
}



-(void)drawRect:(CGRect)rect {
    
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    NSUInteger stageCount = self.series.stages.count;
    NSUInteger labelCount = self.series.labels.count;
    if (stageCount == 0 || labelCount == 0) return;
    
    CGPoint basePoint = CGPointMake(self.paddingLeft, self.paddingTop + (self.labelHeight - self.stageHeight) / 2);
    CGFloat stageWidthStep = self.stageWidth / 2 / (stageCount - 1);
    CGFloat tooltipIconRadius = self.stageHeight * 0.275;
    CGFloat stageFontSize = self.stageHeight*0.55;
    CGFloat tooltipIconFontSize = tooltipIconRadius*1.4;
    UIFont* tooltipIconFont = [UIFont fontWithName:self.fontName size:tooltipIconFontSize];
    UIFont* stageTextFont = [UIFont fontWithName:self.fontName size:stageFontSize];
    NSString* tooltipIconText =@"i";
    for (int i = 0; i < stageCount; i++) {
        CGContextSetFillColorWithColor(ctx, [self.series.stages[i] color].CGColor);
        CGMutablePathRef path = CGPathCreateMutable();
        CGFloat baseX = basePoint.x;
        CGFloat baseY = basePoint.y + i * (self.stageHeight + self.stageVerticalMargin);
        CGFloat theWidth = self.stageWidth - (stageCount - 1 - i) * stageWidthStep;
        CGPathMoveToPoint(path, NULL, baseX, baseY);
        CGPathAddLineToPoint(path, NULL, baseX + theWidth - self.stageHeight / 2, baseY);
        CGPathAddLineToPoint(path, NULL, baseX + theWidth, baseY + self.stageHeight / 2);
        CGPathAddLineToPoint(path, NULL, baseX + theWidth - self.stageHeight / 2, baseY + self.stageHeight);
        CGPathAddLineToPoint(path, NULL, baseX, baseY + self.stageHeight);
        CGPathCloseSubpath(path);
        
        CGContextAddPath(ctx, path);
        CGContextDrawPath(ctx, kCGPathFill);
        CGPathRelease(path);
        
        if (self.tooltipArcLineWidth > 0) {
            UIGraphicsPushContext(ctx);
            CGContextSetLineWidth(ctx, self.tooltipArcLineWidth);
            CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
            CGPoint tooltipCenter = CGPointMake(baseX+ self.stageHeight / 2, baseY + self.stageHeight / 2);
            CGContextAddArc(ctx, tooltipCenter.x, tooltipCenter.y, tooltipIconRadius, 0, M_PI*2, 0);
            CGContextDrawPath(ctx, kCGPathStroke);
            CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
            [tooltipIconText drawInRect:CGRectMake(tooltipCenter.x-tooltipIconRadius, tooltipCenter.y-tooltipIconFontSize/2, tooltipIconRadius*2, tooltipIconRadius*2) withFont:tooltipIconFont lineBreakMode:NSLineBreakByClipping alignment: NSTextAlignmentCenter];
            [[self.series.stages[i] stageText] drawInRect:CGRectMake(baseX, tooltipCenter.y-stageFontSize/2+self.tooltipArcLineWidth, theWidth - self.stageHeight / 2, stageFontSize) withFont:stageTextFont lineBreakMode:NSLineBreakByClipping alignment: NSTextAlignmentRight];
            UIGraphicsPopContext();
        }
    }
    
    CGFloat labelFontSize = 0;
    for (int i = 0; i < labelCount; i++) {
        DCLabelingLabel* label = self.series.labels[i];
        basePoint = CGPointMake(self.paddingLeft + self.stageWidth + self.stageHorizentalMargin + i * (self.labelWidth + self.labelHorizentalMargin * 2 + self.lineWidth), self.paddingTop);
        
        CGPoint addLines[2];
        addLines[0].x = basePoint.x + self.lineWidth / 2;
        addLines[0].y = basePoint.y;
        addLines[1].x = addLines[0].x;
        addLines[1].y = CGRectGetHeight(self.bounds)-self.paddingBottom;
        
        CGContextSetLineJoin(ctx, kCGLineJoinMiter);
        [DCUtility setLineStyle:ctx style:DCLineTypeDashed lineWidth:self.lineWidth];
        CGContextSetBlendMode(ctx, kCGBlendModeNormal);
        CGContextBeginPath(ctx);
        CGContextAddLines(ctx, addLines, 2);
        CGContextSetLineWidth(ctx, self.lineWidth);
        CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
        CGContextStrokePath(ctx);
        
        CGContextSetFillColorWithColor(ctx, label.color.CGColor);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPoint labelPoints[5];
        CGFloat baseX = basePoint.x + self.lineWidth + self.labelHorizentalMargin;
        CGFloat baseY = basePoint.y + label.stage * (self.stageHeight + self.stageVerticalMargin);
        labelPoints[0].x = baseX;
        labelPoints[0].y = baseY + self.labelHeight / 2;
        labelPoints[1].x = baseX + self.labelHeight / 2;
        labelPoints[1].y = baseY;
        labelPoints[2].x = baseX + self.labelWidth;
        labelPoints[2].y = baseY;
        labelPoints[3].x = baseX + self.labelWidth;
        labelPoints[3].y = baseY + self.labelHeight;
        labelPoints[4].x = baseX + self.labelHeight / 2;
        labelPoints[4].y = baseY + self.labelHeight;
        
        CGPathMoveToPoint(path, NULL, labelPoints[0].x, labelPoints[0].y);
        CGPathAddLineToPoint(path, NULL, labelPoints[1].x, labelPoints[1].y);
        CGPathAddLineToPoint(path, NULL, labelPoints[2].x, labelPoints[2].y);
        CGPathAddLineToPoint(path, NULL, labelPoints[3].x, labelPoints[3].y);
        CGPathAddLineToPoint(path, NULL, labelPoints[4].x, labelPoints[4].y);
        CGPathCloseSubpath(path);
        
        CGContextAddPath(ctx, path);
        CGContextDrawPath(ctx, kCGPathFill);
        CGPathRelease(path);
        
//        UIGraphicsPushContext(ctx);
//        CGContextSetLineWidth(ctx, kDCLabelingTooltipArcWidth);
//        CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
//        CGPoint tooltipCenter = CGPointMake(baseX+ self.stageHeight / 2, baseY + self.stageHeight / 2);
//        CGContextAddArc(ctx, tooltipCenter.x, tooltipCenter.y, tooltipIconRadius, 0, M_PI*2, 0);
//        CGContextDrawPath(ctx, kCGPathStroke);
//        CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
//        [tooltipIconText drawInRect:CGRectMake(tooltipCenter.x-tooltipIconRadius, tooltipCenter.y-tooltipIconFontSize/2, tooltipIconRadius*2, tooltipIconRadius*2) withFont:tooltipIconFont lineBreakMode:NSLineBreakByClipping alignment: NSTextAlignmentCenter];
//        [[self.series.stages[i] stageText] drawInRect:CGRectMake(baseX, tooltipCenter.y-stageFontSize/2+kDCLabelingTooltipArcWidth, theWidth - self.stageHeight / 2, stageFontSize) withFont:stageTextFont lineBreakMode:NSLineBreakByClipping alignment: NSTextAlignmentRight];
//        UIGraphicsPopContext();
    }
}

-(void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    [self recalculateSize];
    [self setNeedsDisplay];
}

-(void)recalculateSize {
    NSUInteger stageCount = self.series.stages.count;
    NSUInteger labelCount = self.series.labels.count;
    if (stageCount == 0 || labelCount == 0) return;
    CGFloat plotHeight = CGRectGetHeight(self.frame)-self.paddingBottom-self.paddingTop;
    self.stageHeight = plotHeight / ((stageCount - 1) * (1 + kDCLabelingStageVerticalMargin) + kDCLabelingLabelToStageHeight);
    self.stageVerticalMargin = kDCLabelingStageVerticalMargin * self.stageHeight;
    self.labelHeight = kDCLabelingLabelToStageHeight * self.stageHeight;
    
    CGFloat plotWidth = CGRectGetWidth(self.frame)-self.paddingLeft-self.paddingRight;
    self.stageWidth = (plotWidth - labelCount * self.lineWidth) / (1 + kDCLabelingStageHorizentalMargin + kDCLabelingLabelToStageWidth * (1 + 2 * kDCLabelingLabelHorizentalMargin) * labelCount - kDCLabelingLabelHorizentalMargin);
    self.stageHorizentalMargin = self.stageWidth * kDCLabelingStageHorizentalMargin;
    self.labelWidth = self.stageWidth * kDCLabelingLabelToStageWidth;
    self.labelHorizentalMargin = self.labelWidth * kDCLabelingLabelHorizentalMargin;
}

//-(CAShapeLayer*)constructSharp:(CGFloat)width height:(CGFloat)height arc:(CGFloat)arc radius:(CGFloat)radius color:(UIColor*)color {
//    CAShapeLayer* layer = [[CAShapeLayer alloc]init];
//    UIBezierPath*    aPath = [UIBezierPath bezierPath];
//    // Set the starting point of the shape.
//    CGFloat x = 0; //radius * sin((180-arc/2)*M_PI/180);
//    
//    layer.fillColor = color.CGColor;
//    [aPath moveToPoint:CGPointZero];
//    [aPath addLineToPoint:CGPointMake(width - height / 2 - x, 0)];
////    [aPath addArcWithCenter:CGPointMake(width - height / 2 - x, radius) radius:radius startAngle:M_PI/2*3 endAngle:M_PI*(1.5+arc/360) clockwise:YES];
//    [aPath addLineToPoint:CGPointMake(width, height/2)];
////    [aPath addArcWithCenter:CGPointMake(width - height / 2 - x, height - radius) radius:radius startAngle:M_PI/2 endAngle:M_PI*(0.5-arc/360) clockwise:NO];
//    [aPath addLineToPoint:CGPointMake(width - height / 2 - x, height)];
//    [aPath addLineToPoint:CGPointMake(0.0, height)];
//    
//    [aPath closePath];
//    layer.frame = CGRectMake(100, 100, width, height);
//    layer.cornerRadius = 5;
//    layer.path = aPath.CGPath;
//    layer.contentsScale = [UIScreen mainScreen].scale;
//    [self.layer addSublayer:layer];
//    return layer;
//}
//
//-(UIBezierPath*)getPath {
//    
//}
@end
