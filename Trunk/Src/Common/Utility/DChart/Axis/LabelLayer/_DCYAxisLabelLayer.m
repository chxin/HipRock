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
@interface _DCYAxisLabelLayer()
@property NSNumberFormatter* numberFormatter;
@property (nonatomic, assign) CGFloat interval;
@property (nonatomic, weak) DCRange* yRange;
@property (nonatomic) CGRect myFrame;

@property (nonatomic, strong) NSMutableArray* yValLabels;

@property (nonatomic, strong) CATextLayer* axisTitleLayer;
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
        _yValLabels = [[NSMutableArray alloc]init];
    }
    return self;
}
-(void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    if(self.axis.lineWidth > 0) {
        CGPoint addLines[2];
        addLines[0].x = self.isMajorAxis ? self.myFrame.size.width : 0;
        addLines[0].y = 0;
        addLines[1].x = addLines[0].x;
        addLines[1].y = self.myFrame.size.height;
        
        CGContextSetLineJoin(ctx, kCGLineJoinMiter);
        [DCUtility setLineStyle:ctx style:self.axis.lineStyle];
        CGContextSetBlendMode(ctx, kCGBlendModeNormal);
        CGContextBeginPath(ctx);
        CGContextAddLines(ctx, addLines, 2);
        CGContextSetLineWidth(ctx, self.axis.lineWidth);
        CGContextSetStrokeColorWithColor(ctx, self.axis.lineColor.CGColor);
        CGContextStrokePath(ctx);
    }
}

-(void)setFrame:(CGRect)frame {
    self.myFrame = frame;
    [super setFrame:self.superlayer.bounds];
}

-(void)didYIntervalChanged:(double)oldInterval newInterval:(double)newInterval yRange:(DCRange*)yRange {
    if (newInterval <= 0) return;
    self.interval = newInterval;
    self.yRange = yRange;
    CTFontRef fRef = CTFontCreateWithName((__bridge CFStringRef)self.font.fontName,
                                          self.font.pointSize,
                                          NULL);
    if (self.interval > 0 && self.yRange != nil) {
        //        CGContextSetFillColorWithColor(ctx, self.axis.labelColor.CGColor);
        //        CGContextSelectFont(ctx, "Helvetica", self.axis.labelFont.pointSize, kCGEncodingMacRoman);
        //        CGContextSetTextDrawingMode(ctx, kCGTextFill);
        //        CGAffineTransform flip = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
        //        CGContextSetTextMatrix(ctx, flip);
        //        CGFloat labelWidth = [DCUtility getSizeOfText:kDCMaxLabel forFont:self.font].width;
        //        for (NSUInteger i = 0; i <= self.graphContext.hGridlineAmount; i++) {
        //            double yVal = i * self.interval;
        //            NSString* yString = [self stringForObjectValue:yVal];
        //            CGSize stringSize = [DCUtility getSizeOfText:yString forFont:self.axis.labelFont];
        //
        //            CGPoint pp = CGPointMake(self.isMajorAxis ? (labelWidth-stringSize.width+self.myFrame.origin.x) : self.myFrame.origin.x + self.axis.labelToLine, self.myFrame.size.height*(1-yVal/self.yRange.length)+stringSize.height/3+self.myFrame.origin.y);
        //            char *commentsMsg = (char *)[yString UTF8String];
        //            CGContextShowTextAtPoint(ctx, pp.x, pp.y, commentsMsg, strlen(commentsMsg));
        //            CGContextFillPath(ctx);
        //        }
        
        CGSize labelMaxSize = [DCUtility getSizeOfText:kDCMaxLabel forFont:self.font];
        for (CATextLayer* layer in self.yValLabels) {
            [layer removeFromSuperlayer];
        }
        [self.yValLabels removeAllObjects];
        for (NSUInteger i = 0; i <= self.graphContext.hGridlineAmount; i++) {
            double yVal = i * self.interval;
            CATextLayer* text = [[CATextLayer alloc]init];
            text.font = fRef;
            text.fontSize = self.font.pointSize;
            text.contentsScale = [[UIScreen mainScreen] scale];
            text.foregroundColor = self.fontColor.CGColor;
            text.alignmentMode = kCAAlignmentCenter;
            text.truncationMode = kCATruncationEnd;
            [text setString:[self stringForObjectValue:yVal]];
            text.alignmentMode = self.isMajorAxis ? kCAAlignmentRight : kCAAlignmentLeft;
            text.frame = CGRectMake(self.isMajorAxis ? self.myFrame.origin.x : self.myFrame.origin.x+self.axis.lineWidth+self.axis.labelToLine, self.myFrame.size.height*(1-yVal/self.yRange.length)-labelMaxSize.height/2+self.myFrame.origin.y, labelMaxSize.width, labelMaxSize.height);
            [self.yValLabels addObject:text];
            [self addSublayer:text];
        }
    }
    if (REMIsNilOrNull(self.axisTitleLayer)) {
        CATextLayer* text = [[CATextLayer alloc]init];
        text.font = fRef;
        text.fontSize = self.axisTitleFontSize;
        text.contentsScale = [[UIScreen mainScreen] scale];
        text.foregroundColor = self.axisTitleColor.CGColor;
        text.alignmentMode = kCAAlignmentCenter;
        text.truncationMode = kCATruncationEnd;
        text.alignmentMode = self.isMajorAxis ? kCAAlignmentRight : kCAAlignmentLeft;
        text.masksToBounds = NO;
        self.axisTitleLayer = text;
        [self addSublayer:text];
        CGRect theLastRect = [self.yValLabels[self.yValLabels.count - 1] frame];
        text.frame = CGRectMake(theLastRect.origin.x, theLastRect.origin.y - theLastRect.size.height - self.axisTitleToTopLabel, theLastRect.size.width, theLastRect.size.height);
    }
    [self.axisTitleLayer setString:self.axis.axisTitle];
    CFRelease(fRef);
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
