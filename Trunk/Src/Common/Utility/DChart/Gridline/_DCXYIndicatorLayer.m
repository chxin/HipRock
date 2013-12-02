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
    [super drawInContext:ctx];
    if (self.symbolLineAt && self.symbolLineWidth > 0) {
        CGPoint symbolLinePoints[2];
        symbolLinePoints[0].x = [DCUtility getScreenXIn:self.bounds xVal:self.symbolLineAt.doubleValue+self.pointXOffset hRange:self.graphContext.hRange];
        symbolLinePoints[0].y = 0;
        symbolLinePoints[1].x = symbolLinePoints[0].x;
        symbolLinePoints[1].y = self.frame.size.height;
        
        CGContextSetLineJoin(ctx, kCGLineJoinMiter);
        [DCUtility setLineStyle:ctx style:self.symbolLineStyle];
        CGContextSetBlendMode(ctx, kCGBlendModeNormal);
        CGContextBeginPath(ctx);
        CGContextAddLines(ctx, symbolLinePoints, 2);
        CGContextSetLineWidth(ctx, self.symbolLineWidth);
        CGContextSetStrokeColorWithColor(ctx, self.symbolLineColor.CGColor);
        CGContextStrokePath(ctx);
        
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGContextSetFillColorWithColor(ctx, self.symbolLineColor.CGColor);
        CGPathMoveToPoint(path, NULL, symbolLinePoints[0].x - self.focusSymbolIndicatorSize / 2, 0);
        CGPathAddLineToPoint(path, NULL, symbolLinePoints[0].x + self.focusSymbolIndicatorSize / 2, 0);
        CGPathAddLineToPoint(path, NULL, symbolLinePoints[0].x, self.focusSymbolIndicatorSize / 2);
        CGContextAddPath(ctx, path);
        CGContextDrawPath(ctx, kCGPathFill);
        CGPathRelease(path);
    }
}
@end
