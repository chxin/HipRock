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
#import "DCLabelingTooltipView.h"

@interface DCLabelingChartView()
@property (nonatomic, assign) CGFloat labelHeight;
@property (nonatomic, assign) CGFloat stageHeight;
@property (nonatomic, assign) CGFloat stageVerticalMargin;

@property (nonatomic, assign) CGFloat labelWidth;
@property (nonatomic, assign) CGFloat labelHorizentalMargin;
@property (nonatomic, assign) CGFloat stageWidth;
@property (nonatomic, assign) CGFloat stageHorizentalMargin;
@property (nonatomic, assign) CGFloat tooltipIconRadius;

@property (nonatomic, strong) NSMutableArray* tooltipIconCentrePoints;


@property (nonatomic,strong) UITapGestureRecognizer* tapGsRec;

@property (nonatomic,strong) DCLabelingTooltipView* tooltipView;

@end

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
        self.tooltipIconCentrePoints = [[NSMutableArray alloc]init];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)updateGestures {
    if (self.userInteractionEnabled) {
        if (REMIsNilOrNull(self.tapGsRec)) {
            self.tapGsRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
            self.tapGsRec.cancelsTouchesInView = NO;
            [self addGestureRecognizer:self.tapGsRec];
        }
    } else {
        if (!REMIsNilOrNull(self.tapGsRec)) {
            [self removeGestureRecognizer:self.tapGsRec];
            self.tapGsRec = nil;
        }
    }
}

-(void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    if(self.userInteractionEnabled == userInteractionEnabled) return;
    [super setUserInteractionEnabled:userInteractionEnabled];
    [self updateGestures];
}


-(void)viewTapped:(UITapGestureRecognizer *)gesture {
    // Detect whether tap on icon.
    BOOL isTapOnIcon = NO;
    NSUInteger tapIconIndex = 0;
    CGPoint touchPoint = [gesture locationInView:self];
    for (; tapIconIndex < self.tooltipIconCentrePoints.count; tapIconIndex++) {
        CGPoint iconCenter;
        [self.tooltipIconCentrePoints[tapIconIndex] getValue:&iconCenter];
        CGFloat distance = sqrt(pow(touchPoint.x-iconCenter.x, 2) + pow(touchPoint.y-iconCenter.y, 2));
        if (distance <= self.tooltipIconRadius) {
            isTapOnIcon = YES;
            break;
        }
    }
    
    if (isTapOnIcon) {
        [self showTooltipForIndex:tapIconIndex];
    } else {
        [self hideTooltip];
    }
}

