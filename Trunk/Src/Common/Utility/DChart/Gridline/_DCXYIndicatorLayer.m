//
//  _DCXYIndicatorLayer.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/27/13.
//
//

#import "_DCXYIndicatorLayer.h"
#import "DCUtility.h"
#import "REMColor.h"

@implementation _DCXYIndicatorLayer
-(void)drawInContext:(CGContextRef)ctx {
    CGFloat pointXOffset = self.graphContext.pointHorizentalOffset;
//    if (!self.graphContext.pointAlignToTick) pointXOffset = 0.5;
    [super drawInContext:ctx];
    if (self.graphContext.focusX != INT32_MIN) {
        CGPoint symbolLinePoints[2];
        symbolLinePoints[0].x = [DCUtility getScreenXIn:self.bounds xVal:self.graphContext.focusX+pointXOffset hRange:self.graphContext.hRange];
        symbolLinePoints[0].y = 0;
        symbolLinePoints[1].x = symbolLinePoints[0].x;
        symbolLinePoints[1].y = self.frame.size.height;
        
        if (self.graphContext.showIndicatorLineOnFocus) {
            CGContextSetLineJoin(ctx, kCGLineJoinMiter);
            [DCUtility setLineStyle:ctx style:self.view.chartStyle.focusSymbolLineStyle lineWidth:self.view.chartStyle.focusSymbolLineWidth];
            CGContextSetBlendMode(ctx, kCGBlendModeNormal);
            CGContextBeginPath(ctx);
            CGContextAddLines(ctx, symbolLinePoints, 2);
            CGContextSetLineWidth(ctx, self.view.chartStyle.focusSymbolLineWidth);
            CGContextSetStrokeColorWithColor(ctx, self.view.chartStyle.indicatorColor.CGColor);
            CGContextStrokePath(ctx);
        }
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGContextSetFillColorWithColor(ctx, self.view.chartStyle.indicatorColor.CGColor);
        CGPathMoveToPoint(path, NULL, symbolLinePoints[0].x - self.view.chartStyle.focusSymbolIndicatorSize / 2, 0);
        CGPathAddLineToPoint(path, NULL, symbolLinePoints[0].x + self.view.chartStyle.focusSymbolIndicatorSize / 2, 0);
        CGPathAddLineToPoint(path, NULL, symbolLinePoints[0].x, self.view.chartStyle.focusSymbolIndicatorSize / 2);
        CGContextAddPath(ctx, path);
        CGContextDrawPath(ctx, kCGPathFill);
        CGPathRelease(path);
    }
}
@end
