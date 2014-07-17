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
#import "REMColor.h"

@interface DCLabelingChartView()

@property (nonatomic, strong) NSMutableArray* tooltipIconCentrePoints;
@property (nonatomic,strong) UITapGestureRecognizer* tapGsRec;
@property (nonatomic,strong) DCLabelingTooltipView* tooltipView;
//@property (nonatomic,strong) NSMutableArray* stageShapeLayers;
@property (nonatomic,strong) NSMutableArray* stageBezierPaths;
@property (nonatomic,strong) NSMutableArray* labelBezierPaths;
@property (nonatomic,strong) NSMutableArray* labelBezierPathsCenterX;
@property (nonatomic,strong) CAShapeLayer* indicatorLayer;
@property (nonatomic,assign) int focusLabelIndex;
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
//        self.stageShapeLayers = [[NSMutableArray alloc]init];
        self.stageBezierPaths = [[NSMutableArray alloc]init];
        self.labelBezierPaths = [[NSMutableArray alloc]init];
        self.indicatorLayer = [[CAShapeLayer alloc]init];
        [self.layer addSublayer:self.indicatorLayer];
        self.indicatorLayer.hidden = YES;
        self.labelBezierPathsCenterX = [[NSMutableArray alloc]init];
        self.focusLabelIndex = INT32_MIN;
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
    CGPoint touchPoint = [gesture locationInView:self];
    BOOL touchStage = NO;
    BOOL touchLevel = NO;
    int stageIndex = INT32_MIN;
    int levelIndex = INT32_MIN;
    for (int i = 0; i < self.stageBezierPaths.count; i++) {
        UIBezierPath* p = self.stageBezierPaths[i];
        if ([p containsPoint:touchPoint]) {
            stageIndex = i;
            touchStage = YES;
            break;
        }
    }
    if (!touchStage) {
        for (int  i = 0; i < self.labelBezierPaths.count; i++) {
            UIBezierPath* p = self.labelBezierPaths[i];
            if ([p containsPoint:touchPoint]) {
                levelIndex = i;
                touchLevel = YES;
                break;
            }
        }
    }
    if (touchStage) {
        if (REMIsNilOrNull(self.tooltipView)) {
            self.tooltipView = [[DCLabelingTooltipView alloc]initWithStyle:self.style];
            self.tooltipView.style = self.style;
            [self addSubview:self.tooltipView];
        }
        self.tooltipView.benchmarkText = self.series.benchmarkText;
        self.tooltipView.labelText = [self.series.stages[stageIndex] tooltipText];

        [self.tooltipView showAt:touchPoint];
    } else {
        [self hideStageTooltip];
    }
    if (touchLevel) {
        CGFloat centerX = [self.labelBezierPathsCenterX[levelIndex] doubleValue];
        CGRect indicatorFrame = CGRectMake(centerX - self.style.focusSymbolIndicatorSize / 2, self.indicatorLayer.frame.origin.y, self.indicatorLayer.frame.size.width, self.indicatorLayer.frame.size.height);
        self.indicatorLayer.frame = indicatorFrame;
        if (self.indicatorLayer.hidden) {
            [DCUtility runFunction:^(void){
                self.indicatorLayer.hidden = NO;
            }withDelay:0.3];
        }
        if (!REMIsNilOrNull(self.delegate) && [self.delegate respondsToSelector:@selector(focusOn:)]) {
            if (levelIndex != self.focusLabelIndex) {
                self.focusLabelIndex = levelIndex;
                [self.delegate focusOn:levelIndex == INT32_MIN ? nil : self.series.labels[levelIndex]];
                [self setNeedsDisplay];
            }
        }
    }
}

-(void)unfocusLabel {
    self.focusLabelIndex = INT32_MIN;
    self.indicatorLayer.hidden = YES;
    [self setNeedsDisplay];
}

