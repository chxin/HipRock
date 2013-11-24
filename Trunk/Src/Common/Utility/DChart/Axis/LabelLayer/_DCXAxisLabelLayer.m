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
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CTFontRef fontRef;
@property (nonatomic, strong) _DCLayerTrashbox* trashbox;

@end


@implementation _DCXAxisLabelLayer

-(id)initWithContext:(DCContext *)context {
    self = [super initWithContext:context];
    if (self) {
        self.masksToBounds = YES;
        self.backgroundColor = [UIColor clearColor].CGColor;
        self.trashbox = [[_DCLayerTrashbox alloc]init];
    }
    return self;
}
-(void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    
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

-(void)didHRangeChanged:(DCRange*)oldRange newRange:(DCRange*)newRange {
    if ([DCRange isRange:oldRange equalTo:newRange]) return;
    int start = floor(self.graphContext.hRange.location);
    int end = ceil(self.graphContext.hRange.length+self.graphContext.hRange.location);
    BOOL caTransationState = CATransaction.disableActions;
    [CATransaction setDisableActions:YES];
    if (oldRange.length == newRange.length) {
        double xMovementInScreen = self.frame.size.width * (newRange.location - oldRange.location) / newRange.length;
        
        for (NSNumber* key in self.trashbox.xToLayerDic.allKeys) {
            CATextLayer* text = self.trashbox.xToLayerDic[key];
            CGRect toFrame = CGRectMake(text.frame.origin.x-xMovementInScreen, text.frame.origin.y, text.frame.size.width, text.frame.size.height);
            if ([DCUtility isFrame:toFrame visableIn:self.bounds]) {
                text.frame = toFrame;
            } else {
                [self.trashbox.xToLayerDic removeObjectForKey:key];
                [text removeFromSuperlayer];
            }
        }
    } else {
        
        for (NSNumber* key in self.trashbox.xToLayerDic.allKeys) {
            CATextLayer* text = self.trashbox.xToLayerDic[key];
            [self.trashbox.xToLayerDic removeObjectForKey:key];
            [text removeFromSuperlayer];
        }
    }
    
    [CATransaction setDisableActions:caTransationState];
    [self updateXFormatterInterval];
    for (int i = start; i <= end; i++) {
        if (self.trashbox.xToLayerDic[@(i)] == nil) {
            [self addLabelForX:i];
        }
    }
}

-(NSString*)textForX:(int)x {
    if (self.labelFormatter) {
        return [self.labelFormatter stringForObjectValue:@(x)];
    } else {
        return [NSString stringWithFormat:@"%i", x];
    }
}

-(void)addLabelForX:(NSInteger)x {
    if (self.fontRef == nil) {
        self.fontSize = self.font.pointSize;
        self.fontRef = CTFontCreateWithName((__bridge CFStringRef)self.font.fontName,
                                            self.fontSize,
                                            NULL);
    }
    CGFloat centerX = (x - self.graphContext.hRange.location) * self.frame.size.width / self.graphContext.hRange.length;
    
    CATextLayer* text = (CATextLayer*)[self.trashbox popLayerFromTrashBox];
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
    [self.trashbox.xToLayerDic setObject:text forKey:@(x)];
}

-(void)removeFromSuperlayer {
    if (self.fontRef) {
        CFRelease(self.fontRef);
    }
    [super removeFromSuperlayer];
}

-(void)setLabelFormatter:(NSFormatter *)labelFormatter {
    _labelFormatter = labelFormatter;
    [self updateXFormatterInterval];
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateXFormatterInterval];
}

-(void)updateXFormatterInterval {
    if (!REMIsNilOrNull(self.labelFormatter) && [self.labelFormatter isKindOfClass:[_DCXLabelFormatter class]]) {
        if (self.frame.size.width == 0 || REMIsNilOrNull(self.graphContext.hRange) || self.graphContext.hRange.length==0) return;
        const int minDistance = 80;
        int interval = 0;
        float distanceNearbyPoints = self.frame.size.width / self.graphContext.hRange.length;
        if (distanceNearbyPoints >= minDistance) {
            interval = 1;
        } else {
            interval = ceil(minDistance / distanceNearbyPoints);
        }
        ((_DCXLabelFormatter*)self.labelFormatter).interval = interval;
    }
}
@end
