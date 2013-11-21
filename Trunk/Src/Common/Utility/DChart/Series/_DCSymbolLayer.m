//
//  _DCSymbolLayer.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/20/13.
//
//

#import "_DCSymbolLayer.h"
@interface _DCSymbolLayer()
@property (nonatomic, assign) CGFloat halfSize;
@property (nonatomic, assign) CGFloat symbolR;
@property (nonatomic, assign) CGFloat symbolG;
@property (nonatomic, assign) CGFloat symbolB;
@property (nonatomic, assign) CGFloat symbolA;
@end

@implementation _DCSymbolLayer
-(id)initWithContext:(DCContext *)context type:(DCLineSymbolType)type size:(CGFloat)size color:(UIColor*)color {
    self = [super initWithContext:context];
    if (self) {
        _symbolSize = size;
        _symbolType = type;
        _symbolColor = color;
        _halfSize = size / 2;
        
        CGFloat r, g, b, a;
        if ([self.symbolColor getRed:&r green:&g blue:&b alpha:&a]) {
            self.symbolR = r;
            self.symbolG = g;
            self.symbolB = b;
            self.symbolA = a;
        }
            
    }
    return self;
}

-(void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    if (self.symbolType == DCLineSymbolTypeNone) return;
    if (self.symbolType == DCLineSymbolTypeRectangle) {
        self.backgroundColor = self.symbolColor.CGColor;
        return;
    }
    
    CGContextSetRGBFillColor(ctx, self.symbolR, self.symbolG, self.symbolB, self.symbolA);
    if (self.symbolType == DCLineSymbolTypeRound) {
        CGContextAddArc(ctx, self.halfSize, self.halfSize, self.halfSize, 0 , M_PI*2, 0);
        CGContextDrawPath(ctx, kCGPathFill);
    } else if (self.symbolType == DCLineSymbolTypeDiamond) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, self.halfSize, 0);
        CGPathAddLineToPoint(path, NULL, 0, self.halfSize);
        CGPathAddLineToPoint(path, NULL, self.halfSize, self.symbolSize);
        CGPathAddLineToPoint(path, NULL, self.symbolSize, self.halfSize);
        CGContextAddPath(ctx, path);
        CGContextDrawPath(ctx, kCGPathFill);
    } else if (self.symbolType == DCLineSymbolTypeTriangle) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, self.halfSize, 0);
        CGPathAddLineToPoint(path, NULL, 0, self.symbolSize);
        CGPathAddLineToPoint(path, NULL, self.symbolSize, self.symbolSize);
        CGContextAddPath(ctx, path);
        CGContextDrawPath(ctx, kCGPathFill);
    } else if (self.symbolType == DCLineSymbolTypeBackTriangle) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL, self.symbolSize, 0);
        CGPathAddLineToPoint(path, NULL, self.halfSize, self.symbolSize);
        CGContextAddPath(ctx, path);
        CGContextDrawPath(ctx, kCGPathFill);
    }
}
@end