-(void)hideStageTooltip {
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
    DCChartStyle* style = self.style;
    NSUInteger stageCount = self.series.stages.count;
    NSUInteger labelCount = self.series.labels.count;
    if (stageCount == 0 || labelCount == 0) return;
    
    CGFloat radius = self.style.labelingRadius;
    
    CGFloat plotWidth = style.labelingStageMaxWidth + style.labelingStageToLineMargin + style.labelingLineWidth + labelCount * (style.labelingLabelToLineMargin*2 + style.labelingLineWidth + style.labelingLabelWidth)+style.labelingArrowLineWidth+style.labelingArrowVMargin*2;
    CGFloat hPadding = (CGRectGetWidth(self.bounds) - plotWidth) / 2;
    
    UIFont* effFont = [UIFont systemFontOfSize:style.labelingEffectFontSize];//[UIFont fontWithName:style.labelingFontName size:style.labelingEffectFontSize];
    [self drawText:REMIPadLocalizedString(@"Chart_Labeling_LowEnergyUse") inContext:ctx font:effFont rect:CGRectMake(hPadding, style.labelingStageToBorderMargin-style.labelingStageToStageTextMargin-style.labelingEffectFontSize+style.plotPaddingTop, 9999, 9999) alignment:NSTextAlignmentLeft color:style.labelingStageFontColor];
    [self drawText:REMIPadLocalizedString(@"Chart_Labeling_HighEnergyUse") inContext:ctx font:effFont rect:CGRectMake(hPadding, self.frame.size.height-style.plotPaddingBottom-style.labelingStageToBorderMargin+style.labelingStageToStageTextMargin, 9999, 9999) alignment:NSTextAlignmentLeft color:style.labelingStageFontColor];
    
    CGFloat arrowSpaceWidth =  style.labelingArrowLineWidth+style.labelingArrowVMargin*2;
    CGPoint basePoint = CGPointMake(hPadding+arrowSpaceWidth, style.plotPaddingTop + style.labelingStageToBorderMargin);
    CGFloat stageWidthStep = (style.labelingStageMaxWidth - style.labelingStageMinWidth) / (stageCount - 1);
    CGFloat stageHeight = [self getStageHeight:stageCount];
    CGFloat stageVMargin = (self.bounds.size.height - style.plotPaddingTop - style.plotPaddingBottom - style.labelingStageToBorderMargin * 2 - stageHeight * stageCount) / (stageCount - 1);
    
    // 绘制箭头
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetFillColorWithColor(ctx, self.style.labelingArrowColor.CGColor);
    CGPathMoveToPoint(path, NULL, hPadding+style.labelingArrowLineWidth+style.labelingArrowVMargin, style.plotPaddingTop + style.labelingStageToBorderMargin);
    CGPathAddLineToPoint(path, NULL, hPadding+style.labelingArrowLineWidth+style.labelingArrowVMargin, style.plotPaddingTop + style.labelingStageToBorderMargin+stageHeight*stageCount+stageVMargin*(stageCount-1));
    CGPathAddLineToPoint(path, NULL, hPadding+style.labelingArrowVMargin, style.plotPaddingTop + style.labelingStageToBorderMargin+stageHeight*stageCount+stageVMargin*(stageCount-1));
    CGPathAddLineToPoint(path, NULL, hPadding+style.labelingArrowVMargin, style.plotPaddingTop + style.labelingStageToBorderMargin+style.labelingArrowHeight);
    CGPathAddLineToPoint(path, NULL, hPadding+style.labelingArrowVMargin-style.labelingArrowWidth, style.plotPaddingTop + style.labelingStageToBorderMargin+style.labelingArrowHeight);
    CGContextAddPath(ctx, path);
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathFill);
    CGPathRelease(path);
    
    for (int i = 0; i < stageCount; i++) {
        CGFloat baseX = basePoint.x;
        CGFloat baseY = basePoint.y;
        CGFloat theWidth = style.labelingStageMinWidth + i * stageWidthStep;
        
        UIBezierPath* aPath = nil;
        if (self.stageBezierPaths.count == i) {
            aPath = [UIBezierPath bezierPath];
            [aPath moveToPoint:CGPointMake(baseX, baseY+radius)];
            [aPath addQuadCurveToPoint:CGPointMake(baseX+radius, baseY) controlPoint:CGPointMake(baseX, baseY)];
            [aPath addLineToPoint:CGPointMake(baseX + theWidth - stageHeight / 2-radius, baseY)];
            [aPath addQuadCurveToPoint:CGPointMake(baseX + theWidth - stageHeight / 2+radius, baseY+radius) controlPoint:CGPointMake(baseX + theWidth - stageHeight / 2, baseY)];
            [aPath addLineToPoint:CGPointMake(baseX + theWidth - radius, baseY + stageHeight / 2 - radius)];
            [aPath addQuadCurveToPoint:CGPointMake(baseX + theWidth - radius, baseY + stageHeight / 2 + radius) controlPoint:CGPointMake(baseX + theWidth, baseY + stageHeight / 2)];
            [aPath addLineToPoint:CGPointMake(baseX + theWidth - stageHeight / 2 + radius, baseY + stageHeight - radius)];
            [aPath addQuadCurveToPoint:CGPointMake(baseX + theWidth - stageHeight / 2 - radius, baseY + stageHeight) controlPoint:CGPointMake(baseX + theWidth - stageHeight / 2, baseY + stageHeight)];
            [aPath addLineToPoint:CGPointMake(baseX+radius, baseY + stageHeight)];
            [aPath addQuadCurveToPoint:CGPointMake(baseX, baseY+stageHeight-radius) controlPoint:CGPointMake(baseX, baseY+stageHeight)];
            [aPath closePath];
            [self.stageBezierPaths addObject:aPath];
        } else {
            aPath = self.stageBezierPaths[i];
        }
        
        CGContextSetFillColorWithColor(ctx, [((DCLabelingStage *)self.series.stages[i]) color].CGColor);
        CGContextAddPath(ctx, aPath.CGPath);
        CGContextDrawPath(ctx, kCGPathFill);

        
        basePoint.y = basePoint.y + stageHeight + stageVMargin;
        
        
        UIFont* stageTextFont = [UIFont systemFontOfSize:style.labelingStageFontSize];//[UIFont fontWithName:style.labelingFontName size:style.labelingStageFontSize];
        NSString* stageText = [self.series.stages[i] stageText];
        CGSize stageSize = [DCUtility getSizeOfText:stageText forFont:stageTextFont];
        [self drawText:stageText inContext:ctx font:stageTextFont rect:CGRectMake(baseX+theWidth-style.labelingStageFontRightMargin-stageSize.width, baseY+(stageHeight-stageSize.height)/2+style.labelingStageFontTopMargin, stageSize.width, stageSize.height) alignment:NSTextAlignmentLeft color:[UIColor whiteColor]];
    }
    [self drawLineAt:hPadding+arrowSpaceWidth+style.labelingStageMaxWidth+style.labelingStageToLineMargin+style.labelingLineWidth/2 inContext:ctx];

    UIFont* labelFont = [UIFont systemFontOfSize:style.labelingLabelFontSize];//[UIFont fontWithName:style.labelingFontName size:style.labelingLabelFontSize];
    UIFont* labelTagNameFont = [UIFont systemFontOfSize:style.labelingLabelTagNameFontSize];//[UIFont fontWithName:style.labelingFontName size:style.labelingLabelTagNameFontSize];
    CGFloat labelHeight = style.labelingLabelHeight;
    CGFloat labelWidth = style.labelingLabelWidth;
    for (int i = 0; i < labelCount; i++) {
        DCLabelingLabel* label = self.series.labels[i];
        
        // 分割线
        [self drawLineAt:hPadding+arrowSpaceWidth+style.labelingStageMaxWidth+style.labelingStageToLineMargin+style.labelingLineWidth/2+(style.labelingLabelWidth+style.labelingLabelToLineMargin*2+style.labelingLineWidth)*(i+1) inContext:ctx];
        
        CGFloat baseX = hPadding+arrowSpaceWidth+style.labelingStageMaxWidth+style.labelingStageToLineMargin+style.labelingLineWidth+(style.labelingLabelWidth+style.labelingLabelToLineMargin*2+style.labelingLineWidth)*i+style.labelingLabelToLineMargin;
        CGFloat baseY = style.plotPaddingTop+style.labelingStageToBorderMargin+stageHeight*((double)label.stage+0.5)+stageVMargin*(double)label.stage-labelHeight/2;
        CGFloat labelRightBound = baseX + labelWidth;
        UIBezierPath* aPath = nil;
        if (self.labelBezierPaths.count == i) {
            aPath = [UIBezierPath bezierPath];
            
            [aPath moveToPoint:CGPointMake(baseX+radius, baseY + labelHeight / 2+radius)];
            [aPath addQuadCurveToPoint:CGPointMake(baseX  + radius, baseY + labelHeight / 2-radius) controlPoint:CGPointMake(baseX, baseY + labelHeight / 2)];
            [aPath addLineToPoint:CGPointMake(baseX + labelHeight / 2-radius, baseY+radius)];
            [aPath addQuadCurveToPoint:CGPointMake(baseX + labelHeight / 2 +radius, baseY) controlPoint:CGPointMake(baseX + labelHeight / 2, baseY)];
            [aPath addLineToPoint:CGPointMake(labelRightBound-radius, baseY)];
            [aPath addQuadCurveToPoint:CGPointMake(labelRightBound, baseY+radius) controlPoint:CGPointMake(labelRightBound, baseY)];
            [aPath addLineToPoint:CGPointMake(labelRightBound, baseY + labelHeight - radius)];
            [aPath addQuadCurveToPoint:CGPointMake(labelRightBound-radius, baseY + labelHeight) controlPoint:CGPointMake(labelRightBound, baseY + labelHeight)];
            [aPath addLineToPoint:CGPointMake(baseX + labelHeight / 2 + radius, baseY + labelHeight)];
            [aPath addQuadCurveToPoint:CGPointMake(baseX + labelHeight / 2-radius, baseY + labelHeight-radius) controlPoint:CGPointMake(baseX + labelHeight / 2, baseY + labelHeight)];
            [aPath closePath];
            [self.labelBezierPaths addObject:aPath];
            [self.labelBezierPathsCenterX addObject:@(baseX + labelWidth / 2)];
        } else {
            aPath = self.labelBezierPaths[i];
        }
        // Label色块
        if (self.focusLabelIndex == INT32_MIN || i == self.focusLabelIndex) {
            CGContextSetFillColorWithColor(ctx, label.color.CGColor);
        } else {
            CGContextSetFillColorWithColor(ctx, [REMColor makeTransparent:kDCFocusPointAlpha withColor:label.color].CGColor);
        }
        CGContextAddPath(ctx, aPath.CGPath);
        CGContextDrawPath(ctx, kCGPathFill);
        
        CGSize stageTextSize = [DCUtility getSizeOfText:label.stageText forFont:labelFont];
        [self drawText:label.name inContext:ctx font:labelTagNameFont rect:CGRectMake(baseX, style.plotPaddingTop+style.labelingLabelTagNameTopMargin, style.labelingLabelWidth, style.labelingLabelTagNameFontSize) alignment:NSTextAlignmentCenter color:style.labelingLabelValueFontColor];
        [self drawText:label.stageText inContext:ctx font:labelFont rect:CGRectMake(baseX+style.labelingLabelWidth-stageTextSize.width-style.labelingLabelFontRightMargin, baseY+style.labelingLabelFontTopMargin, stageTextSize.width, stageTextSize.height) alignment:NSTextAlignmentRight color:[UIColor whiteColor]];
    }
    
    
    UIBezierPath* indicatorPath = [UIBezierPath bezierPath];
    self.indicatorLayer.fillColor = self.style.indicatorColor.CGColor;
    [indicatorPath moveToPoint:CGPointMake(0, 0)];
    [indicatorPath addLineToPoint:CGPointMake(self.style.focusSymbolIndicatorSize, 0)];
    [indicatorPath addLineToPoint:CGPointMake(self.style.focusSymbolIndicatorSize/2, self.style.focusSymbolIndicatorSize/2)];
    [indicatorPath closePath];
    self.indicatorLayer.path = indicatorPath.CGPath;
}

