//
//  _DCVGridlineLayer.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/23/13.
//
//

#import "_DCVGridlineLayer.h"
#import "DCUtility.h"

@implementation _DCVGridlineLayer

-(void)drawInContext:(CGContextRef)ctx {
    if (self.graphContext && [DCUtility getScreenXIn:self.bounds xVal:1 hRange:self.graphContext.hRange] - [DCUtility getScreenXIn:self.bounds xVal:0 hRange:self.graphContext.hRange] >= 20) {
        int start = ceil(self.graphContext.hRange.location);
        int end = floor(self.graphContext.hRange.end);
        CGContextSetLineJoin(ctx, kCGLineJoinMiter);
        CGContextSetLineWidth(ctx, self.view.vGridlineWidth);
        CGContextSetBlendMode(ctx, kCGBlendModeNormal);
        CGContextSetStrokeColorWithColor(ctx, self.view.vGridlineColor.CGColor);
        CGContextBeginPath(ctx);
        for (int i = start; i <= end; i++) {
            CGPoint addLines[2];
            addLines[0].x = [DCUtility getScreenXIn:self.bounds xVal:i hRange:self.graphContext.hRange];
            addLines[1].x = addLines[0].x;
            addLines[0].y = 0;
            addLines[1].y = CGRectGetHeight(self.bounds);
            
            [DCUtility setLineStyle:ctx style:self.view.vGridlineStyle lineWidth:self.view.vGridlineWidth];
            CGContextAddLines(ctx, addLines, 2);
        }
        CGContextStrokePath(ctx);
    }
    [super drawInContext:ctx];
}

-(void)didHRangeChanged:(DCRange *)oldRange newRange:(DCRange *)newRange {
    if ([DCRange isRange:oldRange equalTo:newRange]) return;
    if (oldRange.length == newRange.length) {
        [self setNeedsDisplay];
    } else {
        [self setNeedsDisplay];
    }
}
@end
