//
//  DCXYChartView.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/8/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "DCXYChartView.h"
#import "_DCHGridlineLayer.h"
#import "_DCCoordinateSystem.h"
#import "_DCXAxisLabelLayer.h"
#import "_DCYAxisLabelLayer.h"
#import "_DCColumnsLayer.h"
#import "_DCLinesLayer.h"
#import "DCXYSeries.h"
#import "_DCLineSymbolsLayer.h"
#import "REMColor.h"

@interface DCXYChartView ()
@property (nonatomic, strong) DCRange* beginHRange;

//@property (nonatomic, strong) _DCAxisLayer* _axisLayer;
@property (nonatomic, strong) _DCHGridlineLayer* _hGridlineLayer;
@property (nonatomic, strong) _DCXAxisLabelLayer* _xLabelLayer;

@property (nonatomic, strong) _DCCoordinateSystem* coordinate0;
@property (nonatomic, strong) _DCCoordinateSystem* coordinate1;
@property (nonatomic, strong) _DCCoordinateSystem* coordinate2;

@property (nonatomic, strong) _DCColumnsLayer* columnLayer0;
@property (nonatomic, strong) _DCColumnsLayer* columnLayer1;
@property (nonatomic, strong) _DCColumnsLayer* columnLayer2;

@property (nonatomic, strong) _DCLinesLayer* lineLayer0;
@property (nonatomic, strong) _DCLinesLayer* lineLayer1;
@property (nonatomic, strong) _DCLinesLayer* lineLayer2;

@property (nonatomic, strong) NSMutableArray* symbolLayers;
//@property (nonatomic, strong) _DCLineSymbolsLayer* lineSymbolsLayer0;
//@property (nonatomic, strong) _DCLineSymbolsLayer* lineSymbolsLayer1;
//@property (nonatomic, strong) _DCLineSymbolsLayer* lineSymbolsLayer2;

@property (nonatomic, strong) _DCYAxisLabelLayer* _yLabelLayer0;
@property (nonatomic, strong) _DCYAxisLabelLayer* _yLabelLayer1;
@property (nonatomic, strong) _DCYAxisLabelLayer* _yLabelLayer2;

@property (nonatomic) CGRect plotRect;

@property (nonatomic) CGSize y0LabelLayerSize;
@property (nonatomic) CGSize y1LabelLayerSize;
@property (nonatomic) CGSize y2LabelLayerSize;

@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) NSFormatter* xLabelFormatter;

@property (nonatomic, strong) UITapGestureRecognizer* tapGsRec;
@property (nonatomic, strong) UIPanGestureRecognizer* panGsRec;

@property (nonatomic, assign) int focusPointIndex;

@end

@implementation DCXYChartView


- (id)initWithFrame:(CGRect)frame beginHRange:(DCRange*)beginHRange stacked:(BOOL)stacked {
    self = [super initWithFrame:frame];
    if (self) {
        self.symbolLayers = [[NSMutableArray alloc]init];
        self.graphContext = [[DCContext alloc]initWithStacked:stacked];
        self.graphContext.hGridlineAmount = 0;
//        self.multipleTouchEnabled = YES;
        _beginHRange = beginHRange;
        _focusPointIndex = INT32_MIN;
    }
    return self;
}

-(void)removeFromSuperview {
//    [self._axisLayer removeFromSuperlayer];
    [self._hGridlineLayer removeFromSuperlayer];
    [self._xLabelLayer removeFromSuperlayer];
    if (self._yLabelLayer0) {
        [self._yLabelLayer0 removeFromSuperlayer];
        self._yLabelLayer0 = nil;
    }
    if (self._yLabelLayer1) {
        [self._yLabelLayer1 removeFromSuperlayer];
        self._yLabelLayer1 = nil;
    }
    if (self._yLabelLayer2) {
        [self._yLabelLayer2 removeFromSuperlayer];
        self._yLabelLayer2 = nil;
    }
    
//    self._axisLayer = nil;
    self._hGridlineLayer = nil;
    self._xLabelLayer = nil;
    self.coordinate0 = nil;
    self.coordinate1 = nil;
    self.coordinate2 = nil;
    [super removeFromSuperview];
}

