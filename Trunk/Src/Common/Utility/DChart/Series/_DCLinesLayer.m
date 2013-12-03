//
//  _DCLineLayer.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/19/13.
//
//

#import "_DCLinesLayer.h"
#import "_DCLayerTrashbox.h"
#import "_DCSymbolLayer.h"
#import "DCDataPoint.h"
#import "DCUtility.h"
#import "DCLineSeries.h"

@interface _DCLinesLayer()

//@property (nonatomic, strong) _DCLayerTrashbox* symbolTrashbox;
//@property (nonatomic, strong) NSMutableDictionary* symbolsDic;
@property (nonatomic, assign) BOOL symbolsAreHidden;
@property (nonatomic, strong) NSTimer* timer;
@end

@implementation _DCLinesLayer
-(id)initWithCoordinateSystem:(_DCCoordinateSystem *)coordinateSystem {
    self = [super initWithCoordinateSystem:coordinateSystem];
    if (self) {
//        self.symbolTrashbox = [[_DCLayerTrashbox alloc]init];
        _symbolsAreHidden = NO;
//        self.symbolsLayer = [[CALayer alloc]init];
//        self.symbolsLayer.frame = self.bounds;
//        [self addSublayer:self.symbolsLayer];
    }
    return self;
}
-(void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    int start = floor(self.graphContext.hRange.location);
    int end = ceil(self.graphContext.hRange.length+self.graphContext.hRange.location);
    start = MAX(0, start);
    
    CGContextSetLineJoin(ctx, kCGLineJoinMiter);
    CGContextSetLineCap(ctx , kCGLineCapRound);
    CGContextSetBlendMode(ctx, kCGBlendModeNormal);
    CGContextSetAllowsAntialiasing(ctx, YES);
    CGContextBeginPath(ctx);
    
    for (DCLineSeries* s in self.series) {
        if (s.hidden) continue;
        if (start >= s.datas.count) continue;
        int loopEnd = s.datas.count-1;
        if (end < loopEnd) loopEnd = end;
        CGContextSetLineWidth(ctx, s.lineWidth);
        CGContextSetStrokeColorWithColor(ctx, s.color.CGColor);
        NSUInteger countOfPoints = 0;
        CGPoint pointsForSeries[loopEnd-start+3];
        
        // 从RangeStart向前再搜索一个非空点，并绘制曲线
        for (int j = start-1; j >= 0; j--) {
            DCDataPoint* point = s.datas[j];
            if (point.pointType == DCDataPointTypeEmpty) {
                continue;
            } else if (point.pointType == DCDataPointTypeBreak) {
                break;
            } else {
                pointsForSeries[countOfPoints] = [self getPointBy:j y:point.value.doubleValue xOffset:s.pointXOffset];
                countOfPoints++;
                break;
            }
        }
        // 绘制图形的主要部分
        for (int j = start; j <= loopEnd; j++) {
            DCDataPoint* point = s.datas[j];
            if (point.pointType == DCDataPointTypeEmpty) {
                continue;
            } else if (point.pointType == DCDataPointTypeNormal) {
                pointsForSeries[countOfPoints] = [self getPointBy:j y:point.value.doubleValue xOffset:s.pointXOffset];
                countOfPoints++;
            } else {
                CGContextAddLines(ctx, pointsForSeries, countOfPoints);
                CGContextStrokePath(ctx);
                countOfPoints = 0;
            }
        }
        // 从RangeEnd向前后搜索一个非空点，并绘制曲线
        for (int j = loopEnd+1; j < s.datas.count; j++) {
            DCDataPoint* point = s.datas[j];
            if (point.pointType == DCDataPointTypeEmpty) {
                continue;
            } else if (point.pointType == DCDataPointTypeBreak) {
                break;
            } else {
                pointsForSeries[countOfPoints] = [self getPointBy:j y:point.value.doubleValue xOffset:s.pointXOffset];
                countOfPoints++;
                break;
            }
        }
        if (countOfPoints != 0) {
            CGContextAddLines(ctx, pointsForSeries, countOfPoints);
            CGContextStrokePath(ctx);
        }
    }
    CGContextStrokePath(ctx);
    [self renderSymbols];
}

