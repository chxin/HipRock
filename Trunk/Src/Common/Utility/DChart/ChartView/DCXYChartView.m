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
#import "_DCVGridlineLayer.h"
#import "_DCVerticalBackgroundLayer.h"
#import "_DCHorizontalBackgroundLayer.h"
#import "_DCXYIndicatorLayer.h"

@interface DCXYChartView ()
@property (nonatomic, strong) DCRange* beginHRange;

@property (nonatomic, strong) _DCXYIndicatorLayer* indicatorLayer;

@property (nonatomic, strong) _DCHGridlineLayer* _hGridlineLayer;   // 包含横向分割线以及x轴轴线
@property (nonatomic, strong) _DCXAxisLabelLayer* _xLabelLayer;

@property (nonatomic, strong) NSMutableArray* coodinates;
@property (nonatomic, strong) _DCColumnsLayer* _columnLayer;
//@property (nonatomic, strong) NSMutableArray* lineLayers;
//@property (nonatomic, strong) NSMutableArray* symbolLayers;
@property (nonatomic, strong) CALayer* lineLayerContainer;
@property (nonatomic, strong) CALayer* _columnLayerContainer;
@property (nonatomic, strong) _DCLineSymbolsLayer* _symbolLayer;
@property (nonatomic, strong) _DCVGridlineLayer* _vGridlineLayer;
@property (nonatomic, strong) _DCHorizontalBackgroundLayer* _horizentalBackgroundLayer;

@property (nonatomic, strong) NSFormatter* xLabelFormatter;

@property (nonatomic, strong) UITapGestureRecognizer* tapGsRec;
@property (nonatomic, strong) UIPanGestureRecognizer* panGsRec;
@property (nonatomic, strong) _DCHPinchGestureRecognizer* pinchGsRec;

@property (nonatomic, strong) _DCVerticalBackgroundLayer* backgroundBandsLayer;

@property (nonatomic, strong) NSArray* bgBands;
@property (nonatomic, strong) NSMutableArray* yAxisList;

@end

@implementation DCXYChartView

