//
//  DCXAxisLabelLayer.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/12/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "_DCXAxisLabelLayer.h"
#import "DCUtility.h"
#import "_DCXLabelFormatter.h"

@interface _DCXAxisLabelLayer()

@property (nonatomic, strong) CATextLayer* cacheLayer;
@property (nonatomic, strong) NSMutableDictionary* visableLabelLayers;
@property (nonatomic, assign) CGRect visableFrame;

@end


@implementation _DCXAxisLabelLayer

-(id)initWithContext:(DCContext *)context {
    self = [super initWithContext:context];
    if (self) {
        self.backgroundColor = [UIColor clearColor].CGColor;
        self.visableLabelLayers = [[NSMutableDictionary alloc]init];
        self.masksToBounds = NO;
    }
    return self;
}
-(void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    
    CGPoint addLines[2];
    addLines[0] = self.axis.startPoint;
    addLines[1] = self.axis.endPoint;
    
    CGContextSetLineJoin(ctx, kCGLineJoinMiter);
    [DCUtility setLineStyle:ctx style:self.axis.lineStyle lineWidth:self.axis.lineWidth];
    CGContextSetBlendMode(ctx, kCGBlendModeNormal);
    CGContextBeginPath(ctx);
    CGContextAddLines(ctx, addLines, 2);
    CGContextSetLineWidth(ctx, self.axis.lineWidth);
    CGContextSetStrokeColorWithColor(ctx, self.axis.lineColor.CGColor);
    CGContextStrokePath(ctx);
//    [self updateTexts];
    
    
    
    UIGraphicsPushContext(ctx);
    
    CGContextSetStrokeColorWithColor(ctx, self.fontColor.CGColor);
    CGContextSetFillColorWithColor(ctx, self.fontColor.CGColor);
    CGFloat maxLabelLength = INT32_MAX;
    if (self.labelFormatter && [self.labelFormatter respondsToSelector:@selector(getMaxXLabelLengthIn:)]) {
        maxLabelLength = [((id<_DCXLabelFormatterProtocal>)self.labelFormatter) getMaxXLabelLengthIn:self.bounds];
    }
    CGFloat offset = 0;
    if (!self.graphContext.xLabelAlignToTick) {
        offset = 0.5;
    }
    int start = floor(self.graphContext.hRange.location);
    int end = ceil(self.graphContext.hRange.end);
    for (int i = start; i <= end; i++) {
        NSString* labelText = [self textForX:i];
        if (REMIsNilOrNull(labelText) || labelText.length == 0) continue;
        CGFloat centerX = self.graphContext.plotRect.origin.x + (i + offset - self.graphContext.hRange.location) * self.graphContext.plotRect.size.width / self.graphContext.hRange.length;
        CGSize size = [DCUtility getSizeOfText:labelText forFont:self.font];
        CGRect textFrame;
        CGFloat textY = self.visableFrame.origin.y + self.visableFrame.size.height - size.height;
        if (size.width > maxLabelLength) {
            textFrame = CGRectMake(centerX-maxLabelLength/2,textY, maxLabelLength,size.height);
        } else {
            textFrame = CGRectMake(centerX-size.width/2,textY, size.width,size.height);
        }
        if ([DCUtility isFrame:textFrame visableIn:self.visableFrame]) {
            [labelText drawInRect:textFrame withFont:self.font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        }
    }
    UIGraphicsPopContext();
}

//-(void)updateTexts {
//    BOOL caTransationState = CATransaction.disableActions;
//    [CATransaction setDisableActions:YES];
//    if (REMIsNilOrNull(self.cacheLayer)) {
//        self.cacheLayer = [self constructCacheTextLayer];
//    }
//    CGFloat maxLabelLength = INT32_MAX;
//    if (self.labelFormatter && [self.labelFormatter respondsToSelector:@selector(getMaxXLabelLengthIn:)]) {
//        maxLabelLength = [((id<_DCXLabelFormatterProtocal>)self.labelFormatter) getMaxXLabelLengthIn:self.bounds];
//    }
//    CGFloat offset = 0;
//    if (!self.graphContext.xLabelAlignToTick) {
//        offset = 0.5;
//    }
//    
//    int start = floor(self.graphContext.hRange.location);
//    int end = ceil(self.graphContext.hRange.end);
//    NSMutableArray* textFrameArray = [[NSMutableArray alloc]init];
//    NSMutableArray* textStringArray = [[NSMutableArray alloc]init];
//    NSMutableArray* textXValArray = [[NSMutableArray alloc]init];
//    for (int i = start; i <= end; i++) {
//        NSString* labelText = [self textForX:i];
//        if (REMIsNilOrNull(labelText) || labelText.length == 0) continue;
//        CGFloat centerX = (i + offset - self.graphContext.hRange.location) * self.frame.size.width / self.graphContext.hRange.length;
//        CGSize size = [DCUtility getSizeOfText:labelText forFont:self.font];
//        CGRect textFrame;
//        if (size.width > maxLabelLength) {
//            textFrame = CGRectMake(centerX-maxLabelLength/2,self.frame.size.height-size.height, maxLabelLength,size.height);
//        } else {
//            textFrame = CGRectMake(centerX-size.width/2,self.frame.size.height-size.height, size.width,size.height);
//        }
//        if ([DCUtility isFrame:textFrame visableIn:self.bounds]) {
//            [textStringArray addObject:labelText];
//            [textFrameArray addObject:[NSValue valueWithCGRect:textFrame]];
//            [textXValArray addObject:@(i)];
//        }
//    }
//    
//    for (int i = 0; i < textStringArray.count; i++) {
//        CATextLayer* t = self.visableLabelLayers[textXValArray[i]];
//        if (REMIsNilOrNull(t)) {
//            t = self.cacheLayer;
//            t.hidden = NO;
//            [self.visableLabelLayers setObject:t forKey:textXValArray[i]];
//            self.cacheLayer = [self constructCacheTextLayer];
//        }
//        [t setString:textStringArray[i]];
//        CGRect rect;
//        [[textFrameArray objectAtIndex:i] getValue:&rect];
//        t.frame = rect;
//    }
//    
//    NSMutableArray* layersToBeRemove = [[NSMutableArray alloc]init];
//    NSArray* allkeys = self.visableLabelLayers.allKeys.copy;
//    for (NSNumber* key in allkeys) {
//        if (![textXValArray containsObject:key]) {
//            [layersToBeRemove addObject:key];
//        }
//    }
//    for (NSNumber* i in layersToBeRemove) {
//        [self.visableLabelLayers[i] removeFromSuperlayer];
//        [self.visableLabelLayers removeObjectForKey:i];
//    }
//    
//    [CATransaction setDisableActions:caTransationState];
//}
//
//-(CATextLayer*)constructCacheTextLayer {
//    CTFontRef fRef = CTFontCreateWithName((__bridge CFStringRef)self.font.fontName,
//                                          self.font.pointSize,
//                                          NULL);
//    CATextLayer*text = [[CATextLayer alloc]init];
//    text.font = fRef;
//    text.fontSize = self.font.pointSize;
//    text.contentsScale = [[UIScreen mainScreen] scale];
//    text.foregroundColor = self.fontColor.CGColor;
//    text.truncationMode = kCATruncationEnd;
//    text.alignmentMode = kCAAlignmentLeft;
//    text.hidden = YES;
//    [self addSublayer:text];
//    CFRelease(fRef);
//    return text;
//}

-(void)willHRangeChanged:(DCRange *)oldRange newRange:(DCRange *)newRange {
    // Nothing to do.
}

-(void)didHRangeChanged:(DCRange*)oldRange newRange:(DCRange*)newRange {
    if ([DCRange isRange:oldRange equalTo:newRange]) return;
    if (oldRange.length != newRange.length)
        [self updateXFormatterInterval];
    [self setNeedsDisplay];
//    [self updateTexts];
}


-(NSString*)textForX:(int)x {
    if (!REMIsNilOrNull(self.labelFormatter)) {
        return [self.labelFormatter stringForObjectValue:@(x)];
    } else {
        return [NSString stringWithFormat:@"%i", x];
    }
}

//-(void)removeFromSuperlayer {
//    if (self.fontRef) {
//        CFRelease(self.fontRef);
//        self.fontRef = nil;
//    }
//    [super removeFromSuperlayer];
//}

-(void)setLabelFormatter:(NSFormatter *)labelFormatter {
    _labelFormatter = labelFormatter;
    [self updateXFormatterInterval];
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:self.superlayer.bounds];
    self.visableFrame = frame;
    [self updateXFormatterInterval];
}

-(void)updateXFormatterInterval {
    if (!REMIsNilOrNull(self.labelFormatter) && [self.labelFormatter isKindOfClass:[_DCXLabelFormatter class]]) {
        if (self.graphContext.plotRect.size.width == 0 || REMIsNilOrNull(self.graphContext.hRange) || self.graphContext.hRange.length==0) return;
        const int minDistance = 80;
        int interval = 0;
        float distanceNearbyPoints = self.graphContext.plotRect.size.width / self.graphContext.hRange.length;
        if (distanceNearbyPoints >= minDistance) {
            interval = 1;
        } else {
            interval = ceil(minDistance / distanceNearbyPoints);
        }
        ((_DCXLabelFormatter*)self.labelFormatter).interval = interval;
    }
}
@end