-(CGPoint)getPointBy:(int)x y:(double)y xOffset:(double)xOffset {
    CGPoint point;
    point.x = self.frame.size.width*(x+xOffset-self.graphContext.hRange.location)/self.graphContext.hRange.length;
    point.y = self.frame.size.height-self.heightUnitInScreen*y;
    return point;
}

-(BOOL)isValidSeriesForMe:(DCXYSeries*)series {
    return [series isKindOfClass:[DCLineSeries class]];
}


-(void)didYRangeChanged:(DCRange*)oldRange newRange:(DCRange*)newRange {
    if ([DCRange isRange:oldRange equalTo:newRange]) return;
    [super didYRangeChanged:oldRange newRange:newRange];
    [self setNeedsDisplay];
//    [self renderSymbols];
}

-(void)didHRangeChanged:(DCRange *)oldRange newRange:(DCRange *)newRange {
    if ([DCRange isRange:oldRange equalTo:newRange]) return;
    [super didHRangeChanged:oldRange newRange:newRange];
    [self setNeedsDisplay];
//    [self renderSymbols];
}

-(void)lazyRenderSymbol {
    if (REMIsNilOrNull(self.symbolsLayer)) return;
    self.symbolsLayer.hidden = NO;
    self.symbolsAreHidden = NO;
    [self renderSymbols];
    [self.timer setFireDate:nil];
    [self.timer invalidate];
}