-(void)drawLineAt:(CGFloat)x inContext:(CGContextRef)ctx {
    CGPoint addLines[2];
    addLines[0].x = x + self.style.labelingLineWidth / 2;
    addLines[0].y = self.style.plotPaddingTop+self.style.labelingStageToBorderMargin;
    addLines[1].x = addLines[0].x;
    addLines[1].y = CGRectGetHeight(self.bounds)-(self.style.plotPaddingBottom+self.style.labelingStageToBorderMargin);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextSetLineJoin(ctx, kCGLineJoinMiter);
    CGContextSetBlendMode(ctx, kCGBlendModeNormal);
    CGContextBeginPath(ctx);
    CGContextAddLines(ctx, addLines, 2);
    CGContextSetLineWidth(ctx, self.style.labelingLineWidth);
    CGContextSetStrokeColorWithColor(ctx, self.style.labelingLineColor.CGColor);
    CGContextStrokePath(ctx);
}

-(void)drawText:(NSString*)text inContext:(CGContextRef)ctx font:(UIFont*)font rect:(CGRect)rect alignment:(NSTextAlignment)alignment color:(UIColor*)color {
    UIGraphicsPushContext(ctx);
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    [text drawInRect:rect withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment: alignment];
    UIGraphicsPopContext();
}

-(void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    CGFloat toAlpha = self.alpha;
    self.alpha = 0;
    [self updateGestures];
    [self setNeedsDisplay];
    [UIView animateWithDuration:0.4 animations:^(){
        self.alpha = toAlpha;
    } completion:^(BOOL completed){
        if (!(REMIsNilOrNull(self.delegate)) && [self.delegate respondsToSelector:@selector(beginAnimationDone)]) {
            [self.delegate beginAnimationDone];
        }
    }];
}

-(CGFloat)getStageHeight:(uint)stageCount {
    if (stageCount <= 3) return self.style.labelingStageHeightFor3Levels;
    else if (stageCount <= 4) return self.style.labelingStageHeightFor4Levels;
    else if (stageCount <= 5) return self.style.labelingStageHeightFor5Levels;
    else if (stageCount <= 6) return self.style.labelingStageHeightFor6Levels;
    else if (stageCount <= 7) return self.style.labelingStageHeightFor7Levels;
    else return self.style.labelingStageHeightFor8Levels;
}
@end