#pragma mark - initialize/dispose
- (id)initWithFrame:(CGRect)frame beginHRange:(DCRange*)beginHRange {
    self = [super initWithFrame:frame];
    if (self) {
        self.graphContext = [[DCContext alloc]init];
        self.graphContext.hGridlineAmount = 0;
        self.layer.masksToBounds = YES;
        self.backgoundBands = [[NSMutableArray alloc]init];
        _beginHRange = beginHRange;
        _visableYAxisAmount = 3;
        self.lineLayerContainer = [[CALayer alloc]init];
        self._columnLayerContainer = [[CALayer alloc]init];
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

-(void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview != nil) {
        [self.graphContext addHRangeObsever:self];
        [self updateGestures];
        [self initializeLayers];
        
        [self updateCoordinateSystems];
        [self recalculatePlotRect];
        [self updateAllLayerFrame];
        [self calculateColumnWidth];
        
        [self._hGridlineLayer setNeedsDisplay];
        [self._vGridlineLayer setNeedsDisplay];
        [self._xLabelLayer setNeedsDisplay];
        [self redrawBgBands];
        for (int i = 0; i < self.coodinates.count; i++) {
            _DCCoordinateSystem* ds = self.coodinates[i];
            _DCYAxisLabelLayer* _yLabelLayer = ds.yAxisLabelLayer;
            
            [_yLabelLayer setNeedsDisplay];
        }
        
        self.graphContext.hRange = self.beginHRange;
    }
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
    self._symbolLayer = nil;
    self.indicatorLayer = nil;
    self.seriesList = nil;
    self._hGridlineLayer = nil;
    self._xLabelLayer = nil;
    [self.coodinates removeAllObjects];
    self.beginHRange = nil;
    self.xLabelFormatter = nil;
    self.bgBands = nil;
    self.xAxis = nil;
    _yAxisList = nil;
    [super removeFromSuperview];
}


#pragma mark - layers creation
-(void)initializeLayers {
    // 横向分割线和X轴线图层
    self._hGridlineLayer = [[_DCHGridlineLayer alloc]initWithContext:self.graphContext view:self];
    [self.layer addSublayer:self._hGridlineLayer];
    // 纵向分割线图层
    self._vGridlineLayer = [[_DCVGridlineLayer alloc]initWithContext:self.graphContext view:self];
    [self.graphContext addHRangeObsever:self._vGridlineLayer];
    [self.layer addSublayer:self._vGridlineLayer];
    // x轴文本图层
    self._xLabelLayer = [[_DCXAxisLabelLayer alloc]initWithContext:self.graphContext view:self];
    self._xLabelLayer.axis = self.xAxis;
    [self.graphContext addHRangeObsever:self._xLabelLayer];
    [self.layer addSublayer:self._xLabelLayer];
    self._xLabelLayer.labelFormatter = self.xLabelFormatter;
    // y轴文本图层（多个）
    for (int i = 0; i < self.coodinates.count; i++) {
        if (i >= self.visableYAxisAmount) break;
        _DCCoordinateSystem* ds = self.coodinates[i];
        
        _DCYAxisLabelLayer* _yLabelLayer = ds.yAxisLabelLayer;
        
        _yLabelLayer.frame = CGRectMake(ds.isMajor ? ds.yAxis.startPoint.x-ds.yAxis.size.width :ds.yAxis.startPoint.x, self.graphContext.plotRect.origin.y, ds.yAxis.size.width, ds.yAxis.size.height);
    }
    // HC背景图层
    self.backgroundBandsLayer = [[_DCVerticalBackgroundLayer alloc]initWithContext:self.graphContext view:self];
    [self.graphContext addHRangeObsever:self.backgroundBandsLayer];
    [self.layer addSublayer:self.backgroundBandsLayer];
    // PM25背景图层
    self._horizentalBackgroundLayer = [[_DCHorizontalBackgroundLayer alloc]initWithContext:self.graphContext view:self];
    [self.layer addSublayer:self._horizentalBackgroundLayer];
    // Indicator图层
    self.indicatorLayer = [[_DCXYIndicatorLayer alloc]initWithContext:self.graphContext view:self];
    [self.layer addSublayer:self.indicatorLayer];
    // Column图层
    _DCColumnsLayer* columnsLayer = [[_DCColumnsLayer alloc]initWithContext:self.graphContext view:self coordinateSystems:self.coodinates];
    [self.layer addSublayer:self._columnLayerContainer];
    self._columnLayerContainer.masksToBounds = YES;
    [self._columnLayerContainer addSublayer:columnsLayer];
    self._columnLayer = columnsLayer;
    // Line图层
    self._symbolLayer = [[_DCLineSymbolsLayer alloc]initWithContext:self.graphContext view:self coordinateSystems:self.coodinates];
    [self.layer addSublayer:self.lineLayerContainer];
    self.lineLayerContainer.masksToBounds = YES;
    [self.lineLayerContainer addSublayer:self._symbolLayer];
}

-(void)didHRangeChanged:(DCRange *)oldRange newRange:(DCRange *)newRange {
    if (!self._columnLayer.hidden && [self._columnLayer getVisableSeriesCount] > 0)
        [self._columnLayer redraw];
    if (!self._symbolLayer.hidden && [self._symbolLayer getVisableSeriesCount] > 0)
        [self._symbolLayer redraw];
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self recalculatePlotRect];
    [self updateAllLayerFrame];
    [self._symbolLayer redraw];
    [self._columnLayer redraw];
    [self.indicatorLayer setNeedsDisplay];
}

#pragma mark - calculate layer frame and plotRect
/*
 * Apply plotRect to each layer.
 */
