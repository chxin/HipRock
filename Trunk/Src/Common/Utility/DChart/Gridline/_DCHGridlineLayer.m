//
//  DCHGridlineLayer.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/12/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "_DCHGridlineLayer.h"

@implementation _DCHGridlineLayer

-(void)drawInContext:(CGContextRef)ctx {
    CGContextSetLineJoin(ctx, kCGLineJoinMiter);
    CGContextSetBlendMode(ctx, kCGBlendModeNormal);
    if(self.view.chartStyle.yLineWidth > 0 && self.view.yAxisList.count > 0) {
        [DCUtility setLineStyle:ctx style:DCLineTypeDefault lineWidth:self.view.chartStyle.yLineWidth];
        CGContextSetLineWidth(ctx, self.view.chartStyle.yLineWidth);
        CGContextBeginPath(ctx);
        CGContextSetStrokeColorWithColor(ctx, self.view.chartStyle.yLineColor.CGColor);
        
        for (DCAxis* yAxis in self.view.yAxisList) {
            CGPoint addLines[2];
            addLines[0] = yAxis.startPoint;
            addLines[1] = yAxis.endPoint;
            CGContextAddLines(ctx, addLines, 2);
        }
        CGContextStrokePath(ctx);
    }
    if (self.view.chartStyle.xLineWidth > 0 && self.view.xAxis) {
        [DCUtility setLineStyle:ctx style:DCLineTypeDefault lineWidth:self.view.chartStyle.xLineWidth];
        CGContextSetLineWidth(ctx, self.view.chartStyle.xLineWidth);
        CGContextBeginPath(ctx);
        CGContextSetStrokeColorWithColor(ctx, self.view.chartStyle.xLineColor.CGColor);
        
        CGPoint addLines[2];
        addLines[0] = self.view.xAxis.startPoint;
        addLines[1] = self.view.xAxis.endPoint;
        CGContextAddLines(ctx, addLines, 2);
        CGContextStrokePath(ctx);
    }
    if (self.graphContext && self.graphContext.hGridlineAmount > 0) {
        while (self.sublayers.count > 0) {
            [self.sublayers[0] removeFromSuperlayer];
        }
        CGFloat unitLength = self.graphContext.plotRect.size.height / (self.graphContext.hGridlineAmount*kDCReservedSpace);
        for (NSUInteger i = 0; i < self.graphContext.hGridlineAmount; i++) {
            CGPoint addLines[2];
            addLines[0].x = self.graphContext.plotRect.origin.x;
            addLines[1].x = self.graphContext.plotRect.size.width + addLines[0].x;
            addLines[0].y = unitLength*(i+self.graphContext.hGridlineAmount*(kDCReservedSpace-1)) + self.graphContext.plotRect.origin.y;
            addLines[1].y = addLines[0].y;
            
            CGContextSetLineJoin(ctx, kCGLineJoinMiter);
            [DCUtility setLineStyle:ctx style:self.view.chartStyle.yGridlineStyle lineWidth:self.view.chartStyle.yGridlineWidth];
            CGContextSetBlendMode(ctx, kCGBlendModeNormal);
            CGContextBeginPath(ctx);
            CGContextAddLines(ctx, addLines, 2);
            CGContextSetLineWidth(ctx, self.view.chartStyle.yGridlineWidth);
            CGContextSetStrokeColorWithColor(ctx, self.view.chartStyle.yGridlineColor.CGColor);
            CGContextStrokePath(ctx);
        }
    }
    [super drawInContext:ctx];
}



@end
