//
//  DCColumnSeries.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/13/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "DCColumnSeries.h"

@implementation DCColumnSeries
-(void)drawToLayer:(CALayer *)layer inContext:(CGContextRef)ctx graphContext:(DCContext*)graphContext {
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

-(void)addBarForX:(NSInteger)x graphContext:(DCContext*)graphContext {
//    CGFloat centerX = (x - graphContext.hRange.location) * self.frame.size.width / self.graphContext.hRange.length;
//    CALayer* text = [[CATextLayer alloc]init];
//    NSString* labelText = [self textForX:x];
//    [text setString:labelText];
//    text.font = CTFontCreateWithName((CFStringRef)self.font.fontName,
//                                     self.font.pointSize,
//                                     NULL);
//    text.fontSize = self.font.pointSize;
//    text.contentsScale = [[UIScreen mainScreen] scale];
//    text.foregroundColor = self.fontColor.CGColor;
//    text.alignmentMode = kCAAlignmentCenter;
//    
//    CGSize size = [DCUtility getSizeOfText:labelText forFont:self.font];
//    text.frame = CGRectMake(centerX-size.width/2,self.frame.size.height/2-size.height/2, size.width,size.height);
//    [self addSublayer:text];
//    [self.xToLayerDic setObject:text forKey:@(x)];
}

@end
