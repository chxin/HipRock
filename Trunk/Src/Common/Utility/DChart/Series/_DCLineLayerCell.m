//
//  _DCLineLayerCell.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/19/13.
//
//

#import "_DCLineLayerCell.h"
#import "_DCLinesLayer.h"
@interface _DCLineLayerCell()
@property (nonatomic,assign) CGRect frameInNextDraw;
@property (nonatomic, assign) BOOL needSetFrameInNextDraw;
@end

@implementation _DCLineLayerCell
-(id)initWithContext:(DCContext *)context {
    self = [super initWithContext:context];
    if (self) {
        _needSetFrameInNextDraw = NO;
    }
    return self;
}
-(id)init {
    self = [super init];
    if (self) {
        _needSetFrameInNextDraw = NO;
    }
    return self;
}

-(void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    self.backgroundColor = [UIColor clearColor].CGColor;
    self.masksToBounds = NO;
    if (self.xRange == nil) return;
    if (self.superlayer == nil) return;
    
    BOOL caTransationState = CATransaction.disableActions;
    [CATransaction setDisableActions:YES];
    _DCLinesLayer* superLayer = (_DCLinesLayer*)self.superlayer;
    
    CGFloat heightUnitInScreen = (superLayer.yRange != nil && superLayer.yRange.length > 0) ? (self.frame.size.height / superLayer.yRange.length) : 0;
    int start = floor(self.xRange.location);
    int end = ceil(self.xRange.length+self.xRange.location);
    start = MAX(0, start);
    
    CGContextSetLineJoin(ctx, kCGLineJoinMiter);
    CGContextSetLineCap(ctx , kCGLineCapRound);
    CGContextSetBlendMode(ctx, kCGBlendModeNormal);
    CGContextSetAllowsAntialiasing(ctx, YES);
    CGContextBeginPath(ctx);
    
    for (DCLineSeries* s in superLayer.series) {
        int loopEnd = s.datas.count-1;
        if (end < loopEnd) loopEnd = end;
        CGContextSetLineWidth(ctx, s.lineWidth);
        CGContextSetStrokeColorWithColor(ctx, s.color.CGColor);
        NSUInteger countOfPoints = 0;
        CGPoint pointsForSeries[loopEnd-start+1];
        for (int j = start; j <= loopEnd; j++) {
            DCDataPoint* point = s.datas[j];
            if (point.value != nil && ![point.value isEqual:[NSNull null]]) {
                pointsForSeries[countOfPoints].x = superLayer.frame.size.width*(j-superLayer.graphContext.hRange.location)/self.graphContext.hRange.length-self.frame.origin.x;
                pointsForSeries[countOfPoints].y = superLayer.frame.size.height-heightUnitInScreen*point.value.doubleValue;
                countOfPoints++;
            } else {
                CGContextBeginPath(ctx);
                CGContextAddLines(ctx, pointsForSeries, countOfPoints);
                CGContextStrokePath(ctx);
                countOfPoints = 0;
            }
        }
        CGContextAddLines(ctx, pointsForSeries, countOfPoints);
    }
    CGContextStrokePath(ctx);
    if (self.needSetFrameInNextDraw) {
        self.needSetFrameInNextDraw = NO;
        self.frame = self.frameInNextDraw;
    }
    [CATransaction setDisableActions:caTransationState];
}

-(void)updateNeedsdisplayAndFrame:(CGRect)frame {
    self.needSetFrameInNextDraw = YES;
    self.frameInNextDraw = frame;
}
@end
