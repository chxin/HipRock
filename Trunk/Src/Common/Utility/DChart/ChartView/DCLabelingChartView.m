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

@property (nonatomic, strong) NSMutableArray* tooltipIconCentrePoints;
@property (nonatomic,strong) UITapGestureRecognizer* tapGsRec;
@property (nonatomic,strong) DCLabelingTooltipView* tooltipView;
@property (nonatomic,strong) NSMutableArray* stageShapeLayers;
@property (nonatomic,strong) NSMutableArray* bezierPaths;

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
        self.stageShapeLayers = [[NSMutableArray alloc]init];
        self.bezierPaths = [[NSMutableArray alloc]init];
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
    int index = INT32_MIN;
    for (int i = 0; i < self.bezierPaths.count; i++) {
        UIBezierPath* p = self.bezierPaths[i];
        if ([p containsPoint:touchPoint]) {
            index = i;
            break;
        }
    }
    if (index >= 0) {
        if (REMIsNilOrNull(self.tooltipView)) {
            self.tooltipView = [[DCLabelingTooltipView alloc]initWithStyle:self.style];
            self.tooltipView.style = self.style;
            [self addSubview:self.tooltipView];
        }
        self.tooltipView.benchmarkText = self.series.benchmarkText;
        self.tooltipView.labelText = [self.series.stages[index] tooltipText];

        [self.tooltipView showAt:touchPoint];
    } else {
        [self hideTooltip];
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
    REMChartStyle* style = self.style;
    NSUInteger stageCount = self.series.stages.count;
    NSUInteger labelCount = self.series.labels.count;
    if (stageCount == 0 || labelCount == 0) return;
    
    CGFloat radius = self.style.labelingRadius;
    
    CGFloat plotWidth = style.labelingStageMaxWidth + style.labelingStageToLineMargin + style.labelingLineWidth + labelCount * (style.labelingLabelToLineMargin*2 + style.labelingLineWidth + style.labelingLabelWidth);
    CGFloat hPadding = (CGRectGetWidth(self.bounds) - plotWidth) / 2;
    
    UIFont* effFont = [UIFont fontWithName:style.labelingFontName size:style.labelingEffectFontSize];
    [self drawText:REMLocalizedString(@"Chart_Labeling_LowEnergyUse") inContext:ctx font:effFont rect:CGRectMake(hPadding, style.labelingStageToBorderMargin-style.labelingStageToStageTextMargin-style.labelingEffectFontSize+style.plotPaddingTop, 9999, 9999) alignment:NSTextAlignmentLeft color:style.labelingStageFontColor];
    [self drawText:REMLocalizedString(@"Chart_Labeling_HighEnergyUse") inContext:ctx font:effFont rect:CGRectMake(hPadding, self.frame.size.height-style.plotPaddingBottom-style.labelingStageToBorderMargin+style.labelingStageToStageTextMargin, 9999, 9999) alignment:NSTextAlignmentLeft color:style.labelingStageFontColor];
    
    
    CGPoint basePoint = CGPointMake(hPadding, style.plotPaddingTop + style.labelingStageToBorderMargin);
    CGFloat stageWidthStep = (style.labelingStageMaxWidth - style.labelingStageMinWidth) / (stageCount - 1);
    CGFloat stageHeight = [self getStageHeight:stageCount];
    CGFloat stageVMargin = (self.bounds.size.height - style.plotPaddingTop - style.plotPaddingBottom - style.labelingStageToBorderMargin * 2 - stageHeight * stageCount) / (stageCount - 1);
    for (int i = 0; i < stageCount; i++) {
        CGFloat baseX = basePoint.x;
        CGFloat baseY = basePoint.y;
        CGFloat theWidth = style.labelingStageMinWidth + i * stageWidthStep;
        
        CAShapeLayer* shape = self.stageShapeLayers[i];
        shape.fillColor = [self.series.stages[i] color].CGColor;
        UIBezierPath* aPath = [UIBezierPath bezierPath];
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
        [self.bezierPaths addObject:aPath];
        shape.path = aPath.CGPath;
        shape.hidden = YES;
        
        CGContextSetFillColorWithColor(ctx, [self.series.stages[i] color].CGColor);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, baseX, baseY+radius);
        CGPathAddQuadCurveToPoint(path, NULL, baseX, baseY, baseX+radius, baseY);
        CGPathAddLineToPoint(path, NULL, baseX + theWidth - stageHeight / 2-radius, baseY);
        CGPathAddQuadCurveToPoint(path, NULL, baseX + theWidth - stageHeight / 2, baseY, baseX + theWidth - stageHeight / 2+radius, baseY+radius);
        CGPathAddLineToPoint(path, NULL, baseX + theWidth - radius, baseY + stageHeight / 2 - radius);
        CGPathAddQuadCurveToPoint(path, NULL, baseX + theWidth, baseY + stageHeight / 2, baseX + theWidth - radius, baseY + stageHeight / 2 + radius);
        CGPathAddLineToPoint(path, NULL, baseX + theWidth - stageHeight / 2 + radius, baseY + stageHeight - radius);
        CGPathAddQuadCurveToPoint(path, NULL, baseX + theWidth - stageHeight / 2, baseY + stageHeight, baseX + theWidth - stageHeight / 2 - radius, baseY + stageHeight);
        CGPathAddLineToPoint(path, NULL, baseX+radius, baseY + stageHeight);
        CGPathAddQuadCurveToPoint(path, NULL, baseX, baseY+stageHeight, baseX, baseY+stageHeight-radius);
        CGPathCloseSubpath(path);
        CGContextAddPath(ctx, path);
        CGContextDrawPath(ctx, kCGPathFill);
        CGPathRelease(path);

        
        basePoint.y = basePoint.y + stageHeight + stageVMargin;
        
        
        UIFont* stageTextFont = [UIFont fontWithName:style.labelingFontName size:style.labelingStageFontSize];
        NSString* stageText = [self.series.stages[i] stageText];
        CGSize stageSize = [DCUtility getSizeOfText:stageText forFont:stageTextFont];
        [self drawText:stageText inContext:ctx font:stageTextFont rect:CGRectMake(baseX+theWidth-style.labelingStageFontRightMargin-stageSize.width, baseY+(stageHeight-stageSize.height)/2+style.labelingStageFontTopMargin, stageSize.width, stageSize.height) alignment:NSTextAlignmentLeft color:[UIColor whiteColor]];
    }
    [self drawLineAt:hPadding+style.labelingStageMaxWidth+style.labelingStageToLineMargin+style.labelingLineWidth/2 inContext:ctx];

    UIFont* labelFont = [UIFont fontWithName:style.labelingFontName size:style.labelingLabelFontSize];
    UIFont* labelValueFont = [UIFont fontWithName:style.labelingFontName size:style.labelingLabelValueFontSize];
    UIFont* labelTagNameFont = [UIFont fontWithName:style.labelingFontName size:style.labelingLabelTagNameFontSize];
    CGFloat labelHeight = style.labelingLabelHeight;
    CGFloat labelWidth = style.labelingLabelWidth;
    for (int i = 0; i < labelCount; i++) {
        DCLabelingLabel* label = self.series.labels[i];
        
        // 分割线
        [self drawLineAt:hPadding+style.labelingStageMaxWidth+style.labelingStageToLineMargin+style.labelingLineWidth/2+(style.labelingLabelWidth+style.labelingLabelToLineMargin*2+style.labelingLineWidth)*(i+1) inContext:ctx];
        
        CGFloat baseX = hPadding+style.labelingStageMaxWidth+style.labelingStageToLineMargin+style.labelingLineWidth+(style.labelingLabelWidth+style.labelingLabelToLineMargin*2+style.labelingLineWidth)*i+style.labelingLabelToLineMargin;
        CGFloat baseY = style.plotPaddingTop+style.labelingStageToBorderMargin+stageHeight*((double)label.stage+0.5)+stageVMargin*(double)label.stage-labelHeight/2;
        CGFloat labelRightBound = baseX + labelWidth;
        // Label色块
        CGContextSetFillColorWithColor(ctx, label.color.CGColor);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, baseX+radius, baseY + labelHeight / 2+radius);
        CGPathAddQuadCurveToPoint(path, NULL, baseX, baseY + labelHeight / 2, baseX  + radius, baseY + labelHeight / 2-radius);
        CGPathAddLineToPoint(path, NULL, baseX + labelHeight / 2-radius, baseY+radius);
        CGPathAddQuadCurveToPoint(path, NULL, baseX + labelHeight / 2, baseY, baseX + labelHeight / 2 +radius, baseY);
        CGPathAddLineToPoint(path, NULL, labelRightBound-radius, baseY);
        CGPathAddQuadCurveToPoint(path, NULL, labelRightBound, baseY, labelRightBound, baseY+radius);
        CGPathAddLineToPoint(path, NULL, labelRightBound, baseY + labelHeight - radius);
        CGPathAddQuadCurveToPoint(path, NULL, labelRightBound, baseY + labelHeight, labelRightBound-radius, baseY + labelHeight);
        CGPathAddLineToPoint(path, NULL, baseX + labelHeight / 2 + radius, baseY + labelHeight);
        CGPathAddQuadCurveToPoint(path, NULL, baseX + labelHeight / 2, baseY + labelHeight, baseX + labelHeight / 2-radius, baseY + labelHeight-radius);
        CGPathCloseSubpath(path);
        CGContextAddPath(ctx, path);
        CGContextDrawPath(ctx, kCGPathFill);
        CGPathRelease(path);
        
        CGSize stageTextSize = [DCUtility getSizeOfText:label.stageText forFont:labelFont];
        [self drawText:label.name inContext:ctx font:labelTagNameFont rect:CGRectMake(baseX, style.plotPaddingTop+style.labelingLabelTagNameTopMargin, style.labelingLabelWidth, style.labelingLabelTagNameFontSize) alignment:NSTextAlignmentCenter color:style.labelingLabelValueFontColor];
        [self drawText:label.stageText inContext:ctx font:labelFont rect:CGRectMake(baseX+style.labelingLabelWidth-stageTextSize.width-style.labelingLabelFontRightMargin, baseY+style.labelingLabelFontTopMargin, stageTextSize.width, stageTextSize.height) alignment:NSTextAlignmentRight color:[UIColor whiteColor]];
        [self drawText:label.labelText inContext:ctx font:labelValueFont rect:CGRectMake(baseX, baseY+labelHeight+style.labelingLabelValueFontTopMarginToLabel, style.labelingLabelWidth, style.labelingLabelValueFontSize) alignment:NSTextAlignmentRight color:style.labelingLabelValueFontColor];
    }
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
    
    NSUInteger stageCount = self.series.stages.count;
    for (int i = 0; i < stageCount; i++) {
        CAShapeLayer* shape = [[CAShapeLayer alloc]init];
        shape.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:shape];
        [self.stageShapeLayers addObject:shape];
    }
    
    
    [self updateGestures];
    [self setNeedsDisplay];
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
