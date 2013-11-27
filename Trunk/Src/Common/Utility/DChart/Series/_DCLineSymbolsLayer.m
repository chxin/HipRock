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

@interface _DCLineSymbolsLayer()
@property (nonatomic, strong) NSArray* pointsToDraw;
@property CGSize plotSize;  // 因为对于接近0的点，symbol需要覆盖轴线，所以self.frame比实际绘图区域要大。这个PlotSize代表实际绘图区域
@end

@implementation _DCLineSymbolsLayer
-(void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    if (REMIsNilOrNull(self.pointsToDraw)) return;
    
    for (NSArray* seriesPoints in self.pointsToDraw) {
        if (seriesPoints.count==0) continue;
        DCDataPoint* point = seriesPoints[0][@"dcpoint"];
        if (![point.series isKindOfClass:[DCLineSeries class]]) continue;
        DCLineSeries* series = (DCLineSeries*)point.series;
        if (series.symbolType == DCLineSymbolTypeNone || series.symbolSize <= 0 || series.color == nil) continue;
        CGFloat halfSize = series.symbolSize / 2;
        CGFloat r, g, b, a;
        [series.color getRed:&r green:&g blue:&b alpha:&a];
        NSUInteger pointIndex = 0;
        for (NSDictionary* pointDic in seriesPoints) {
            CGPoint centerPoint;
            CGFloat symbolAlpha = [pointDic[@"symbolAlpha"] doubleValue];
            
            CGContextSetRGBFillColor(ctx, r, g, b, symbolAlpha);
            [((NSValue*)pointDic[@"location"]) getValue:&centerPoint];
            CGMutablePathRef path = CGPathCreateMutable();
            if (series.symbolType == DCLineSymbolTypeRectangle) {
                CGPathMoveToPoint(path, NULL, centerPoint.x-halfSize, centerPoint.y-halfSize);
                CGPathAddLineToPoint(path, NULL, centerPoint.x+halfSize, centerPoint.y-halfSize);
                CGPathAddLineToPoint(path, NULL, centerPoint.x+halfSize, centerPoint.y+halfSize);
                CGPathAddLineToPoint(path, NULL, centerPoint.x-halfSize, centerPoint.y+halfSize);
                CGContextAddPath(ctx, path);
            } else if (series.symbolType == DCLineSymbolTypeRound) {
                CGContextAddArc(ctx, centerPoint.x, centerPoint.y, halfSize, 0 , M_PI*2, 0);
            } else if (series.symbolType == DCLineSymbolTypeDiamond) {
                CGPathMoveToPoint(path, NULL, centerPoint.x, centerPoint.y-halfSize);
                CGPathAddLineToPoint(path, NULL, centerPoint.x-halfSize, centerPoint.y);
                CGPathAddLineToPoint(path, NULL, centerPoint.x, centerPoint.y+halfSize);
                CGPathAddLineToPoint(path, NULL, centerPoint.x+halfSize, centerPoint.y);
                CGContextAddPath(ctx, path);
            } else if (series.symbolType == DCLineSymbolTypeTriangle) {
                CGPathMoveToPoint(path, NULL, centerPoint.x, centerPoint.y-halfSize);
                CGPathAddLineToPoint(path, NULL, centerPoint.x-halfSize, centerPoint.y+halfSize);
                CGPathAddLineToPoint(path, NULL, centerPoint.x+halfSize, centerPoint.y+halfSize);
                CGContextAddPath(ctx, path);
            } else if (series.symbolType == DCLineSymbolTypeBackTriangle) {
                CGPathMoveToPoint(path, NULL, centerPoint.x, centerPoint.y+halfSize);
                CGPathAddLineToPoint(path, NULL, centerPoint.x-halfSize, centerPoint.y-halfSize);
                CGPathAddLineToPoint(path, NULL, centerPoint.x+halfSize, centerPoint.y-halfSize);
                CGContextAddPath(ctx, path);
            }
            CGContextDrawPath(ctx, kCGPathFill);
            CGPathRelease(path);
            pointIndex++;
        }
    }
    self.pointsToDraw = nil;
}

-(void)drawSymbolsForPoints:(NSArray*)points inSize:(CGSize)plotSize {
    self.pointsToDraw = points;
    self.plotSize = plotSize;
    [self setNeedsDisplay];
}
@end
