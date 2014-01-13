//
//  DCYAxisLabelLayer.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/12/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "_DCYAxisLabelLayer.h"
#import "DCUtility.h"
#import "REMColor.h"
#import "DCXYChartBackgroundBand.h"

@interface _DCYAxisLabelLayer()
@property NSNumberFormatter* numberFormatter;
@property (nonatomic, assign) CGFloat interval;
@property (nonatomic, weak) DCRange* yRange;
@property (nonatomic) CGRect myFrame;
@property (nonatomic) NSMutableArray* textFrames;
@property (nonatomic, assign) CGRect axisTitleFrame;
@property (nonatomic, strong) UIFont* axisTitleFont;
@property (nonatomic, strong) NSMutableDictionary* textDictionary;
@end

@implementation _DCYAxisLabelLayer
-(id)initWithContext:(DCContext *)context {
    self = [super initWithContext:context];
    if (self) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        self.masksToBounds = NO;
        self.backgroundColor = [UIColor clearColor].CGColor;
        _interval = 0;
        _textFrames = [[NSMutableArray alloc]init];
        _textDictionary = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    if (self.hidden) return;
    if(self.axis.lineWidth > 0) {
        CGPoint addLines[2];
        addLines[0].x = self.isMajorAxis ? self.myFrame.size.width : 0;
        addLines[0].y = 0;
        addLines[1].x = addLines[0].x;
        addLines[1].y = self.myFrame.size.height;
        
        CGContextSetLineJoin(ctx, kCGLineJoinMiter);
        [DCUtility setLineStyle:ctx style:self.axis.lineStyle lineWidth:self.axis.lineWidth];
        CGContextSetBlendMode(ctx, kCGBlendModeNormal);
        CGContextBeginPath(ctx);
        CGContextAddLines(ctx, addLines, 2);
        CGContextSetLineWidth(ctx, self.axis.lineWidth);
        CGContextSetStrokeColorWithColor(ctx, self.axis.lineColor.CGColor);
        CGContextStrokePath(ctx);
    }
    if (!REMIsNilOrNull(self.axis.backgroundBands)) {
        DCRange* yRange = self.yRange;
        for(DCXYChartBackgroundBand* band in self.axis.backgroundBands) {
            CGFloat yTop = [DCUtility getScreenYIn:self.graphContext.plotRect yVal:band.range.end vRange:yRange];
            CGFloat yBottom = [DCUtility getScreenYIn:self.graphContext.plotRect yVal:band.range.location vRange:yRange];
            
            CGMutablePathRef path = CGPathCreateMutable();
            CGContextSetFillColorWithColor(ctx, band.color.CGColor);
            CGFloat xLeft = self.graphContext.plotRect.origin.x;
            CGFloat xRight = xLeft + CGRectGetWidth(self.graphContext.plotRect);
            CGPathMoveToPoint(path, NULL, xLeft, yTop);
            CGPathAddLineToPoint(path, NULL, xLeft, yBottom);
            CGPathAddLineToPoint(path, NULL, xRight, yBottom);
            CGPathAddLineToPoint(path, NULL, xRight, yTop);
            CGPathCloseSubpath(path);
            CGContextAddPath(ctx, path);
            CGContextDrawPath(ctx, kCGPathFill);
            CGPathRelease(path);
        }
    }
    if (!self.graphContext.useTextLayer) {
        UIGraphicsPushContext(ctx);
        CGContextSetStrokeColorWithColor(ctx, self.fontColor.CGColor);
        CGContextSetFillColorWithColor(ctx, self.fontColor.CGColor);
        CGRect theLastLabelRect;
        for (NSUInteger i = 0; i <= self.graphContext.hGridlineAmount; i++) {
            double yVal = i * self.interval;
            NSString* label = [self stringForObjectValue:yVal];
            [self.textFrames[i] getValue:&theLastLabelRect];
            [label drawInRect:theLastLabelRect withFont:self.font lineBreakMode:NSLineBreakByClipping alignment:self.isMajorAxis ? NSTextAlignmentRight : NSTextAlignmentLeft];
        }
        if (!REMIsNilOrNull(self.axis.axisTitle) && self.axis.axisTitle.length > 0) {
            [self.axis.axisTitle drawInRect:self.axisTitleFrame withFont:self.axisTitleFont lineBreakMode:NSLineBreakByClipping alignment:self.isMajorAxis ? NSTextAlignmentRight : NSTextAlignmentLeft];
        }
        UIGraphicsPopContext();
    }
}

-(void)setFrame:(CGRect)frame {
    self.myFrame = frame;
    [super setFrame:self.superlayer.bounds];
    [self updateTextFrames];
}

-(void)setFont:(UIFont *)font {
    _font = font;
    [self updateTextFrames];
}

