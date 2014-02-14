//
//  DCXYChartView.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/8/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "DCDataPoint.h"
#import "DCXYChartView.h"
#import "_DCHGridlineLayer.h"
#import "_DCCoordinateSystem.h"
#import "_DCXAxisLabelLayer.h"
#import "_DCYAxisLabelLayer.h"
#import "_DCColumnsLayer.h"
#import "DCXYSeries.h"
#import "_DCLineSymbolsLayer.h"
#import "REMColor.h"
#import "_DCHPinchGestureRecognizer.h"
#import "DCColumnSeries.h"
#import "_DCVGridlineLayer.h"
#import "_DCBackgroundBandsLayer.h"

#import "_DCXYIndicatorLayer.h"

@interface DCXYChartView ()
@property (nonatomic, strong) DCRange* beginHRange;

@property (nonatomic, strong) _DCXYIndicatorLayer* indicatorLayer;

@property (nonatomic, strong) _DCHGridlineLayer* _hGridlineLayer;
@property (nonatomic, strong) _DCXAxisLabelLayer* _xLabelLayer;

@property (nonatomic, strong) NSMutableArray* coodinates;
@property (nonatomic, strong) NSMutableArray* columnLayers;
//@property (nonatomic, strong) NSMutableArray* lineLayers;
//@property (nonatomic, strong) NSMutableArray* symbolLayers;
@property (nonatomic, strong) CALayer* lineLayerContainer;
@property (nonatomic, strong) _DCLineSymbolsLayer* symbolLayer;
@property (nonatomic, strong) _DCVGridlineLayer* _vGridlineLayer;

@property (nonatomic, strong) NSFormatter* xLabelFormatter;

@property (nonatomic, strong) UITapGestureRecognizer* tapGsRec;
@property (nonatomic, strong) UIPanGestureRecognizer* panGsRec;
@property (nonatomic, strong) _DCHPinchGestureRecognizer* pinchGsRec;

@property (nonatomic, strong) _DCBackgroundBandsLayer* backgroundBandsLayer;

@property (nonatomic, strong) NSArray* bgBands;

@end

@implementation DCXYChartView


- (id)initWithFrame:(CGRect)frame beginHRange:(DCRange*)beginHRange stacked:(BOOL)stacked {
    self = [super initWithFrame:frame];
    if (self) {
//        self.symbolLayers = [[NSMutableArray alloc]init];
        self.graphContext = [[DCContext alloc]initWithStacked:stacked];
        self.graphContext.hGridlineAmount = 0;
        self.layer.masksToBounds = YES;
        self.backgoundBands = [[NSMutableArray alloc]init];
//        self.multipleTouchEnabled = YES;
        _beginHRange = beginHRange;
        _visableYAxisAmount = 3;
        self.hasVGridlines = NO;
        self.lineLayerContainer = [[CALayer alloc]init];
        self.tapGsRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
        self.tapGsRec.delegate = self;
        [self addGestureRecognizer:self.tapGsRec];
        self.tapGsRec.cancelsTouchesInView = NO;
        self.panGsRec = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(viewPanned:)];
        self.panGsRec.delegate = self;
        self.panGsRec.maximumNumberOfTouches = 1;
        self.panGsRec.cancelsTouchesInView = NO;
        [self addGestureRecognizer:self.panGsRec];
        self.pinchGsRec = [[_DCHPinchGestureRecognizer alloc]initWithTarget:self action:@selector(viewPinched:)];
        self.pinchGsRec.delegate = self;
        self.pinchGsRec.cancelsTouchesInView = NO;
        [self addGestureRecognizer:self.pinchGsRec];
    }
    return self;
}

-(void)drawIndicatorLayer {
    self.indicatorLayer = [[_DCXYIndicatorLayer alloc]initWithContext:self.graphContext];
    self.indicatorLayer.symbolLineStyle = self.focusSymbolLineStyle;
    self.indicatorLayer.symbolLineWidth = self.focusSymbolLineWidth;
    self.indicatorLayer.symbolLineColor = self.focusSymbolLineColor;
    self.indicatorLayer.focusSymbolIndicatorSize = self.focusSymbolIndicatorSize;
    [self.layer addSublayer:self.indicatorLayer];
}