-(void)updateAllLayerFrame {
    self._xLabelLayer.frame = CGRectMake(self.graphContext.plotRect.origin.x, self.graphContext.plotRect.size.height+self.graphContext.plotRect.origin.y, self.graphContext.plotRect.size.width, self.frame.size.height - self.graphContext.plotRect.size.height - self.chartStyle.plotPaddingBottom - self.chartStyle.plotPaddingTop);
    self._horizentalBackgroundLayer.frame = self.bounds;
    self._columnLayerContainer.frame = self.graphContext.plotRect;
    self._hGridlineLayer.frame = self.bounds;
    
    self.backgroundBandsLayer.frame = self.graphContext.plotRect;
    self.indicatorLayer.frame = CGRectMake(self.graphContext.plotRect.origin.x, 0, self.graphContext.plotRect.size.width, self.graphContext.plotRect.size.height+self.chartStyle.plotPaddingTop);// self.graphContext.plotRect;
    self.lineLayerContainer.frame = CGRectMake(self.graphContext.plotRect.origin.x, self.graphContext.plotRect.origin.y, self.graphContext.plotRect.size.width, self.graphContext.plotRect.size.height + self.chartStyle.xLineWidth + self.chartStyle.xLabelToLine);
    self._symbolLayer.frame = self.lineLayerContainer.bounds;
    if (!REMIsNilOrNull(self._vGridlineLayer)) self._vGridlineLayer.frame = self.graphContext.plotRect;
    
    self._columnLayer.frame = self._columnLayerContainer.bounds;
    
    for (int i = 0; i < self.coodinates.count; i++) {
        _DCCoordinateSystem* ds = self.coodinates[i];
        _DCYAxisLabelLayer* _yLabelLayer = ds.yAxisLabelLayer;
        if (i >= self.visableYAxisAmount || [ds.yAxis getVisableSeriesAmount] == 0 ) {
            _yLabelLayer.hidden = YES;
        } else if (i == 0) {
            _yLabelLayer.hidden = NO;
            _yLabelLayer.frame = CGRectMake(ds.yAxis.startPoint.x-ds.yAxis.size.width, self.graphContext.plotRect.origin.y, ds.yAxis.size.width, ds.yAxis.size.height);
        } else {
            _yLabelLayer.hidden = NO;
            _yLabelLayer.frame = CGRectMake(ds.yAxis.startPoint.x, self.graphContext.plotRect.origin.y, ds.yAxis.size.width, ds.yAxis.size.height);
        }
    }
}

/*
 * Re-calculate self.graphContext.plotRect and unit height in y direction of each coordinate system.
 */
-(void)recalculatePlotRect {
    float plotSpaceLeft = self.chartStyle.plotPaddingLeft;
    float plotSpaceRight = self.frame.size.width - plotSpaceLeft - self.chartStyle.plotPaddingRight;
    float plotSpaceTop = self.chartStyle.plotPaddingTop;
    float plotSpaceBottom = self.frame.size.height - self.chartStyle.plotPaddingBottom;
    
    CGSize axisSize;
    
    axisSize = [DCUtility getSizeOfText:kDCMaxLabel forFont:self.chartStyle.xTextFont];
    plotSpaceBottom = plotSpaceBottom - axisSize.height - self.chartStyle.yLineWidth - self.chartStyle.xLabelToLine;
    
    for (NSUInteger i = 0; i < self.yAxisList.count; i++) {
        if (i >= self.visableYAxisAmount) break;
        DCAxis* yAxis = self.yAxisList[i];
        if ([yAxis getVisableSeriesAmount] <= 0) continue;
        
        axisSize = [DCUtility getSizeOfText:kDCMaxLabel forFont:self.chartStyle.yTextFont];
        if (i == 0) {
            plotSpaceLeft = plotSpaceLeft + axisSize.width + self.chartStyle.yLineWidth + self.chartStyle.yLabelToLine;
            yAxis.startPoint = CGPointMake(plotSpaceLeft, self.chartStyle.plotPaddingTop);
            yAxis.endPoint = CGPointMake(plotSpaceLeft, plotSpaceBottom);
            yAxis.size = CGSizeMake(axisSize.width + self.chartStyle.yLineWidth + self.chartStyle.yLabelToLine, plotSpaceBottom-self.chartStyle.plotPaddingTop);
        } else {
            CGFloat axisWidth = axisSize.width + self.chartStyle.yLineWidth + self.chartStyle.yLabelToLine;
            plotSpaceRight = plotSpaceRight - axisWidth;
            yAxis.startPoint = CGPointMake(plotSpaceRight, self.chartStyle.plotPaddingTop);
            yAxis.endPoint = CGPointMake(plotSpaceRight, plotSpaceBottom);
            yAxis.size = CGSizeMake(axisWidth, plotSpaceBottom-self.chartStyle.plotPaddingTop);
        }
    }
    self.xAxis.startPoint = CGPointMake(plotSpaceLeft, plotSpaceBottom);
    self.xAxis.endPoint = CGPointMake(plotSpaceRight, plotSpaceBottom);
    
    self.graphContext.plotRect = CGRectMake(plotSpaceLeft, plotSpaceTop, plotSpaceRight-plotSpaceLeft, plotSpaceBottom-plotSpaceTop);
    for (_DCCoordinateSystem* coord in self.coodinates) {
        coord.heightUnitInScreen = (coord.yRange != nil && coord.yRange.length > 0) ? (self.graphContext.plotRect.size.height / coord.yRange.length) : 0;
    }
}

