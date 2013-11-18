//
//  DCYAxisLabelLayer.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/12/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "_DCYAxisLabelLayer.h"
#import "DCUtility.h"
@interface _DCYAxisLabelLayer()
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CTFontRef fontRef;
@property (nonatomic) CGFloat labelWidth;
@property (nonatomic) CGFloat labelHeight;
@property NSNumberFormatter* numberFormatter;
@end

@implementation _DCYAxisLabelLayer
-(id)init {
    self = [super init];
    if (self) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        self.backgroundColor = [UIColor clearColor].CGColor;
    }
    return self;
}
-(void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    
    CGPoint addLines[2];
    addLines[0].x = self.isMajorAxis ? self.frame.size.width : 0;
    addLines[0].y = 0;
    addLines[1].x = addLines[0].x;
    addLines[1].y = self.frame.size.height;
    
    CGContextSetLineJoin(ctx, kCGLineJoinMiter);
    [DCUtility setLineStyle:ctx style:self.axis.lineStyle];
    CGContextSetBlendMode(ctx, kCGBlendModeNormal);
    CGContextBeginPath(ctx);
    CGContextAddLines(ctx, addLines, 2);
    CGContextSetLineWidth(ctx, self.axis.lineWidth);
    CGContextSetStrokeColorWithColor(ctx, self.axis.lineColor.CGColor);
    CGContextStrokePath(ctx);
}
-(void)removeFromSuperlayer {
    if (self.fontRef) {
        CFRelease(self.fontRef);
    }
    [super removeFromSuperlayer];
}
-(void)didYIntervalChanged:(double)oldInterval newInterval:(double)newInterval yRange:(DCRange*)yRange {
    if (self.fontRef == nil) {
        self.fontSize = self.font.pointSize;
        //self.fontRef = CTFontCreateWithName((CFStringRef)self.font.fontName, self.fontSize,  NULL);
        CGSize size = [DCUtility getSizeOfText:kDCMaxLabel forFont:self.font];
        self.labelWidth = size.width;
        self.labelHeight = size.height;
    }
    if (newInterval <= 0) return;
    for (NSUInteger i = 0; i <= self.graphContext.hGridlineAmount; i++) {
        CATextLayer* text = nil;
        double yVal = i * newInterval;
        if (self.sublayers.count == i) {
            text = [[CATextLayer alloc]init];
            text.font = self.fontRef;
            text.fontSize = self.fontSize;
            text.contentsScale = [[UIScreen mainScreen] scale];
            text.foregroundColor = self.fontColor.CGColor;
            text.alignmentMode = self.isMajorAxis ? kCAAlignmentRight :kCAAlignmentLeft;
            text.frame = CGRectMake(self.isMajorAxis ? 0 : kDCLabelToLine, self.frame.size.height*(1-yVal/yRange.length)-self.labelHeight/2, self.labelWidth, self.labelHeight);
            [self addSublayer:text];
        } else {
            text = self.sublayers[i];
        }
        text.string = [self stringForObjectValue:yVal];
    }
}
- (NSString *)stringForObjectValue:(double)y {
    if(y == 0){
        return @"0";
    }
    NSNumber* number = [NSNumber numberWithDouble:y];
    if(y < 1000){
        return [self formatNumber:number withMinDigits:2 andMaxDigits:2];
    }
    if(y < 1000000){
        return [self formatNumber:number withMinDigits:0 andMaxDigits:0];
    }
    if(y < 100000000){
        NSString *text = [self formatNumber:[NSNumber numberWithDouble:y/1000] withMinDigits:0 andMaxDigits:0];
        return [NSString stringWithFormat:@"%@k", text];
    }
    if(y < 100000000000){
        NSString *text = [self formatNumber:[NSNumber numberWithDouble:y/1000000] withMinDigits:0 andMaxDigits:0];
        return [NSString stringWithFormat:@"%@M", text];
    }
    if(y < 100000000000000){
        NSString *text = [self formatNumber:[NSNumber numberWithDouble:y/1000000000] withMinDigits:0 andMaxDigits:0];
        return [NSString stringWithFormat:@"%@G", text];
    }
    if(y < 100000000000000000){
        NSString *text = [self formatNumber:[NSNumber numberWithDouble:y/1000000000000] withMinDigits:0 andMaxDigits:0];
        return [NSString stringWithFormat:@"%@T", text];
    }
    
    return [self formatNumber:number withMinDigits:0 andMaxDigits:0];
}
-(NSString *)formatNumber:(NSNumber *)number withMinDigits:(int) minDigits andMaxDigits:(int)maxDigits
{
    [self.numberFormatter setMinimumFractionDigits:minDigits];
    [self.numberFormatter setMaximumFractionDigits:maxDigits];
    return [self.numberFormatter stringFromNumber:number];
}
@end