-(void)willMoveToSuperview:(UIView *)newSuperview {
    [self drawAxisLines];
    [self drawHGridline];
    [self drawXLabelLayer];
    
    self.coordinate0 = [self createCoordinateSystem:self.xAxis y:self.yAxis0 series:self.seriesList index:0];
    self.coordinate1 = [self createCoordinateSystem:self.xAxis y:self.yAxis1 series:self.seriesList index:1];
    self.coordinate2 = [self createCoordinateSystem:self.xAxis y:self.yAxis2 series:self.seriesList index:2];
    if (self.coordinate0) {
        self.columnLayer0 = [self createColumnLayer:self.coordinate0];
        [self.graphContext addY0RangeObsever:self.columnLayer0];
        self.lineLayer0 = [self createLineLayer:self.coordinate0];
        [self.graphContext addY0RangeObsever:self.lineLayer0];
        [self.graphContext addHRangeObsever:self.columnLayer0];
        [self.graphContext addHRangeObsever:self.lineLayer0];
        
        self._yLabelLayer0 = [self createYLabelLayer:self.yAxis0];
        self._yLabelLayer0.isMajorAxis = YES;
        self._yLabelLayer0.frame = CGRectMake(0, 0, self.y0LabelLayerSize.width, self.y0LabelLayerSize.height);
        [self.graphContext addY0IntervalObsever:self._yLabelLayer0];
        [self._yLabelLayer0 setNeedsDisplay];
    }
    if (self.coordinate1) {
        self.columnLayer1 = [self createColumnLayer:self.coordinate1];
        [self.graphContext addY1RangeObsever:self.columnLayer1];
        self.lineLayer1 = [self createLineLayer:self.coordinate1];
        [self.graphContext addY1RangeObsever:self.lineLayer1];
        [self.graphContext addHRangeObsever:self.columnLayer1];
        [self.graphContext addHRangeObsever:self.lineLayer1];
        
        self._yLabelLayer1 = [self createYLabelLayer:self.yAxis1];
        self._yLabelLayer1.isMajorAxis = (self._yLabelLayer0 == nil);
        self._yLabelLayer1.frame = CGRectMake(self._yLabelLayer1.isMajorAxis ? 0 : self.plotRect.size.width+self.plotRect.origin.x, 0, self.y1LabelLayerSize.width, self.y1LabelLayerSize.height);
        [self.graphContext addY1IntervalObsever:self._yLabelLayer1];
        [self._yLabelLayer1 setNeedsDisplay];
    }
    if (self.coordinate2) {
        self.columnLayer2 = [self createColumnLayer:self.coordinate2];
        [self.graphContext addY2RangeObsever:self.columnLayer2];
        self.lineLayer2 = [self createLineLayer:self.coordinate2];
        [self.graphContext addY2RangeObsever:self.lineLayer2];
        [self.graphContext addHRangeObsever:self.columnLayer2];
        [self.graphContext addHRangeObsever:self.lineLayer2];
        
        self._yLabelLayer2 = [self createYLabelLayer:self.yAxis2];
        self._yLabelLayer2.isMajorAxis = (self._yLabelLayer0 == nil && self._yLabelLayer1 == nil);
        CGFloat x = 0;
        if (!self._yLabelLayer2.isMajorAxis) {
            x = (self._yLabelLayer1 == nil) ? (self.plotRect.size.width+self.plotRect.origin.x) : (self.plotRect.size.width+self.plotRect.origin.x + self.y1LabelLayerSize.width);
        }
        self._yLabelLayer2.frame = CGRectMake(x, 0, self.y2LabelLayerSize.width, self.y2LabelLayerSize.height);
        [self.graphContext addY2IntervalObsever:self._yLabelLayer2];
        [self._yLabelLayer2 setNeedsDisplay];
    }
    for (_DCLineSymbolsLayer * symbol in self.symbolLayers) {
        [self.layer addSublayer:symbol];
    }
    [self updateSymbolFrameSize];
    
    self.graphContext.hRange = self.beginHRange;
    
    [self updateGestures];
    
    [super willMoveToSuperview: newSuperview];
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateSymbolFrameSize];
}