#pragma mark - gesture and user interaction
-(void)viewTapped:(UITapGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:self];
    if (CGRectContainsPoint(self.graphContext.plotRect, touchPoint)) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tapInPlotAt:xCoordinate:)]) {
            [self.delegate tapInPlotAt:touchPoint xCoordinate:[self getXLocationForPoint:touchPoint]];
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchesBegan)]) {
        [self.delegate touchesBegan];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchesEnded)]) {
        [self.delegate touchesEnded];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

-(void)viewPanned:(UIPanGestureRecognizer*)gesture {
    CGFloat speed = -[gesture velocityInView:self].x*self.graphContext.hRange.length/self.graphContext.plotRect.size.width/kDCFramesPerSecord;
    BOOL panStopped = (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateFailed);
//     (@"pan speed:%f, status:%hhd", speed, panStopped);
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

#pragma mark - focus defocus
-(void)defocus {
    if (self.graphContext.focusX == INT32_MIN) return;
    self.graphContext.focusX = INT32_MIN;
    [self._columnLayer redraw];
    if (self.indicatorLayer) {
        [self.indicatorLayer setNeedsDisplay];
    }
    [self._symbolLayer redraw];
}

-(void)focusAroundX:(double)x {
    int xRounded = floor(x-self.graphContext.pointHorizentalOffset+0.5);
    DCRange* globalRange = self.graphContext.globalHRange;
    int globalStartCeil = floor(globalRange.location);
    int globalEndFloor = ceil(globalRange.end);
    if (xRounded < globalStartCeil) xRounded = globalStartCeil;
    if (xRounded > globalEndFloor) xRounded = globalEndFloor;
    
    if (xRounded != self.graphContext.focusX) {
        double delay = 0;
        if (self.graphContext.focusX == INT32_MIN) delay = 0.3;
        self.graphContext.focusX = xRounded;
        [self._columnLayer redraw];
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
    [self._symbolLayer redraw];
}

#pragma mark - others
-(void)setSeriesList:(NSArray *)seriesList {
    if (seriesList == self.seriesList) return;
    
    _seriesList = seriesList;
}

-(void)calculateColumnWidth {
//    NSMutableArray* columnGroups = [[NSMutableArray alloc]init];
    
    NSUInteger columnsCount = 0;    // Column位置的总数
    NSMutableDictionary* groupLocationDic = [[NSMutableDictionary alloc]init]; // 存储每个Group在ColumnLayer中绘图时占用的Column位置Index
    NSMutableArray* seriesLocations = [[NSMutableArray alloc]init]; // 存储每个可见的柱序列在ColumnLayer中绘图时占用的Column位置Index
    
    for (DCXYSeries* s in self.seriesList) {
        if (s.hidden || s.type == DCSeriesTypeLine) continue;
        NSUInteger sLocation = 0;
        if (s.stacked) {
            NSString* cs2groupKeys = [NSString stringWithFormat:@"%@-%@", s.coordinateSystemName, s.groupName];
            if ([groupLocationDic.allKeys containsObject:cs2groupKeys]) {
                sLocation = [groupLocationDic[cs2groupKeys] integerValue];
            } else {
                [groupLocationDic setObject:@(columnsCount) forKey:cs2groupKeys];
                sLocation = columnsCount;
                columnsCount++;
            }
        } else {
            sLocation = columnsCount;
            columnsCount++;
        }
        [seriesLocations addObject:@(sLocation)];
    }
    
    if (columnsCount == 0) return;
    double columnWidth = (1 - kDCColumnOffset * 2) / columnsCount;
    NSUInteger i = 0;
    for (DCXYSeries* s in self.seriesList) {
        if (s.hidden || s.type == DCSeriesTypeLine) continue;
        s.xRectStartAt = (-0.5 + [seriesLocations[i] floatValue]) * columnWidth;
        i++;
    }
    for (_DCCoordinateSystem* cs in self.coodinates) {
        for (DCColumnSeriesGroup* group in cs.columnGroupSeriesDic.allValues) {
            group.columnWidthInCoordinate = columnWidth;
        }
    }
}

-(void)setXLabelFormatter:(NSFormatter*)formatter {
    if (self._xLabelLayer) {
        self._xLabelLayer.labelFormatter = formatter;
    }
    _xLabelFormatter = formatter;
}

-(double)getXLocationForPoint:(CGPoint)point {
    return [self convertViewPoint:point inCoordinate:nil].x;
}

-(_DCCoordinateSystem*)findCoordinateByYAxis:(DCAxis *)yAxis {
    for (_DCCoordinateSystem* c in self.coodinates) {
        if (c.yAxis == yAxis) return c;
    }
    return nil;
}

/*
 * 将相对于View的一个Point转为XY值。如果dc==null，返回的Point只包含x值，y值为INT32_MIN。
 */
-(CGPoint)convertViewPoint:(CGPoint)point inCoordinate:(_DCCoordinateSystem*)dc {
    CGPoint xyPoint;
    DCRange* hRange = self.graphContext.hRange;
    CGRect plotRect = self.graphContext.plotRect;
    xyPoint.x = hRange.location+hRange.length*(point.x-plotRect.origin.x)/plotRect.size.width;
    if (REMIsNilOrNull(dc)) {
        xyPoint.y = INT32_MIN;
    } else {
        DCRange* vRange = dc.yRange;
        xyPoint.y = vRange.location+vRange.length*(plotRect.origin.y+plotRect.size.height-point.y)/vRange.length;
    }
    return xyPoint;
}

-(void)reloadData {
    [self._columnLayer redraw];
    [self._symbolLayer redraw];
    [self._xLabelLayer setNeedsDisplay];
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
                if (b.direction == DCAxisCoordinateY) {
                    [bands addObject:b];
                }
            }
        }
        y.yAxis.backgroundBands = bands;
        [self._horizentalBackgroundLayer redraw];
    }
    
    NSMutableArray* xbands = [[NSMutableArray alloc]init];
    if (!REMIsNilOrNull(self.bgBands))  {
        for (DCXYChartBackgroundBand* b in self.bgBands) {
            if (b.direction == DCAxisCoordinateX) {
                [xbands addObject:b];
            }
        }
    }
    [self.backgroundBandsLayer setBands:xbands];
}