-(void)showTooltipForIndex:(NSUInteger)index {
    CGFloat tooltipHeight = self.stageHeight * 0.8;
    if (REMIsNilOrNull(self.tooltipView)) {
        self.tooltipView = [[DCLabelingTooltipView alloc]init];
        self.tooltipView.hidden = YES;
        self.tooltipView.fontName = self.fontName;
        self.tooltipView.alpha = 0;
        self.tooltipView.height = tooltipHeight;
        [self addSubview:self.tooltipView];
    }
    
    self.tooltipView.stageText = [self.series.stages[index] stageText];
    self.tooltipView.labelText = [self.series.stages[index] tooltipText];
    CGPoint iconCenter;
    [self.tooltipIconCentrePoints[index] getValue:&iconCenter];
    CGRect toFrame = CGRectMake(iconCenter.x + self.tooltipIconRadius * 1.2, iconCenter.y - tooltipHeight / 2, [self.tooltipView getWidth], tooltipHeight);
    
    if (self.tooltipView.hidden) {
        self.tooltipView.hidden = NO;
        self.tooltipView.frame = toFrame;
        [UIView animateWithDuration:0.2 animations:^(void){
            self.tooltipView.alpha = 1;
            self.tooltipView.color = [self.series.stages[index] color];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^(void){
            self.tooltipView.alpha = 1;
            self.tooltipView.frame = toFrame;
            self.tooltipView.color = [self.series.stages[index] color];
        }];
    }
}

-(void)hideTooltip {
    if (!REMIsNilOrNull(self.tooltipView)) {
        [UIView animateWithDuration:0.2 animations:^(void){
            self.tooltipView.alpha = 0;
        } completion:^(BOOL completed){
            if (completed) self.tooltipView.hidden = YES;
        }];
    }
}

-(void)drawRect:(CGRect)rect {
    // Nothing to do.
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    [super drawLayer:layer inContext:ctx];
    [self.tooltipIconCentrePoints removeAllObjects];
    NSUInteger stageCount = self.series.stages.count;
    NSUInteger labelCount = self.series.labels.count;
    if (stageCount == 0 || labelCount == 0) return;
    
    CGPoint basePoint = CGPointMake(self.paddingLeft, self.paddingTop + (self.labelHeight - self.stageHeight) / 2);
    CGFloat stageWidthStep = self.stageWidth / 2 / (stageCount - 1);
    CGFloat stageFontSize = self.stageHeight*0.55;
    CGSize tooltipTextSize = CGSizeMake(self.tooltipIconRadius * 0.18, self.tooltipIconRadius * 0.85);
//    CGFloat tooltipIconFontSize = tooltipIconRadius*1.4;
//    UIFont* tooltipIconFont = [UIFont fontWithName:self.fontName size:tooltipIconFontSize];
    UIFont* stageTextFont = [UIFont fontWithName:self.fontName size:stageFontSize];
//    NSString* tooltipIconText =@"i";
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
        
        // 绘制tooltipIcon
        if (self.tooltipArcLineWidth > 0) {
            UIGraphicsPushContext(ctx);
            CGContextSetLineWidth(ctx, self.tooltipArcLineWidth);
            CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
            CGPoint tooltipCenter = CGPointMake(baseX+ self.stageHeight / 2, baseY + self.stageHeight / 2);
            [self.tooltipIconCentrePoints addObject:[NSValue valueWithCGPoint:tooltipCenter]];
            CGContextAddArc(ctx, tooltipCenter.x, tooltipCenter.y, self.tooltipIconRadius, 0, M_PI*2, 0);
            CGContextDrawPath(ctx, kCGPathStroke);
            CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
            
            CGContextAddArc(ctx, tooltipCenter.x, tooltipCenter.y - tooltipTextSize.height / 2 + tooltipTextSize.width / 2, tooltipTextSize.width / 2, 0, M_PI*2, 0);
            CGContextDrawPath(ctx, kCGPathFill);
//            [tooltipIconText drawInRect:CGRectMake(tooltipCenter.x-tooltipIconRadius, tooltipCenter.y-tooltipIconFontSize/2, tooltipIconRadius*2, tooltipIconRadius*2) withFont:tooltipIconFont lineBreakMode:NSLineBreakByClipping alignment: NSTextAlignmentCenter];
            
            CGPoint addLines[2];
            addLines[0].x = tooltipCenter.x;
            addLines[0].y = tooltipCenter.y + tooltipTextSize.width * 1.75 - tooltipTextSize.height / 2;
            addLines[1].x = addLines[0].x;
            addLines[1].y = tooltipCenter.y + tooltipTextSize.height / 2;
            CGContextSetLineCap(ctx, kCGLineCapRound);
            CGContextSetBlendMode(ctx, kCGBlendModeNormal);
            CGContextBeginPath(ctx);
            CGContextAddLines(ctx, addLines, 2);
            CGContextSetLineWidth(ctx, tooltipTextSize.width * 0.9);
            CGContextStrokePath(ctx);
            [[self.series.stages[i] stageText] drawInRect:CGRectMake(baseX, tooltipCenter.y-stageFontSize/2+self.tooltipArcLineWidth, theWidth - self.stageHeight / 2, stageFontSize) withFont:stageTextFont lineBreakMode:NSLineBreakByClipping alignment: NSTextAlignmentRight];
            UIGraphicsPopContext();
        }
    }
    
    NSUInteger labelFontSize = self.labelHeight * 0.45;
    NSUInteger labelNameFontSize = labelFontSize / 2;
    UIFont* labelFont = [UIFont fontWithName:self.fontName size:labelFontSize];
    UIFont* labelNameFont = [UIFont fontWithName:self.fontName size:labelNameFontSize];
    for (int i = 0; i < labelCount; i++) {
        DCLabelingLabel* label = self.series.labels[i];
        basePoint = CGPointMake(self.paddingLeft + self.stageWidth + self.stageHorizentalMargin + i * (self.labelWidth + self.labelHorizentalMargin * 2 + self.lineWidth), self.paddingTop);
        
        // 分割线
        CGPoint addLines[2];
        addLines[0].x = basePoint.x + self.lineWidth / 2;
        addLines[0].y = basePoint.y;
        addLines[1].x = addLines[0].x;
        addLines[1].y = CGRectGetHeight(self.bounds)-self.paddingBottom;
        CGContextSetLineCap(ctx, kCGLineCapButt);
        CGContextSetLineJoin(ctx, kCGLineJoinMiter);
        [DCUtility setLineStyle:ctx style:DCLineTypeDashed lineWidth:self.lineWidth];
        CGContextSetBlendMode(ctx, kCGBlendModeNormal);
        CGContextBeginPath(ctx);
        CGContextAddLines(ctx, addLines, 2);
        CGContextSetLineWidth(ctx, self.lineWidth);
        CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
        CGContextStrokePath(ctx);
        
        CGFloat baseX = basePoint.x + self.lineWidth + self.labelHorizentalMargin;
        CGFloat baseY = basePoint.y + label.stage * (self.stageHeight + self.stageVerticalMargin);
        CGFloat labelRightBound = baseX + self.labelWidth;
        // Label色块
        CGContextSetFillColorWithColor(ctx, label.color.CGColor);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, baseX, baseY + self.labelHeight / 2);
        CGPathAddLineToPoint(path, NULL, baseX + self.labelHeight / 2, baseY);
        CGPathAddLineToPoint(path, NULL, labelRightBound, baseY);
        CGPathAddLineToPoint(path, NULL, labelRightBound, baseY + self.labelHeight);
        CGPathAddLineToPoint(path, NULL, baseX + self.labelHeight / 2, baseY + self.labelHeight);
        CGPathCloseSubpath(path);
        CGContextAddPath(ctx, path);
        CGContextDrawPath(ctx, kCGPathFill);
        CGPathRelease(path);
        
        // Label文本
        UIGraphicsPushContext(ctx);
        CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
        CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
        CGFloat labelMargin = (self.labelHeight / 2 - labelFontSize) / 2;
        [label.stageText drawInRect:CGRectMake(baseX, baseY + labelMargin, labelRightBound - baseX - labelMargin, labelFontSize) withFont:labelFont lineBreakMode:NSLineBreakByClipping alignment: NSTextAlignmentRight];
        CGFloat labelNameMargin = (self.labelHeight / 4 - labelNameFontSize) / 2;
        [label.name drawInRect:CGRectMake(baseX, baseY + self.labelHeight / 2 + labelNameMargin, labelRightBound - baseX - labelNameMargin, labelNameFontSize) withFont:labelNameFont lineBreakMode:NSLineBreakByCharWrapping alignment: NSTextAlignmentRight];
        [label.labelText drawInRect:CGRectMake(baseX, baseY + self.labelHeight * 0.75 + labelNameMargin, labelRightBound - baseX - labelNameMargin, labelNameFontSize) withFont:labelNameFont lineBreakMode:NSLineBreakByCharWrapping alignment: NSTextAlignmentRight];
        UIGraphicsPopContext();
    }
}

-(void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    [self updateGestures];
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
    
    self.tooltipIconRadius = self.stageHeight * 0.275;
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