-(void)renderSymbols {
    if (REMIsNilOrNull(self.symbolsLayer) || self.symbolsAreHidden) return;
    
    int start = floor(self.graphContext.hRange.location);
    int end = ceil(self.graphContext.hRange.length+self.graphContext.hRange.location);
    NSMutableArray* pointsToDraw = [[NSMutableArray alloc]init];
    for (DCLineSeries* s in self.series) {
        if (s.hidden) continue;
        NSMutableArray* seriesPoints = [[NSMutableArray alloc]init];
        NSUInteger i = 0;
        for (int j = start; j<=end; j++) {
            if (s.symbolType == DCLineSymbolTypeNone || s.symbolSize == 0) continue;
            if (j >= s.datas.count) continue;
            
            DCDataPoint* key = s.datas[j];
            CGRect toFrame = CGRectMake(self.frame.size.width*(j+s.pointXOffset-self.graphContext.hRange.location)/self.graphContext.hRange.length-s.symbolSize/2, self.frame.size.height-[self getHeightOfPoint:key]-s.symbolSize/2, s.symbolSize, s.symbolSize);
            BOOL isRectVisable = [DCUtility isFrame:toFrame visableIn:self.bounds] && (key.value != nil) && ![key.value isEqual:[NSNull null]];
            if (isRectVisable) {
                CGPoint location = CGPointMake(toFrame.origin.x+toFrame.size.width/2, toFrame.origin.y+toFrame.size.height/2);
                CGFloat symbolAlpha = 0;
                if (j == self.focusX || self.focusX == INT32_MIN)
                    symbolAlpha = kDCSymbolAlpha;
                else
                    symbolAlpha = kDCUnfocusPointSymbolAlph;
                [seriesPoints addObject:@{ @"dcpoint": s.datas[j], @"location": [NSValue valueWithCGPoint:location], @"symbolAlpha":@(symbolAlpha) }];
            }
        }
        
        [pointsToDraw addObject:seriesPoints];
        i++;
    }
    [self.symbolsLayer drawSymbolsForPoints:pointsToDraw inSize:self.bounds.size];
    
    /*
    if (self.symbolsDic == nil) self.symbolsDic = [[NSMutableDictionary alloc]init];
    for (DCDataPoint* symbolKey in self.symbolsDic.allKeys) {
        _DCSymbolLayer* symbol = self.symbolsDic[symbolKey];
        symbol.hidden = YES;
    }
    
    BOOL caTransationState = CATransaction.disableActions;
    [CATransaction setDisableActions:YES];
    int start = floor(self.graphContext.hRange.location);
    int end = ceil(self.graphContext.hRange.length+self.graphContext.hRange.location);
    for (int j = start; j<=end; j++) {
        for (DCLineSeries* s in self.series) {
            if (s.symbol == DCLineSymbolTypeNone || s.symbolSize == 0) continue;
            if (j >= s.datas.count) continue;
            if (![self.visableSeries containsObject:s]) continue;
            
            DCDataPoint* key = s.datas[j];
            
            _DCSymbolLayer* symbol = self.symbolsDic[key];
            CGRect toFrame = CGRectMake(self.frame.size.width*(j-self.graphContext.hRange.location)/self.graphContext.hRange.length-s.symbolSize/2, self.frame.size.height-[self getHeightOfPoint:key]-s.symbolSize/2, s.symbolSize, s.symbolSize);
            BOOL isRectVisable = [DCUtility isFrame:toFrame visableIn:self.bounds] && (key.value != nil) && ![key.value isEqual:[NSNull null]];
            
            if (symbol == nil && isRectVisable) {
                symbol = [[_DCSymbolLayer alloc]initWithContext:self.graphContext type:s.symbol size:s.symbolSize color:s.color];
                symbol.frame = toFrame;
                [self.symbolsLayer addSublayer:symbol];
                [self.symbolsDic setObject:symbol forKey:key];
                [symbol setNeedsDisplay];
            } else if (symbol == nil && !isRectVisable) {
                continue;
            } else if (symbol != nil && isRectVisable) {
                symbol.frame = toFrame;
                symbol.hidden = NO;
            } else {
                [self.symbolsDic removeObjectForKey:key];
                [symbol removeFromSuperlayer];
            }
        }
    }
    
    NSArray* keysCopy = [self.symbolsDic.allKeys copy];
    for (DCDataPoint* symbolKey in keysCopy) {
        _DCSymbolLayer* symbol = self.symbolsDic[symbolKey];
        if (symbol.hidden) {
            [self.symbolsDic removeObjectForKey:symbolKey];
            [symbol removeFromSuperlayer];
        }
    }
    [CATransaction setDisableActions:caTransationState];
     */
}
-(CGFloat)getHeightOfPoint:(DCDataPoint*)point {
    double y = 0;
    if (point.value != nil && ![point.value isEqual:[NSNull null]]) {
        y = point.value.doubleValue;
    }
    return self.heightUnitInScreen * y;
}
-(void)setSymbolsHidden:(BOOL)hidden {
    if (kDCHideLineSymbolWhenDragging) {
        if (REMIsNilOrNull(self.symbolsLayer) || hidden == self.symbolsAreHidden) return;
        [self.timer setFireDate:nil];
        if (hidden) {
            _DCLineSymbolsLayer* layer = [[_DCLineSymbolsLayer alloc]initWithContext:self.graphContext];
            layer.frame = self.symbolsLayer.frame;
            [self.symbolsLayer.superlayer insertSublayer:layer below:self.symbolsLayer];
            [self.symbolsLayer removeFromSuperlayer];
            self.symbolsLayer = layer;
            self.symbolsAreHidden = hidden;
        } else {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(lazyRenderSymbol) userInfo:nil repeats:NO];
            [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:.5]];
        }
    }
}

-(void)focusOnX:(int)x {
    if (self.focusX != x) {
        [super focusOnX:x];
        [self renderSymbols];
    }
}

-(void)defocus {
    if (self.focusX != INT32_MIN) {
        [super defocus];
        [self renderSymbols];
    }
}
@end