-(void)willMoveToSuperview:(UIView *)newSuperview {
    self.columnLayers = [[NSMutableArray alloc]init];
    [self.graphContext addHRangeObsever:self];
    
    [self recalculatePlotRect];
    [self drawHGridline];
    [self drawVGridlines];
    [self drawXLabelLayer];
    [self drawIndicatorLayer];
    
    self.backgroundBandsLayer = [[_DCBackgroundBandsLayer alloc]initWithContext:self.graphContext];
    self.backgroundBandsLayer.view = self;
    self.backgroundBandsLayer.fontColor = self.backgroundBandFontColor;
    self.backgroundBandsLayer.font = self.backgroundBandFont;
    [self.graphContext addHRangeObsever:self.backgroundBandsLayer];
    [self.layer addSublayer:self.backgroundBandsLayer];
    [self redrawBgBands];
    
    NSMutableArray* coordiates = [[NSMutableArray alloc]init];
    for (DCAxis* y in self.yAxisList) {
        _DCCoordinateSystem* ds = [[_DCCoordinateSystem alloc]initWithChartView:self y:y];
        ds.isMajor = (coordiates.count == 0);
        
        _DCColumnsLayer* columnsLayer = [[_DCColumnsLayer alloc]initWithCoordinateSystem:ds];
        if (columnsLayer.series.count > 0) {
            [self.layer addSublayer:columnsLayer];
            [self.columnLayers addObject:columnsLayer];
        }
        if (coordiates.count < self.visableYAxisAmount) {
            _DCYAxisLabelLayer* _yLabelLayer = (_DCYAxisLabelLayer*)[ds getAxisLabelLayer];
            [self.layer addSublayer:_yLabelLayer];
            [_yLabelLayer setNeedsDisplay];
        }
        
        [coordiates addObject:ds];
    }
    self.coodinates = coordiates;
    
    NSMutableArray* lineSeries = [[NSMutableArray alloc]init];
    for (DCXYSeries* s in self.seriesList) {
        if (s.type == DCSeriesTypeLine) {
            [lineSeries addObject:s];
        }
    }
    self.symbolLayer = [[_DCLineSymbolsLayer alloc]initWithContext:self.graphContext series:lineSeries];
    [self.layer addSublayer:self.lineLayerContainer];
    self.lineLayerContainer.masksToBounds = YES;
    [self.lineLayerContainer addSublayer:self.symbolLayer];
//    for (_DCLineSymbolsLayer * symbol in self.symbolLayers) {
//        [self.layer addSublayer:symbol];
//    }
    [self updateAllLayerFrame];
    self.graphContext.hRange = self.beginHRange;
    
    [self updateGestures];
    [self redrawBgBands];
    
    [super willMoveToSuperview: newSuperview];
}

-(void)removeFromSuperview {
    self._vGridlineLayer = nil;
//    [self.timer invalidate];
    [self.graphContext clearHRangeObservers];
    self.graphContext = nil;
    while (self.layer.sublayers.count != 0) {
        [self.layer.sublayers[self.layer.sublayers.count - 1] removeFromSuperlayer];
    }
    self.backgroundBandsLayer = Nil;
    self.symbolLayer = nil;
    self.indicatorLayer = nil;
    self.seriesList = nil;
    [self.columnLayers removeAllObjects];
    self._hGridlineLayer = nil;
    self._xLabelLayer = nil;
    [self.coodinates removeAllObjects];
    self.beginHRange = nil;
    self.xLabelFormatter = nil;
    self.bgBands = nil;
    self.xAxis = nil;
    self.yAxisList = nil;
    [super removeFromSuperview];
}

-(void)drawVGridlines {
    if (!self.hasVGridlines) return;
    self._vGridlineLayer = [[_DCVGridlineLayer alloc]initWithContext:self.graphContext];
    self._vGridlineLayer.view = self;
    [self.graphContext addHRangeObsever:self._vGridlineLayer];
    [self.layer addSublayer:self._vGridlineLayer];
    [self._vGridlineLayer setNeedsDisplay];
}

-(void)didHRangeChanged:(DCRange *)oldRange newRange:(DCRange *)newRange {
    for (_DCColumnsLayer* columnLayer in self.columnLayers) {
        if (!columnLayer.hidden && [columnLayer getVisableSeriesCount] > 0)
            [columnLayer redrawWithXRange:newRange yRange:columnLayer.coordinateSystem.yRange];
    }
    if (!self.symbolLayer.hidden && [self.symbolLayer getVisableSeriesCount] > 0)
        [self.symbolLayer setNeedsDisplay];
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateAllLayerFrame];
}

