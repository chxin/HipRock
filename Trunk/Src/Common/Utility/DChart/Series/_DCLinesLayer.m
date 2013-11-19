//
//  _DCLineLayer.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/19/13.
//
//

#import "_DCLinesLayer.h"
@interface _DCLinesLayer()

@end

@implementation _DCLinesLayer
-(void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    self.columnHeightUnitInScreen = (self.yRange != nil && self.yRange.length > 0) ? (self.frame.size.height / self.yRange.length) : 0;
    int start = floor(self.graphContext.hRange.location);
    int end = ceil(self.graphContext.hRange.length+self.graphContext.hRange.location);
    start = MAX(0, start);
    
    CGContextSetLineJoin(ctx, kCGLineJoinMiter);
    CGContextSetLineCap(ctx , kCGLineCapRound);
    CGContextSetBlendMode(ctx, kCGBlendModeNormal);
    

    for (DCLineSeries* s in self.series) {
        int loopEnd = s.datas.count-1;
        if (end < loopEnd) loopEnd = end;
        int numbersOfPoint = loopEnd-start+1;
        CGPoint pointsForSeries[numbersOfPoint];
        for (int j = start; j <= loopEnd; j++) {
            DCDataPoint* p = s.datas[j];
            pointsForSeries[j-start].x = self.frame.size.width*(j-self.graphContext.hRange.location)/self.graphContext.hRange.length;
            pointsForSeries[j-start].y = self.frame.size.height-[self getHeightOfPoint:p];
        }
        CGContextSetLineWidth(ctx, s.lineWidth);
        CGContextSetStrokeColorWithColor(ctx, s.color.CGColor);
        CGContextBeginPath(ctx);
        CGContextAddLines(ctx, pointsForSeries, numbersOfPoint);
        CGContextStrokePath(ctx);
    }
}
//    if (cachedPoints == nil || cachedPoints.count == 0) return;
//
//    CGSize sizeOfLayer = layer.frame.size;
//
//    DCRange* coordinateXRange = self.xAxis.range;
//
//    CGPoint points[cachedPoints.count];
//    
//    for (NSUInteger index = 0; index < cachedPoints.count; index++) {
//        DCDataPoint* point = cachedPoints[index];
//        
//        points[index].x = sizeOfLayer.width * (index + cacheRange.location - coordinateXRange.location) / coordinateXRange.length;
//        points[index].y = sizeOfLayer.height * (1 - point.value.doubleValue / self.yAxis.range.length);
//    }
//    
//    CGContextSetLineJoin(ctx, kCGLineJoinMiter);
//    CGContextSetLineCap(ctx , kCGLineCapRound);
//    CGContextSetBlendMode(ctx, kCGBlendModeNormal);
//    CGContextBeginPath(ctx);
//    CGContextAddLines(ctx, points, cachedPoints.count);
//    CGContextSetLineWidth(ctx, 1);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
//    CGContextClosePath(ctx);
//    CGContextStrokePath(ctx);
//    
//    layer.backgroundColor = [UIColor redColor].CGColor;

-(CGFloat)getHeightOfPoint:(DCDataPoint*)point {
    double y = 0;
    if (point.value != nil && ![point.value isEqual:[NSNull null]]) {
        y = point.value.doubleValue;
    }
    return self.columnHeightUnitInScreen * y;
}

-(BOOL)isValidSeriesForMe:(DCXYSeries*)series {
    return [series isKindOfClass:[DCLineSeries class]];
}
@end
