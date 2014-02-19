//
//  _DCLineSymbolsLayer.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/21/13.
//
//

#import "_DCLineSymbolsLayer.h"
#import "DCDataPoint.h"
#import "DCLineSeries.h"
#import "DCUtility.h"
#import "REMColor.h"

@implementation _DCLineSymbolsLayer
-(id)initWithContext:(DCContext*)context view:(DCXYChartView*)view series:(NSArray*)series {
    self = [super initWithContext:context view:view];
    if (self) {
        _series = series;
        for (DCXYSeries* s in series) {
            s.layer = self;
            _enableGrowAnimation = YES;
        }
    }
    return self;
}

-(NSUInteger)getVisableSeriesCount {
    NSUInteger count = 0;
    for (DCLineSeries* s in self.series) {
        if (!s.hidden) count++;
    }
    return count;
}

-(void)setNeedsDisplay {
    if (self.enableGrowAnimation) {
        _enableGrowAnimation = NO;
        CALayer* superLayer = self.superlayer;
        CGPoint orig = superLayer.frame.origin;
        CGRect newBounds = superLayer.bounds;
        CGRect oldBounds = CGRectMake(newBounds.origin.x, newBounds.origin.y, 0, newBounds.size.height);
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        animation.fromValue = [NSValue valueWithCGRect:oldBounds];
        animation.toValue = [NSValue valueWithCGRect:newBounds];
        animation.duration = kDCAnimationDuration;
        superLayer.anchorPoint = CGPointZero;
        superLayer.position = orig;
        [superLayer addAnimation:animation forKey:@"bounds"];
    }
    [super setNeedsDisplay];
}

-(CGFloat)getHeightOfPoint:(DCDataPoint*)point heightUnit:(CGFloat)heightUnit {
    double y = 0;
    if (point.value != nil && ![point.value isEqual:[NSNull null]]) {
        y = point.value.doubleValue;
    }
    return heightUnit * y;
}

-(CGPoint)getPointBy:(int)x y:(double)y heightUnit:(CGFloat)heightUnit {
    CGFloat xOffset = self.graphContext.pointHorizentalOffset;
//    if (!self.graphContext.pointAlignToTick) xOffset = 0.5;
    CGPoint point;
    point.x = self.graphContext.plotRect.size.width*(x+xOffset-self.graphContext.hRange.location)/self.graphContext.hRange.length;
    point.y = self.graphContext.plotRect.size.height-heightUnit*y;
    return point;
}