-(void)updateSymbolFrameSize {
    CGRect symbolFrameSize = CGRectMake(self.plotRect.origin.x, self.plotRect.origin.y, self.plotRect.size.width, self.plotRect.size.height + self.xAxis.lineWidth + kDCLabelToLine);
    for (_DCLineSymbolsLayer * symbol in self.symbolLayers) {
        symbol.frame = symbolFrameSize;
    }
}

-(_DCCoordinateSystem*)createCoordinateSystem:(DCAxis*)x y:(DCAxis*)y series:(NSArray*)series index:(NSUInteger)index{
    NSMutableArray* seriesList = [[NSMutableArray alloc]init];
    for (DCXYSeries* s in series) {
        if (s.yAxis == y) {
            [self.graphContext addHRangeObsever:s];
            [seriesList addObject:s];
        }
    }
    if (seriesList.count > 0) {
        _DCCoordinateSystem* ds = [[_DCCoordinateSystem alloc]initWithSeries:seriesList x:x y:y index:index];
        ds.graphContext = self.graphContext;
        [self.graphContext addHRangeObsever:ds];
        return ds;
    } else {
        return nil;
    }
}

-(_DCColumnsLayer*)createColumnLayer:(_DCCoordinateSystem*)coordinate {
    _DCColumnsLayer* layer = [[_DCColumnsLayer alloc]initWithCoordinateSystem:coordinate];
    if (layer.series.count > 0) {
        layer.graphContext = self.graphContext;
        layer.frame = self.plotRect;
        [self.layer addSublayer:layer];
        [layer setNeedsDisplay];
        return layer;
    }
    return nil;
}

-(_DCLinesLayer*)createLineLayer:(_DCCoordinateSystem*)coordinate {
    _DCLinesLayer* layer = [[_DCLinesLayer alloc]initWithCoordinateSystem:coordinate];
    if (layer.series.count > 0) {
        _DCLineSymbolsLayer* symbols = [[_DCLineSymbolsLayer alloc]initWithContext:self.graphContext];
        layer.symbolsLayer = symbols;
        [self.symbolLayers addObject:symbols];
        layer.graphContext = self.graphContext;
        layer.frame = self.plotRect;
        [self.layer addSublayer:layer];
        [layer setNeedsDisplay];
        return layer;
    }
    return nil;
}


-(void)drawXLabelLayer {
    self._xLabelLayer = [[_DCXAxisLabelLayer alloc]initWithContext:self.graphContext];
    self._xLabelLayer.axis = self.xAxis;
    self._xLabelLayer.font = self.xAxis.labelFont;
    self._xLabelLayer.fontColor = self.xAxis.labelColor;
    [self.graphContext addHRangeObsever:self._xLabelLayer];
    self._xLabelLayer.frame = CGRectMake(self.plotRect.origin.x, self.plotRect.size.height, self.plotRect.size.width, self.frame.size.height - self.plotRect.size.height);
    [self.layer addSublayer:self._xLabelLayer];
    self._xLabelLayer.labelFormatter = self.xLabelFormatter;
    [self._xLabelLayer setNeedsDisplay];
}

-(_DCYAxisLabelLayer*) createYLabelLayer:(DCAxis*)yAxis {
    _DCYAxisLabelLayer* _yLabelLayer = [[_DCYAxisLabelLayer alloc]init];
    _yLabelLayer.graphContext = self.graphContext;
    _yLabelLayer.axis = yAxis;
    _yLabelLayer.font = yAxis.labelFont;
    _yLabelLayer.fontColor = yAxis.labelColor;
    [self.layer addSublayer:_yLabelLayer];
    return _yLabelLayer;
}