/*
 * 1. Clear all coordinate systems and yAxis objects. Remove all y-Axes layers.
 * 2. Create new coordinate systems according to self.seriesList. The series.coordinateSystemName will cause a new coordinate systems.
 * 3. Create new yAxes list.
 * 4. Insert new yAxes label layers above x-Axis label layer.
 */
-(void)updateCoordinateSystems {
    if (self.coodinates == nil) self.coodinates = [[NSMutableArray alloc]init];
    if (self.yAxisList == nil) self.yAxisList = [[NSMutableArray alloc]init];
    // Destroy all coordinates and y-axes
    for (_DCCoordinateSystem* c in self.coodinates) {
        for (DCXYSeries* s in c.seriesList) {
            [c detachSeries:s];
        }
        [c removeYIntervalObsever:self._horizentalBackgroundLayer];
        if (!REMIsNilOrNull(c.yAxisLabelLayer.superlayer)) [c.yAxisLabelLayer removeFromSuperlayer];
    }
    
    [self.coodinates removeAllObjects];
    [self.yAxisList removeAllObjects];
    
    NSMutableDictionary* csDic = [[NSMutableDictionary alloc]init];
    for (DCXYSeries* series in self.seriesList) {
        _DCCoordinateSystem* cs = csDic[series.coordinateSystemName];
        if (REMIsNilOrNull(cs)) {
            cs = [[_DCCoordinateSystem alloc]initWithChartView:self name:series.coordinateSystemName];
            cs.isMajor = (self.coodinates.count == 0);
            [cs addYIntervalObsever:self._horizentalBackgroundLayer];
            [csDic setObject:cs forKey:series.coordinateSystemName];
            [self.coodinates addObject:cs];
            [self.yAxisList addObject:cs.yAxis];
            [self.layer insertSublayer:cs.yAxisLabelLayer above:self._xLabelLayer];
        }
        [cs attachSeries:series];
    }
    [self redrawBgBands];
}