-(void)setIsMajorAxis:(BOOL)isMajorAxis {
    _isMajorAxis = isMajorAxis;
    [self updateTextFrames];
}

-(void)updateTextFrames {
    if (self.font == Nil || self.yRange == nil) return;
    [self.textFrames removeAllObjects];
    
    CGSize labelMaxSize = [DCUtility getSizeOfText:kDCMaxLabel forFont:self.font];
    CGRect theLastLabelRect;
    for (NSUInteger i = 0; i <= self.graphContext.hGridlineAmount; i++) {
        double yVal = i * self.interval;
        theLastLabelRect = CGRectMake(
                                      self.isMajorAxis ? self.myFrame.origin.x : self.myFrame.origin.x+self.axis.lineWidth+self.axis.labelToLine,
                                      self.myFrame.size.height*(1-yVal/self.yRange.length)-labelMaxSize.height/2+self.myFrame.origin.y,
                                      labelMaxSize.width,
                                      labelMaxSize.height);
        [self.textFrames addObject:[NSValue valueWithCGRect:theLastLabelRect]];
    }
    if (!REMIsNilOrNull(self.axis.axisTitle) && self.axis.axisTitle.length > 0) {
        UIFont* titleFont = self.font;
        CGRect fontLabelRect = CGRectMake(theLastLabelRect.origin.x, theLastLabelRect.origin.y - theLastLabelRect.size.height - self.axisTitleToTopLabel, theLastLabelRect.size.width, theLastLabelRect.size.height);
        while ([DCUtility getSizeOfText:self.axis.axisTitle forFont:titleFont].width > fontLabelRect.size.width) {
            titleFont = [UIFont fontWithName:titleFont.fontName size:titleFont.pointSize-1];
        }
        self.axisTitleFont = titleFont;
        self.axisTitleFrame = fontLabelRect;
    }
}

-(void)updateTexts {
    if (self.graphContext.useTextLayer) {
        CGRect theLastLabelRect;
        CTFontRef fRef = CTFontCreateWithName((__bridge CFStringRef)self.font.fontName,
                                                self.font.pointSize,
                                                NULL);
        for (NSUInteger i = 0; i <= self.graphContext.hGridlineAmount; i++) {
            CATextLayer* textLayer = self.textDictionary[@(i)];
            if (textLayer == nil) {
                textLayer = [[CATextLayer alloc]init];
                [self addSublayer:textLayer];
                textLayer.font = fRef;
                textLayer.contentsScale = [[UIScreen mainScreen] scale];
                textLayer.foregroundColor = self.fontColor.CGColor;
                textLayer.truncationMode = kCATruncationEnd;
                textLayer.fontSize = self.font.pointSize;
                [self.textDictionary setObject:textLayer forKey:@(i)];
            }
            [self.textFrames[i] getValue:&theLastLabelRect];
            textLayer.string = [self stringForObjectValue:i * self.interval];
            textLayer.frame = theLastLabelRect;
            textLayer.alignmentMode = self.isMajorAxis ? kCAAlignmentRight : kCAAlignmentLeft;
        }
        CFRelease(fRef);
        
        if (!REMIsNilOrNull(self.axis.axisTitle) && self.axis.axisTitle.length > 0) {
            CATextLayer* textLayer = self.textDictionary[@"title"];
            fRef = CTFontCreateWithName((__bridge CFStringRef)self.axisTitleFont.fontName,
                                        self.axisTitleFont.pointSize,
                                        NULL);
            if (textLayer == nil) {
                textLayer = [[CATextLayer alloc]init];
                [self addSublayer:textLayer];
                textLayer.font = fRef;
                textLayer.contentsScale = [[UIScreen mainScreen] scale];
                textLayer.foregroundColor = self.fontColor.CGColor;
                textLayer.truncationMode = kCATruncationStart;
                textLayer.fontSize = self.axisTitleFont.pointSize;
                [self.textDictionary setObject:textLayer forKey:@"title"];
            }
            textLayer.string = self.axis.axisTitle;
            textLayer.frame = self.axisTitleFrame;
            textLayer.alignmentMode = self.isMajorAxis ? kCAAlignmentRight : kCAAlignmentLeft;
        }
        
    } else {
        [self setNeedsDisplay];
    }
}

-(CGRect)getVisualFrame {
    return self.myFrame;
}

-(void)didYIntervalChanged:(double)oldInterval newInterval:(double)newInterval yRange:(DCRange*)yRange {
    if (newInterval <= 0) return;
    self.interval = newInterval;
    self.yRange = yRange;
    if (self.interval > 0 && self.yRange != nil) {
        if (self.textFrames.count == 0) [self updateTextFrames];
        [self updateTexts];
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