-(void)drawAxisLines {
    float plotSpaceLeft = 0;
    float plotSpaceRight = self.frame.size.width;
    float plotSpaceTop = 0;
    float plotSpaceBottom = self.frame.size.height;
    
    CGSize axisSize;
    
    axisSize = [DCUtility getSizeOfText:kDCMaxLabel forFont:self.xAxis.labelFont];
    plotSpaceBottom = plotSpaceBottom - axisSize.height - self.xAxis.lineWidth - kDCLabelToLine;
    
    axisSize = [DCUtility getSizeOfText:kDCMaxLabel forFont:self.yAxis0.labelFont];
    plotSpaceLeft = plotSpaceLeft + axisSize.width + self.yAxis0.lineWidth + kDCLabelToLine;
    self.yAxis0.startPoint = CGPointMake(plotSpaceLeft, 0);
    self.yAxis0.endPoint = CGPointMake(plotSpaceLeft, plotSpaceBottom);
    self.y0LabelLayerSize = CGSizeMake(plotSpaceLeft, plotSpaceBottom);
    
    if (self.yAxis1 && self.yAxis1.visableSeriesAmount > 0) {
        axisSize = [DCUtility getSizeOfText:kDCMaxLabel forFont:self.yAxis1.labelFont];
        CGFloat axisWidth = axisSize.width + self.yAxis2.lineWidth + kDCLabelToLine;
        plotSpaceRight = plotSpaceRight - axisWidth;
        self.yAxis1.startPoint = CGPointMake(plotSpaceRight, 0);
        self.yAxis1.endPoint = CGPointMake(plotSpaceRight, plotSpaceBottom);
        self.y1LabelLayerSize = CGSizeMake(axisWidth, plotSpaceBottom);
    }
    if (self.yAxis2 && self.yAxis2.visableSeriesAmount > 0) {
        axisSize = [DCUtility getSizeOfText:kDCMaxLabel forFont:self.yAxis2.labelFont];
        CGFloat axisWidth = axisSize.width + self.yAxis2.lineWidth + kDCLabelToLine;
        plotSpaceRight = plotSpaceRight - axisWidth;
        self.yAxis2.startPoint = CGPointMake(plotSpaceRight, 0);
        self.yAxis2.endPoint = CGPointMake(plotSpaceRight, plotSpaceBottom);
        self.y2LabelLayerSize = CGSizeMake(axisWidth, plotSpaceBottom);
    }
    self.xAxis.startPoint = CGPointMake(plotSpaceLeft, plotSpaceBottom);
    self.xAxis.endPoint = CGPointMake(plotSpaceRight, plotSpaceBottom);
    
    self.plotRect = CGRectMake(plotSpaceLeft, plotSpaceTop, plotSpaceRight-plotSpaceLeft, plotSpaceBottom-plotSpaceTop);
}

-(void)drawHGridline {
    self._hGridlineLayer = [[_DCHGridlineLayer alloc]init];
    self._hGridlineLayer.graphContext = self.graphContext;
    self._hGridlineLayer.frame = self.plotRect;
    self._hGridlineLayer.lineColor = self.hGridlineColor;
    self._hGridlineLayer.lineWidth = self.hGridlineWidth;
    self._hGridlineLayer.lineStyle = self.hGridlineStyle;
    [self.layer addSublayer:self._hGridlineLayer];
    [self._hGridlineLayer setNeedsDisplay];
}

-(void)setLineSymbolsHidden:(BOOL)symbolsAreHidden {
    if (self.lineLayer0) [self.lineLayer0 setSymbolsHidden:symbolsAreHidden];
    if (self.lineLayer1) [self.lineLayer1 setSymbolsHidden:symbolsAreHidden];
    if (self.lineLayer2) [self.lineLayer2 setSymbolsHidden:symbolsAreHidden];
}

-(void)animateHRangeLocation {
    if (self.timer.isValid) {
        double hRangeAnimationStep =  [self.timer.userInfo[@"hRangeAnimationStep"] doubleValue];
        double to =  [self.timer.userInfo[@"to"] doubleValue];
        double from =  [self.timer.userInfo[@"from"] doubleValue];
        double newLocation = self.graphContext.hRange.location + hRangeAnimationStep;
        if ((newLocation >= to && from < to) || (newLocation <= to && from > to)){
            newLocation = to;
            [self.timer invalidate];
            [self setLineSymbolsHidden:NO];
        }
        self.graphContext.hRange = [[DCRange alloc]initWithLocation:newLocation length:self.graphContext.hRange.length];
    }
}

