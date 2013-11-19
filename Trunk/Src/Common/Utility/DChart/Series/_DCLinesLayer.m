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
    self.heightUnitInScreen = (self.yRange != nil && self.yRange.length > 0) ? (self.frame.size.height / self.yRange.length) : 0;
    int start = floor(self.graphContext.hRange.location);
    int end = ceil(self.graphContext.hRange.length+self.graphContext.hRange.location);
    start = MAX(0, start);
    
    CGContextSetLineJoin(ctx, kCGLineJoinMiter);
    CGContextSetLineCap(ctx , kCGLineCapRound);
    CGContextSetBlendMode(ctx, kCGBlendModeNormal);
    CGContextSetAllowsAntialiasing(ctx, YES);
    CGContextBeginPath(ctx);
    
    for (DCLineSeries* s in self.series) {
        int loopEnd = s.datas.count-1;
        if (end < loopEnd) loopEnd = end;
        CGContextSetLineWidth(ctx, s.lineWidth);
        CGContextSetStrokeColorWithColor(ctx, s.color.CGColor);
        NSUInteger countOfPoints = 0;
        CGPoint pointsForSeries[loopEnd-start+1];
        for (int j = start; j <= loopEnd; j++) {
            DCDataPoint* point = s.datas[j];
            if (point.value != nil && ![point.value isEqual:[NSNull null]]) {
                pointsForSeries[countOfPoints].x = self.frame.size.width*(j-self.graphContext.hRange.location)/self.graphContext.hRange.length;
                pointsForSeries[countOfPoints].y = self.frame.size.height-self.heightUnitInScreen*point.value.doubleValue;
                countOfPoints++;
            } else {
                CGContextBeginPath(ctx);
                CGContextAddLines(ctx, pointsForSeries, countOfPoints);
                CGContextStrokePath(ctx);
                countOfPoints = 0;
            }
        }
        CGContextAddLines(ctx, pointsForSeries, countOfPoints);
    }
    CGContextStrokePath(ctx);
}

-(BOOL)isValidSeriesForMe:(DCXYSeries*)series {
    return [series isKindOfClass:[DCLineSeries class]];
}


-(void)didYRangeChanged:(DCRange*)oldRange newRange:(DCRange*)newRange {
    if ([DCRange isRange:oldRange equalTo:newRange]) return;
    [super didYRangeChanged:oldRange newRange:newRange];
    [self setNeedsDisplay];
}

-(void)didHRangeChanged:(DCRange *)oldRange newRange:(DCRange *)newRange {
    if ([DCRange isRange:oldRange equalTo:newRange]) return;
    [super didHRangeChanged:oldRange newRange:newRange];
    [self setNeedsDisplay];
}
@end