-(void)drawXLabelLayer {
    self._xLabelLayer = [[_DCXAxisLabelLayer alloc]initWithContext:self.graphContext];
    self._xLabelLayer.labelClipToBounds = self.xAxisLabelClipToBounds;
    self._xLabelLayer.axis = self.xAxis;
    self._xLabelLayer.font = self.xAxis.labelFont;
    self._xLabelLayer.fontColor = self.xAxis.labelColor;
    [self.graphContext addHRangeObsever:self._xLabelLayer];
    [self.layer addSublayer:self._xLabelLayer];
    self._xLabelLayer.labelFormatter = self.xLabelFormatter;
    [self._xLabelLayer setNeedsDisplay];
}

-(void)updateAllLayerFrame {
    self._xLabelLayer.frame = CGRectMake(self.graphContext.plotRect.origin.x, self.graphContext.plotRect.size.height+self.graphContext.plotRect.origin.y, self.graphContext.plotRect.size.width, self.frame.size.height - self.graphContext.plotRect.size.height - self.plotPaddingBottom - self.plotPaddingTop);
    
    self._hGridlineLayer.frame = self.graphContext.plotRect;
    
    self.backgroundBandsLayer.frame = self.graphContext.plotRect;
    self.indicatorLayer.frame = CGRectMake(self.graphContext.plotRect.origin.x, 0, self.graphContext.plotRect.size.width, self.graphContext.plotRect.size.height+self.plotPaddingTop);// self.graphContext.plotRect;
    self.lineLayerContainer.frame = CGRectMake(self.graphContext.plotRect.origin.x, self.graphContext.plotRect.origin.y, self.graphContext.plotRect.size.width, self.graphContext.plotRect.size.height + self.xAxis.lineWidth + self.xAxis.labelToLine);
    self.symbolLayer.frame = self.lineLayerContainer.bounds;
    if (!REMIsNilOrNull(self._vGridlineLayer)) self._vGridlineLayer.frame = self.graphContext.plotRect;
    
    for (_DCColumnsLayer* columnLayer in self.columnLayers) {
        columnLayer.frame = self.graphContext.plotRect;
    }
    
    for (int i = 0; i < self.coodinates.count; i++) {
        if (i >= self.visableYAxisAmount) break;
        _DCCoordinateSystem* ds = self.coodinates[i];
        _DCYAxisLabelLayer* _yLabelLayer = (_DCYAxisLabelLayer*)[ds getAxisLabelLayer];
        
        _yLabelLayer.frame = CGRectMake(ds.isMajor ? ds.yAxis.startPoint.x-ds.yAxis.size.width :ds.yAxis.startPoint.x, self.graphContext.plotRect.origin.y, ds.yAxis.size.width, ds.yAxis.size.height);
    }
}