-(void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    
    int start = floor(self.graphContext.hRange.location);
    int end = ceil(self.graphContext.hRange.length+self.graphContext.hRange.location);
    if (start < 0) start = 0;
    CGFloat pointXOffset = self.graphContext.pointHorizentalOffset;
//    if (!self.graphContext.pointAlignToTick) pointXOffset = 0.5;
    
    CGRect plotRect = self.graphContext.plotRect;
    
    
    CGContextSetLineJoin(ctx, kCGLineJoinMiter);
    CGContextSetLineCap(ctx , kCGLineCapRound);
    CGContextSetBlendMode(ctx, kCGBlendModeNormal);
    CGContextSetAllowsAntialiasing(ctx, YES);
    CGPoint linePoints[end-start+2];
    for (DCLineSeries* s in self.series) {
        if (s.hidden) continue;
        if (start >= s.datas.count) continue;
        
        CGFloat r, g, b, a;
        [s.color getRed:&r green:&g blue:&b alpha:&a];
        CGFloat lineAlpha = (self.graphContext.focusX == INT32_MIN) ? a: kDCUnfocusPointSymbolAlph*a;
        
        int loopEnd = s.datas.count-1;
        if (end < loopEnd) loopEnd = end;
        
        CGContextSetLineWidth(ctx, s.lineWidth);
        CGContextSetStrokeColorWithColor(ctx, [REMColor makeTransparent:lineAlpha withColor:s.color].CGColor);
        
        NSUInteger pointCount = 0;
        // 从RangeStart向前再搜索一个非空点，并绘制曲线
        for (int j = start-1; j >= 0; j--) {
            DCDataPoint* point = s.datas[j];
            if (point.pointType == DCDataPointTypeEmpty) {
                continue;
            } else if (point.pointType == DCDataPointTypeBreak) {
                break;
            } else {
                linePoints[pointCount] = [self getPointBy:j y:point.value.doubleValue heightUnit:s.coordinate.heightUnitInScreen];
                pointCount++;
                break;
            }
        }
        
        // 绘制图形的主要部分
        for (int j = start; j <= loopEnd; j++) {
            DCDataPoint* point = s.datas[j];
            if (point.pointType == DCDataPointTypeEmpty) {
                continue;
            } else if (point.pointType == DCDataPointTypeNormal) {
                linePoints[pointCount] = [self getPointBy:j y:point.value.doubleValue heightUnit:s.coordinate.heightUnitInScreen];
                pointCount++;
            } else {
                CGContextAddLines(ctx, linePoints, pointCount);
                CGContextStrokePath(ctx);
                pointCount = 0;
            }
        }
        // 从RangeEnd向前后搜索一个非空点，并绘制曲线
        for (int j = loopEnd+1; j < s.datas.count; j++) {
            DCDataPoint* point = s.datas[j];
            if (point.pointType == DCDataPointTypeEmpty) {
                continue;
            } else if (point.pointType == DCDataPointTypeBreak) {
                break;
            } else {
                linePoints[pointCount] = [self getPointBy:j y:point.value.doubleValue heightUnit:s.coordinate.heightUnitInScreen];
                pointCount++;
                break;
            }
        }
        if (pointCount != 0) {
            CGContextAddLines(ctx, linePoints, pointCount);
            CGContextStrokePath(ctx);
        }
    }
    
    // 绘制Symbol
    for (DCLineSeries* s in self.series) {
        if (s.hidden) continue;
        CGFloat r, g, b, a;
        [s.color getRed:&r green:&g blue:&b alpha:&a];
        for (int j = start; j<=end; j++) {
            if (s.symbolType == DCLineSymbolTypeNone || s.symbolSize == 0) continue;
            if (j >= s.datas.count) continue;
            DCDataPoint* key = s.datas[j];
            CGRect toFrame = CGRectMake(plotRect.size.width*(j+pointXOffset-self.graphContext.hRange.location)/self.graphContext.hRange.length-s.symbolSize/2, plotRect.size.height-[self getHeightOfPoint:key heightUnit:s.coordinate.heightUnitInScreen]-s.symbolSize/2, s.symbolSize, s.symbolSize);
            BOOL isRectVisable = [DCUtility isFrame:toFrame visableIn:self.bounds] && (key.value != nil) && ![key.value isEqual:[NSNull null]];
            if (isRectVisable) {
                CGPoint centerPoint = CGPointMake(toFrame.origin.x+toFrame.size.width/2, toFrame.origin.y+toFrame.size.height/2);
                CGFloat symbolAlpha = 0;
                CGFloat halfSize = s.symbolSize / 2;
                if (j == self.graphContext.focusX || self.graphContext.focusX == INT32_MIN)
                    symbolAlpha = kDCSymbolAlpha*a;
                else
                    symbolAlpha = kDCUnfocusPointSymbolAlph*a;
                
                CGContextSetRGBFillColor(ctx, r, g, b, symbolAlpha);
                CGMutablePathRef path = CGPathCreateMutable();
                
                if (s.symbolType == DCLineSymbolTypeRectangle) {
                    CGPathMoveToPoint(path, NULL, centerPoint.x-halfSize, centerPoint.y-halfSize);
                    CGPathAddLineToPoint(path, NULL, centerPoint.x+halfSize, centerPoint.y-halfSize);
                    CGPathAddLineToPoint(path, NULL, centerPoint.x+halfSize, centerPoint.y+halfSize);
                    CGPathAddLineToPoint(path, NULL, centerPoint.x-halfSize, centerPoint.y+halfSize);
                    CGContextAddPath(ctx, path);
                } else if (s.symbolType == DCLineSymbolTypeRound) {
                    CGContextAddArc(ctx, centerPoint.x, centerPoint.y, halfSize, 0 , M_PI*2, 0);
                } else if (s.symbolType == DCLineSymbolTypeDiamond) {
                    CGPathMoveToPoint(path, NULL, centerPoint.x, centerPoint.y-halfSize);
                    CGPathAddLineToPoint(path, NULL, centerPoint.x-halfSize, centerPoint.y);
                    CGPathAddLineToPoint(path, NULL, centerPoint.x, centerPoint.y+halfSize);
                    CGPathAddLineToPoint(path, NULL, centerPoint.x+halfSize, centerPoint.y);
                    CGContextAddPath(ctx, path);
                } else if (s.symbolType == DCLineSymbolTypeTriangle) {
                    CGPathMoveToPoint(path, NULL, centerPoint.x, centerPoint.y-halfSize);
                    CGPathAddLineToPoint(path, NULL, centerPoint.x-halfSize, centerPoint.y+halfSize);
                    CGPathAddLineToPoint(path, NULL, centerPoint.x+halfSize, centerPoint.y+halfSize);
                    CGContextAddPath(ctx, path);
                } else if (s.symbolType == DCLineSymbolTypeBackTriangle) {
                    CGPathMoveToPoint(path, NULL, centerPoint.x, centerPoint.y+halfSize);
                    CGPathAddLineToPoint(path, NULL, centerPoint.x-halfSize, centerPoint.y-halfSize);
                    CGPathAddLineToPoint(path, NULL, centerPoint.x+halfSize, centerPoint.y-halfSize);
                    CGContextAddPath(ctx, path);
                }
                
                CGContextDrawPath(ctx, kCGPathFill);
                CGPathRelease(path);
            }
        }
    }
}
@end
