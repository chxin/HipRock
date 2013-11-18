//
//  DCXAxisLabelLayer.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/12/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "_DCXAxisLabelLayer.h"
#import "DCUtility.h"
@interface _DCXAxisLabelLayer()
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CTFontRef fontRef;
@end


@implementation _DCXAxisLabelLayer

-(id)init {
    self = [super init];
    if (self) {
        self.masksToBounds = YES;
        self.backgroundColor = [UIColor clearColor].CGColor;
    }
    return self;
}
-(void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    int start = floor(self.graphContext.hRange.location);
    int end = ceil(self.graphContext.hRange.length+self.graphContext.hRange.location);
    
    for (int i = start; i <= end; i++) {
        [self addLabelForX:i];
    }
    
    CGPoint addLines[2];
    addLines[0].x = 0;
    addLines[0].y = 0;
    addLines[1].x = self.frame.size.width;
    addLines[1].y = 0;
    
    CGContextSetLineJoin(ctx, kCGLineJoinMiter);
    [DCUtility setLineStyle:ctx style:self.axis.lineStyle];
    CGContextSetBlendMode(ctx, kCGBlendModeNormal);
    CGContextBeginPath(ctx);
    CGContextAddLines(ctx, addLines, 2);
    CGContextSetLineWidth(ctx, self.axis.lineWidth);
    CGContextSetStrokeColorWithColor(ctx, self.axis.lineColor.CGColor);
    CGContextStrokePath(ctx);
}

-(void)viewTouchesMoveFrom:(CGPoint)from to:(CGPoint)to {
    int start = floor(self.graphContext.hRange.location);
    int end = ceil(self.graphContext.hRange.length+self.graphContext.hRange.location);
    
    BOOL caTransationState = CATransaction.disableActions;
    [CATransaction setDisableActions:YES];
    for (NSNumber* key in self.xToLayerDic.allKeys) {
        CATextLayer* text = self.xToLayerDic[key];
        CGRect toFrame = CGRectMake(text.frame.origin.x+to.x-from.x, text.frame.origin.y, text.frame.size.width, text.frame.size.height);
        if ([self isVisableInMyFrame:toFrame]) {
            text.frame = toFrame;
        } else {
            [self.xToLayerDic removeObjectForKey:key];
            [text removeFromSuperlayer];
        }
    }
    [CATransaction setDisableActions:caTransationState];
    
    for (int i = start; i <= end; i++) {
        if (self.xToLayerDic[@(i)] == nil) [self addLabelForX:i];
    }
}

-(NSString*)textForX:(NSInteger)x {
    return [NSString stringWithFormat:@"%li", (long)x];
}

-(void)addLabelForX:(NSInteger)x {
    if (self.fontRef == nil) {
        self.fontSize = self.font.pointSize;
        //self.fontRef = CTFontCreateWithName((CFStringRef)self.font.fontName, self.fontSize, NULL);
    }
    CGFloat centerX = (x - self.graphContext.hRange.location) * self.frame.size.width / self.graphContext.hRange.length;
    
    CATextLayer* text = (CATextLayer*)[self popLayerFromTrashBox];
    if (!text) {
        text = [[CATextLayer alloc]init];
        text.font = self.fontRef;
        text.fontSize = self.fontSize;
        text.contentsScale = [[UIScreen mainScreen] scale];
        text.foregroundColor = self.fontColor.CGColor;
        text.alignmentMode = kCAAlignmentCenter;
        [self addSublayer:text];
    }
    NSString* labelText = [self textForX:x];
    [text setString:labelText];
    CGSize size = [DCUtility getSizeOfText:labelText forFont:self.font];
    text.frame = CGRectMake(centerX-size.width/2,self.frame.size.height/2-size.height/2, size.width,size.height);
    [self.xToLayerDic setObject:text forKey:@(x)];
}

-(void)removeFromSuperlayer {
    if (self.fontRef) {
        CFRelease(self.fontRef);
    }
    [super removeFromSuperlayer];
}
@end