-(void)recalculatePlotRect {
    float plotSpaceLeft = self.plotPaddingLeft;
    float plotSpaceRight = self.frame.size.width - plotSpaceLeft - self.plotPaddingRight;
    float plotSpaceTop = self.plotPaddingTop;
    float plotSpaceBottom = self.frame.size.height - self.plotPaddingBottom;
    
    CGSize axisSize;
    
    axisSize = [DCUtility getSizeOfText:kDCMaxLabel forFont:self.xAxis.labelFont];
    plotSpaceBottom = plotSpaceBottom - axisSize.height - self.xAxis.lineWidth - self.xAxis.labelToLine;
    
    if (self.yAxisList.count > 0) {
        DCAxis* majorYAxis = self.yAxisList[0];
        if ([majorYAxis getVisableSeriesAmount] > 0) {
            axisSize = [DCUtility getSizeOfText:kDCMaxLabel forFont:majorYAxis.labelFont];
            plotSpaceLeft = plotSpaceLeft + axisSize.width + majorYAxis.lineWidth + majorYAxis.labelToLine;
            majorYAxis.startPoint = CGPointMake(plotSpaceLeft, self.plotPaddingTop);
            majorYAxis.endPoint = CGPointMake(plotSpaceLeft, plotSpaceBottom);
            majorYAxis.size = CGSizeMake(axisSize.width + majorYAxis.lineWidth + majorYAxis.labelToLine, plotSpaceBottom-self.plotPaddingTop);
        }
        
        for (int i = 1; i < self.visableYAxisAmount; i++) {
            if (i >= self.yAxisList.count) break;
            DCAxis* secondaryYAxis = self.yAxisList[i];
            if ([secondaryYAxis getVisableSeriesAmount] == 0) continue;
            axisSize = [DCUtility getSizeOfText:kDCMaxLabel forFont:secondaryYAxis.labelFont];
            CGFloat axisWidth = axisSize.width + secondaryYAxis.lineWidth + secondaryYAxis.labelToLine;
            plotSpaceRight = plotSpaceRight - axisWidth;
            secondaryYAxis.startPoint = CGPointMake(plotSpaceRight, self.plotPaddingTop);
            secondaryYAxis.endPoint = CGPointMake(plotSpaceRight, plotSpaceBottom);
            secondaryYAxis.size = CGSizeMake(axisWidth, plotSpaceBottom-self.plotPaddingTop);
        }
    }
    self.xAxis.startPoint = CGPointMake(plotSpaceLeft, plotSpaceBottom);
    self.xAxis.endPoint = CGPointMake(plotSpaceRight, plotSpaceBottom);
    
    self.graphContext.plotRect = CGRectMake(plotSpaceLeft, plotSpaceTop, plotSpaceRight-plotSpaceLeft, plotSpaceBottom-plotSpaceTop);
}

-(void)drawHGridline {
    self._hGridlineLayer = [[_DCHGridlineLayer alloc]initWithContext:self.graphContext];
    self._hGridlineLayer.lineColor = self.hGridlineColor;
    self._hGridlineLayer.lineWidth = self.hGridlineWidth;
    self._hGridlineLayer.lineStyle = self.hGridlineStyle;
    [self.layer addSublayer:self._hGridlineLayer];
    [self._hGridlineLayer setNeedsDisplay];
}

-(void)setSeriesList:(NSArray *)seriesList {
    if (!REMIsNilOrNull(self.seriesList)) {
        for (DCXYSeries* s in self.seriesList) {
            [s.xAxis detachSeries:s];
            [s.yAxis detachSeries:s];
        }
    }
    
    if (seriesList != self.seriesList) {
        _seriesList = seriesList;
        NSUInteger columnAmount = self.graphContext.stacked ? 1 : 0;
        
        NSUInteger seriesIndex = 0;
        
        for (DCXYSeries* s in seriesList) {
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

-(void)setXLabelFormatter:(NSFormatter*)formatter {
    if (self._xLabelLayer) {
        self._xLabelLayer.labelFormatter = formatter;
    }
    _xLabelFormatter = formatter;
}

-(void)relabelX {
    [self._xLabelLayer setNeedsDisplay];
}

-(void)viewTapped:(UITapGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:self];
    if (CGRectContainsPoint(self.graphContext.plotRect, touchPoint)) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tapInPlotAt:xCoordinate:)]) {
            [self.delegate tapInPlotAt:touchPoint xCoordinate:[self getXLocationForPoint:touchPoint]];
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.tapGsRec) {
        
    }
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchesBegan)]) {
        [self.delegate touchesBegan];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchesEnded)]) {
        [self.delegate touchesEnded];
    }
}

-(double)getXLocationForPoint:(CGPoint)point {
    return self.graphContext.hRange.location+self.graphContext.hRange.length*(point.x-self.graphContext.plotRect.origin.x)/self.graphContext.plotRect.size.width;
}
//-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    CGPoint touchPoint = [gestureRecognizer locationInView:self];
//    NSLog(@"%@", CGRectContainsPoint(self.graphContext.plotRect, touchPoint) ? @"YES" : @"NO");
//    return CGRectContainsPoint(self.graphContext.plotRect, touchPoint);
//}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
-(void)viewPanned:(UIPanGestureRecognizer*)gesture {
    CGFloat speed = -[gesture velocityInView:self].x*self.graphContext.hRange.length/self.graphContext.plotRect.size.width/kDCFramesPerSecord;
    BOOL panStopped = (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateFailed);
//    NSLog(@"pan speed:%f, status:%hhd", speed, panStopped);
    if (speed == 0 && !panStopped) return;
    if (self.graphContext.focusX == INT32_MIN) {
        double location = speed+self.graphContext.hRange.location;
        DCRange* newRange = [[DCRange alloc]initWithLocation:location length:self.graphContext.hRange.length];
        if (self.delegate && [self.delegate respondsToSelector:@selector(updatePanRange:withSpeed:)]) {
            newRange = [self.delegate updatePanRange:newRange withSpeed:speed];
        }
        self.graphContext.hRange = newRange;
        if (self.delegate && [self.delegate respondsToSelector:@selector(panWithSpeed:panStopped:)]) {
            [self.delegate panWithSpeed:speed panStopped:panStopped];
        }
    } else {
        [self focusAroundX:[self getXLocationForPoint:[gesture locationInView:self]]];
    }
}

