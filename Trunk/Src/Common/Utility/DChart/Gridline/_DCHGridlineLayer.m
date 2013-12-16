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
    self.backgroundColor = [UIColor clearColor].CGColor;
    self.contentsScale = [[UIScreen mainScreen] scale];
    if (self.graphContext && self.graphContext.hGridlineAmount > 0) {
        while (self.sublayers.count > 0) {
            [self.sublayers[0] removeFromSuperlayer];
        }
        CGFloat unitLength = self.frame.size.height / (self.graphContext.hGridlineAmount*kDCReservedSpace);
        for (NSUInteger i = 0; i < self.graphContext.hGridlineAmount; i++) {
            CGPoint addLines[2];
            addLines[0].x = 0;
            addLines[1].x = self.frame.size.width;
            addLines[0].y = unitLength*(i+self.graphContext.hGridlineAmount*(kDCReservedSpace-1));
            addLines[1].y = addLines[0].y;
            
            CGContextSetLineJoin(ctx, kCGLineJoinMiter);
            [DCUtility setLineStyle:ctx style:self.lineStyle];
            CGContextSetBlendMode(ctx, kCGBlendModeNormal);
            CGContextBeginPath(ctx);
            CGContextAddLines(ctx, addLines, 2);
            CGContextSetLineWidth(ctx, self.lineWidth);
            CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
            CGContextStrokePath(ctx);
        }
    }
    [super drawInContext:ctx];
}



@end