-(void)animateHRangeLocationFrom:(double)from to:(double)to {
    if (from == to) return;
    double frames = kDCAnimationDuration * kDCFramesPerSecord;
    NSNumber* hRangeAnimationStep = @((to - from)/frames);
    NSDictionary* hRangeUserInfo = @{@"hRangeAnimationStep":hRangeAnimationStep, @"from":@(from), @"to":@(to)};
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1/kDCFramesPerSecord target:self selector:@selector(animateHRangeLocation) userInfo:hRangeUserInfo repeats:YES];
    [self.timer fire];
}

-(void)setSeriesList:(NSArray *)seriesList {
    if (seriesList != self.seriesList) {
        self.xAxis.visableSeriesAmount = seriesList.count;
        _seriesList = seriesList;
        NSUInteger columnAmount = self.graphContext.stacked ? 1 : 0;
        
        NSUInteger seriesIndex = 0;
        
        for (DCXYSeries* s in seriesList) {
            s.yAxis.visableSeriesAmount++;
            if (s.color == nil) s.color = [REMColor colorByIndex:seriesIndex].uiColor;
            if ([s isKindOfClass:[DCColumnSeries class]]) {
                if (self.graphContext.stacked) {
                    ((DCColumnSeries*)s).xRectStartAt = - 0.5 + kDCColumnOffset;
                    ((DCColumnSeries*)s).columnWidthInCoordinate = 1 - kDCColumnOffset * 2;
                } else {
                    columnAmount++;
                }
            }
            seriesIndex++;
        }
        if (!self.graphContext.stacked) {
            NSUInteger columnIndex = 0;
            double columnWidth = (1 - kDCColumnOffset * 2) / columnAmount;
            for (DCXYSeries* s in seriesList) {
                if ([s isKindOfClass:[DCColumnSeries class]]) {
                    ((DCColumnSeries*)s).columnWidthInCoordinate = columnWidth;
                    ((DCColumnSeries*)s).xRectStartAt = columnWidth * columnIndex - 0.5 + kDCColumnOffset;
                    columnIndex++;
                }
            }
        }
    }
}


//- (void)setSeries:(DCXYSeries*)series hidden:(BOOL)hidden {
//    if (series.yAxis == self.yAxis0) [self.columnLayer0 setSeries:series hidden:hidden];
//    if (series.yAxis == self.yAxis1) [self.columnLayer1 setSeries:series hidden:hidden];
//    if (series.yAxis == self.yAxis2) [self.columnLayer2 setSeries:series hidden:hidden];
//    if (hidden) {
//        
//    }
//}
-(void)setXLabelFormatter:(NSFormatter*)formatter {
    if (self._xLabelLayer) {
        self._xLabelLayer.labelFormatter = formatter;
    }
    _xLabelFormatter = formatter;
}

-(void)viewTapped:(UITapGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:self];
    if (CGRectContainsPoint(self.plotRect, touchPoint)) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(touchedInPlotAt:xCoordinate:)]) {
            [self.delegate touchedInPlotAt:touchPoint xCoordinate:[self getXLocationForPoint:touchPoint]];
        }
//        [self setLineSymbolsHidden:YES];
        if (self.timer.isValid) {
            [self.timer invalidate];
        }
    }
}

-(double)getXLocationForPoint:(CGPoint)point {
    return self.graphContext.hRange.location+self.graphContext.hRange.length*(point.x-self.plotRect.origin.x)/self.plotRect.size.width;
}

-(void)viewPanned:(UIPanGestureRecognizer*)gesture {
    CGPoint touchPoint = [gesture locationInView:self];
//    if (CGRectContainsPoint(self.plotRect, touchPoint)) {
        BOOL moveEnabled = YES;
        CGPoint translation = [gesture translationInView:self];
        if (self.delegate && [self.delegate respondsToSelector:@selector(panInPlotAt:translation:)]) {
            moveEnabled = [self.delegate panInPlotAt:touchPoint translation:translation];
        }
        if (moveEnabled) {
            if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateFailed) {
                if (self.graphContext.hRange.location < self.graphContext.globalHRange.location) {
                    [self animateHRangeLocationFrom:self.graphContext.hRange.location to:self.graphContext.globalHRange.location];
                } else if (self.graphContext.hRange.length+self.graphContext.hRange.location>self.graphContext.globalHRange.location+self.graphContext.globalHRange.length) {
                    [self animateHRangeLocationFrom:self.graphContext.hRange.location to:self.graphContext.globalHRange.length+self.graphContext.globalHRange.location-self.graphContext.hRange.length];
                } else {
                    [self setLineSymbolsHidden:NO];
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(panStopped)]) {
                    [self.delegate panStopped];
                }
            } else {
                [self setLineSymbolsHidden:YES];
                self.graphContext.hRange = [[DCRange alloc]initWithLocation:-translation.x*self.graphContext.hRange.length/self.plotRect.size.width+self.graphContext.hRange.location length:self.graphContext.hRange.length];
            }
        }
        [gesture setTranslation:CGPointMake(0, 0) inView:self];