-(void)viewPinched:(_DCHPinchGestureRecognizer*)gesture {
    CGFloat centerX = self.graphContext.hRange.location + self.graphContext.hRange.length * (gesture.centerX - self.graphContext.plotRect.origin.x) / self.graphContext.plotRect.size.width;
    CGFloat start = centerX - (centerX - self.graphContext.hRange.location) * gesture.leftScale;
    CGFloat end = centerX + (-centerX + self.graphContext.hRange.end) * gesture.rightScale;
    
    BOOL pinchStopped = (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateFailed);

    DCRange* newRange = [[DCRange alloc]initWithLocation:start length:end-start];
    if (self.delegate && [self.delegate respondsToSelector:@selector(updatePinchRange:pinchCentreX:pinchStopped:)]) {
        newRange = [self.delegate updatePinchRange:newRange pinchCentreX:centerX pinchStopped:pinchStopped];
    }
    self.graphContext.hRange = newRange;
}

-(void)reloadData {
    for (_DCColumnsLayer* columnLayer in self.columnLayers) {
        [columnLayer setNeedsDisplay];
    }
    [self.symbolLayer setNeedsDisplay];
}

-(void)setAcceptPan:(BOOL)acceptPan {
    self.panGsRec.enabled = acceptPan;
    _acceptPan = acceptPan;
}

-(void)setAcceptPinch:(BOOL)acceptPinch {
    self.pinchGsRec.enabled = acceptPinch;
    _acceptPinch = acceptPinch;
}

-(void)setAcceptTap:(BOOL)acceptTap {
    self.tapGsRec.enabled = acceptTap;
    _acceptTap = acceptTap;
}

-(void)updateGestures {
    self.tapGsRec.enabled = self.acceptTap;
    self.panGsRec.enabled = self.acceptPan;
    self.pinchGsRec.enabled = self.acceptPinch;
}

-(void)defocus {
    if (self.graphContext.focusX == INT32_MIN) return;
    self.graphContext.focusX = INT32_MIN;
    for (_DCColumnsLayer* columnLayer in self.columnLayers) {
        [columnLayer setNeedsDisplay];
    }
    if (self.indicatorLayer) {
        [self.indicatorLayer setNeedsDisplay];
    }
    [self.symbolLayer setNeedsDisplay];
}

-(void)focusAroundX:(double)x {
    int xRounded = 0;
    if (self.graphContext.pointAlignToTick) {
        xRounded = floor(x+0.5);
    } else {
        xRounded = floor(x);
    }
    DCRange* globalRange = self.graphContext.globalHRange;
    int globalStartCeil = floor(globalRange.location);
    int globalEndFloor = ceil(globalRange.end);
    if (xRounded < globalStartCeil) xRounded = globalStartCeil;
    if (xRounded > globalEndFloor) xRounded = globalEndFloor;
    
    if (xRounded != self.graphContext.focusX) {
        double delay = 0;
        if (self.graphContext.focusX == INT32_MIN) delay = 0.3;
        self.graphContext.focusX = xRounded;
        for (_DCColumnsLayer* columnLayer in self.columnLayers) {
            [columnLayer setNeedsDisplay];
        }
        if (self.indicatorLayer) {
            [DCUtility runFunction:^(void){
                [self.indicatorLayer setNeedsDisplay];
            } withDelay:delay];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(focusPointChanged:at:)]) {
            NSMutableArray* points = [[NSMutableArray alloc]init];
            for (DCXYSeries* s in self.seriesList) {
                if (xRounded < 0 || xRounded >= s.datas.count) {
                    DCDataPoint* p = [[DCDataPoint alloc]init];
                    p.series = s;
                    p.target = s.target;
                    [points addObject:p];
                } else {
                    [points addObject:s.datas[xRounded]];
                }
            }
            [self.delegate focusPointChanged:points at:xRounded];
        }
    }
    [self.symbolLayer setNeedsDisplay];
}

