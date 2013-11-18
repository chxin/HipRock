//
//  DCLineSeries.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/8/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "DCLineSeries.h"

@implementation DCLineSeries

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
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
}

@end