//        NSLog(@"Pan gesture state:%d", gesture.state);
//    }
}

-(void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    if(self.userInteractionEnabled == userInteractionEnabled) return;
    [super setUserInteractionEnabled:userInteractionEnabled];
    [self updateGestures];
}

-(void)updateGestures {
    if (self.userInteractionEnabled) {
        if (REMIsNilOrNull(self.tapGsRec)) {
            self.tapGsRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
            self.panGsRec = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(viewPanned:)];
            [self addGestureRecognizer:self.tapGsRec];
            [self addGestureRecognizer:self.panGsRec];
        }
    } else {
        if (!REMIsNilOrNull(self.tapGsRec)) {
            [self removeGestureRecognizer:self.tapGsRec];
            self.tapGsRec = nil;
            [self removeGestureRecognizer:self.panGsRec];
            self.panGsRec = nil;
        }
    }
}
-(void)defocus {
    if (self.focusPointIndex == INT32_MIN) return;
    self.focusPointIndex = INT32_MIN;
    if (self.columnLayer0) [self.columnLayer0 defocus];
    if (self.columnLayer1) [self.columnLayer1 defocus];
    if (self.columnLayer2) [self.columnLayer2 defocus];
    if (self.lineLayer0) [self.lineLayer0 defocus];
    if (self.lineLayer1) [self.lineLayer1 defocus];
    if (self.lineLayer2) [self.lineLayer2 defocus];
}

-(void)focusAroundX:(double)x {
    DCRange* globalRange = self.graphContext.globalHRange;
    if (x < globalRange.location) x = floor(globalRange.location);
    if (x > globalRange.length+globalRange.length) x = ceil(globalRange.length+globalRange.location);
    
    int xRounded = floor(x+0.5);
    if (xRounded != self.focusPointIndex) {
//    while (![self hasPointsAtX:xRounded]) {
//        
//    }
        self.focusPointIndex = xRounded;
        if (self.columnLayer0) [self.columnLayer0 focusOnX:xRounded];
        if (self.columnLayer1) [self.columnLayer1 focusOnX:xRounded];
        if (self.columnLayer2) [self.columnLayer2 focusOnX:xRounded];
        if (self.lineLayer0) [self.lineLayer0 focusOnX:xRounded];
        if (self.lineLayer1) [self.lineLayer1 focusOnX:xRounded];
        if (self.lineLayer2) [self.lineLayer2 focusOnX:xRounded];
        if (self.delegate && [self.delegate respondsToSelector:@selector(focusPointChanged:)]) {
            NSMutableArray* points = [[NSMutableArray alloc]init];
            for (DCXYSeries* s in self.seriesList) {
                if (xRounded < 0 || xRounded >= s.datas.count) {
                    DCDataPoint* p = [[DCDataPoint alloc]init];
                    p.series = s;
                    p.target = s.target;
                    [points addObject:p];
                } else {
                    [points addObject:s.datas[self.focusPointIndex]];
                }
            }
            [self.delegate focusPointChanged:points];
        }
    }
}

// 检查在X上是否有pointType == DCDataPointTypeNormal的数据点
//-(BOOL)hasPointsAtX:(int)x {
//    for (DCXYSeries* s in self.seriesList) {
//        if (s.hidden) continue;
//        if (((DCDataPoint*)s.datas[x]).pointType == DCDataPointTypeNormal) return YES;
//    }
//    return NO;
//}
@end