-(void)setBackgoundBands:(NSArray *)bands {
    self.bgBands = bands;
    [self redrawBgBands];
}

-(void)redrawBgBands {
    for (_DCCoordinateSystem* y in self.coodinates) {
        NSMutableArray* bands = [[NSMutableArray alloc]init];
        if (!REMIsNilOrNull(self.bgBands))  {
            for (DCXYChartBackgroundBand* b in self.bgBands) {
                if (b.axis == y.yAxis) {
                    [bands addObject:b];
                }
            }
        }
        y.yAxis.backgroundBands = bands;
        _DCYAxisLabelLayer* yLayer = (_DCYAxisLabelLayer*)[y getAxisLabelLayer];
        [yLayer setNeedsDisplay];
    }
    
    NSMutableArray* xbands = [[NSMutableArray alloc]init];
    if (!REMIsNilOrNull(self.bgBands))  {
        for (DCXYChartBackgroundBand* b in self.bgBands) {
            if (b.axis == self.xAxis) {
                [xbands addObject:b];
            }
        }
    }
    [self.backgroundBandsLayer setBands:xbands];
}

-(void)setSeries:(DCXYSeries *)series hidden:(BOOL)hidden {
    if (series.hidden == hidden) return;
    series.hidden = hidden;
    if ([self.coodinates indexOfObject:series.coordinate] >= self.visableYAxisAmount) return;
    _DCYAxisLabelLayer* yAxisLayer = (_DCYAxisLabelLayer*)[series.coordinate getAxisLabelLayer];
    
//    CGRect yAxisFrame = [yAxisLayer getVisualFrame];
//    CGRect currentPlotRect = self.graphContext.plotRect;
//    if (yAxisLayer.axis.visableSeriesAmount == 0) {
//        yAxisLayer.hidden = YES;
//        if (yAxisLayer.isMajorAxis) {
//            self.graphContext.plotRect = CGRectMake(currentPlotRect.origin.x - yAxisFrame.size.width, currentPlotRect.origin.y, currentPlotRect.size.width+yAxisFrame.size.width, currentPlotRect.size.height);
//        }
//    } else {
//        yAxisLayer.hidden = NO;
//        if (yAxisLayer.isMajorAxis) {
//            self.graphContext.plotRect = CGRectMake(currentPlotRect.origin.x + yAxisFrame.size.width, currentPlotRect.origin.y, currentPlotRect.size.width-yAxisFrame.size.width, currentPlotRect.size.height);
//        }
//    }
    yAxisLayer.hidden = ([yAxisLayer.axis getVisableSeriesAmount] == 0);
    [self recalculatePlotRect];
    [self updateAllLayerFrame];
    for (_DCCoordinateSystem* s in self.coodinates) {
        [s recalculatorYMaxInRange:self.graphContext.hRange];
    }
    [self redrawBgBands];
    [self.symbolLayer setNeedsDisplay];
    [self.indicatorLayer setNeedsDisplay];
    [self._hGridlineLayer setNeedsDisplay];
    [self._xLabelLayer setNeedsDisplay];
    for (_DCColumnsLayer* columnLayer in self.columnLayers) {
        [columnLayer redraw];
    }
    
    for (int i = 0; i < self.coodinates.count; i++) {
        if (i >= self.visableYAxisAmount) break;
        _DCCoordinateSystem* ds = self.coodinates[i];
        _DCYAxisLabelLayer* _yLabelLayer = (_DCYAxisLabelLayer*)[ds getAxisLabelLayer];
        
        [_yLabelLayer setNeedsDisplay];
    }
}

-(DCRange*)getRangeOfAxis:(DCAxis*)axis {
    if (axis.coordinate == DCAxisCoordinateX) {
        return self.graphContext.hRange;
    } else {
        for (_DCCoordinateSystem* cs in self.coodinates) {
            if (cs.yAxis == axis) return cs.yRange;
        }
        return nil;
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