-(NSArray*)getYAxes {
    return self.yAxisList;
}

-(void)setSeries:(DCXYSeries *)series hidden:(BOOL)hidden {
    if (series.hidden == hidden) return;
    series.hidden = hidden;
    
    [self recalculatePlotRect];
    [self updateAllLayerFrame];
    if (series.type == DCSeriesTypeColumn) {
        [self calculateColumnWidth];
    }
    [self.indicatorLayer setNeedsDisplay];
    [self._hGridlineLayer setNeedsDisplay];
    [self._xLabelLayer setNeedsDisplay];
    [self._columnLayer redraw];
    for (_DCCoordinateSystem* s in self.coodinates) {
        [s recalculatorYMaxInRange:self.graphContext.hRange];
    }
    [self redrawBgBands];
    [self._symbolLayer redraw];
    
    for (int i = 0; i < self.coodinates.count; i++) {
        if (i >= self.visableYAxisAmount) break;
        _DCCoordinateSystem* ds = self.coodinates[i];
        _DCYAxisLabelLayer* _yLabelLayer = ds.yAxisLabelLayer;
        
        [_yLabelLayer setNeedsDisplay];
    }
}

-(void)updateSeries:(DCXYSeries*)series type:(DCSeriesType)type coordinateName:(NSString*)coordinateName stacked:(BOOL)stacked {
    BOOL isTypeChanged = series.type != type;
    BOOL isCoordinateChanged = [series.coordinateSystemName isEqual:coordinateName];
    if (!isTypeChanged && !isCoordinateChanged) return;
    
    if (isCoordinateChanged) {
        _DCCoordinateSystem* sourceCs = series.coordinate;
        [sourceCs detachSeries:series];
        [sourceCs recalculatorYMaxInRange:self.graphContext.hRange];
        [[self getCoodinateByName:coordinateName]attachSeries:series];
    }
    [series.coordinate recalculatorYMaxInRange:self.graphContext.hRange];
    series.type = type;
    series.stacked = stacked;
    [self calculateColumnWidth];
    [self._symbolLayer redraw];
    [self._columnLayer redraw];
}

-(_DCCoordinateSystem*)getCoodinateByName:(NSString*)name {
    for (_DCCoordinateSystem* cs in self.coodinates) {
        if ([cs.name isEqualToString:name]) return cs;
    }
    return nil;
}

//-(DCRange*)getRangeOfAxis:(DCAxis*)axis {
//    if (axis.coordinate == DCAxisCoordinateX) {
//        return self.graphContext.hRange;
//    } else {
//        for (_DCCoordinateSystem* cs in self.coodinates) {
//            if (cs.yAxis == axis) return cs.yRange;
//        }
//        return nil;
//    }
//}

-(void)subLayerGrowthAnimationDone {
    BOOL allLayerDone = YES;
    for (CALayer* sublayer in self.layer.sublayers) {
        if ([sublayer isKindOfClass:[_DCSeriesLayer class]]) {
            if (!((_DCSeriesLayer*)sublayer).growthAnimationDone) {
                allLayerDone = NO;
                break;
            }
        }
    }
    if (allLayerDone) {
//        UIGraphicsBeginImageContext([self frame].size);
//        
//        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
//        UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        NSArray* myPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//        NSString* myDocPath = myPaths[0];
//        NSString* f = [NSString stringWithFormat:@"/%ui.png", self.hash];
//        NSString* fileName = [myDocPath stringByAppendingFormat:f];
//        [UIImagePNGRepresentation(outputImage) writeToFile:fileName atomically:NO];
        if (!(REMIsNilOrNull(self.delegate)) && [self.delegate respondsToSelector:@selector(beginAnimationDone)]) {
            [self.delegate beginAnimationDone];
        }
    }
}
@end
