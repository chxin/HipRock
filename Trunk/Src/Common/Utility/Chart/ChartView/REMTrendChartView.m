/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTrendChartView.m
 * Created      : Zilong-Oscar.Xu on 9/13/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMChartHeader.h"

@implementation REMTrendChartView {
    float maxXValOfSeries;
    float currentXLocation;
    float currentXLength;
    
    BOOL isTheFirstRender;
    float xStableStartPoint; // 弹性稳定区域的x轴起点
    float xStableEndPoint;   // 弹性稳定区域的x轴终点
    float xUnstableStartPoint; // 弹性区域不稳定的x轴起点
    float xUnstableEndPoint; // 弹性区域不稳定的x轴起点
    BOOL suspendDraw;
    
    BOOL isHighlightedStatus;
    NSNumber* highlightedX; // 上一个高亮的点的X轴位置
}

-(void)setNeedsDisplay {
    if (suspendDraw) return;
    [super setNeedsDisplay];
//    NSLog(@"%i", redrawCount);
//    redrawCount++;
}

//-(NSDictionary*)getSa:(REMTrendChartSeries*)s xInCoor:(NSNumber*)xInCoor {
//    NSArray* sampleData = [s getCurrentRangeSource];
//    for (NSDictionary* sPoint in sampleData) {
//        NSNumber* xVal = sPoint[@"x"];
//        if (fabs(xVal.doubleValue + 0.5 - xInCoor.doubleValue) <= 0.5) {
//            return sPoint;
//        }
//    }
//    return nil;
//}

-(REMTrendChartView*)initWithFrame:(CGRect)frame chartConfig:(REMTrendChartConfig*)config  {
    self = [super initWithFrame:frame];
    if (self) {
        self.collapsesLayers = NO;
        self.allowPinchScaling = NO;
        self.userInteractionEnabled = config.userInteraction;
        if (self.userInteractionEnabled) {
            UILongPressGestureRecognizer* longPressGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
            [self addGestureRecognizer:longPressGR];
        }
        maxXValOfSeries = INT32_MIN;
        isTheFirstRender = YES;
        
        _step = config.step;
        _verticalGridLine = config.verticalGridLine;
        _xAxisConfig = config.xAxisConfig;
        _yAxisConfig = config.yAxisConfig;
        _horizentalGridLineAmount = config.horizentalGridLineAmount;
        _series = config.series;
        _xGlobalLength = config.xGlobalLength;
        
        CPTXYGraph *graph=[[CPTXYGraph alloc]initWithFrame:self.bounds];
        self.hostedGraph=graph;
        
        [self initAxisSet];
        [self renderSeries];
    }
    return self;
}

/*
 * 根据x=1的点和x=2点之间的距离，计算xLabel需要的间隔。
 */
-(int)getXInterval {
    const int minDistance = 80;
    CPTXYPlotSpace* plotSpace = (CPTXYPlotSpace*)self.hostedGraph.defaultPlotSpace;
    double plotPoint1 = 1;
    double plotPoint2 = 2;
    CGPoint point1 = [plotSpace plotAreaViewPointForDoublePrecisionPlotPoint:&plotPoint1];
    CGPoint point2 = [plotSpace plotAreaViewPointForDoublePrecisionPlotPoint:&plotPoint2];
    
    float distanceNearbyPoints = point2.x - point1.x;
    if (distanceNearbyPoints >= minDistance) {
        return 1;
    } else {
        return ceil(minDistance / distanceNearbyPoints);
    }
}

-(void)renderRange:(float)location length:(float)length {
    if (self.series.count == 0) return;
    if (length <= 0) return;
    location -= 0.5;
    if (length == currentXLength && location == currentXLocation) return;
    
    if (location < [NSDecimalNumber numberWithFloat: xStableStartPoint].floatValue) return;
    currentXLocation = location;
    currentXLength = length;
    
    CPTPlotRange* xRange = [[CPTPlotRange alloc]initWithLocation:CPTDecimalFromFloat(currentXLocation) length:CPTDecimalFromFloat(currentXLength)];
    ((CPTXYPlotSpace*)self.hostedGraph.defaultPlotSpace).xRange = xRange;
    for (REMTrendChartSeries* s in self.series) {
        s.visableRange = NSMakeRange(currentXLocation <= 0 ? 0 : floor(currentXLocation), ceil(currentXLength));
    }
    
    [self rerenderYLabel];

    if (isTheFirstRender == YES) {
        [self rerenderXLabel];
        isTheFirstRender = NO;
    }
}

-(void)rerenderXLabel {
    CPTXYAxis* xAxis = [self.hostedGraph.axisSet.axes objectAtIndex:0];
    ((CPTXYAxis*)[self.hostedGraph.axisSet.axes objectAtIndex:1]).orthogonalCoordinateDecimal = [NSNumber numberWithFloat:currentXLocation].decimalValue;
    int xLabelInterval = [self getXInterval];
//    REMXFormatter* formatter = [[REMXFormatter alloc]initWithStartDate:self.xStartDate dataStep:self.step interval:xLabelInterval length:[NSDecimalNumber decimalNumberWithDecimal:((CPTXYPlotSpace*)xAxis.plotSpace).globalXRange.length].floatValue];
//    xAxis.labelFormatter = formatter;
    if ([xAxis.labelFormatter isKindOfClass:([REMXFormatter class])]) {
        ((REMXFormatter*)xAxis.labelFormatter).interval = xLabelInterval;
    }
    if (self.verticalGridLine) {
        xAxis.majorIntervalLength = [[NSNumber numberWithInt:1] decimalValue];
    } else {
        xAxis.majorIntervalLength = [[NSNumber numberWithInt:xLabelInterval] decimalValue];
    }
}

-(void)rerenderYLabel {
    if (self.series.count == 0) return;
    NSMutableArray* yAxisMaxValues = [[NSMutableArray alloc]initWithCapacity:self.hostedGraph.axisSet.axes.count - 1];
    for (int i = 0; i < self.series.count; i++) {
        REMTrendChartSeries* s = [self.series objectAtIndex:i];
        NSNumber* maxY = [s maxYInCache];
        if (s.yAxisIndex >= yAxisMaxValues.count) {
            [yAxisMaxValues addObject:maxY];
        } else {
            if ([maxY isGreaterThan:[yAxisMaxValues objectAtIndex:s.yAxisIndex]])[yAxisMaxValues setObject:maxY atIndexedSubscript:s.yAxisIndex];
        }
    }
    
    
    float majorYMax = ((NSNumber*)[yAxisMaxValues objectAtIndex:0]).floatValue;
    
    double yMajorInterval = 0;
    if (majorYMax > 0) {
//        double yIntervalMag = majorYMax / self.horizentalGridLineAmount;
//        double mag = 1;
//        if (yIntervalMag > 10) {
//            int yIntervalFLOOR = floor(yIntervalMag);
//            NSUInteger digitalOfYInterval = ((NSString*)[NSString stringWithFormat:@"%i", yIntervalFLOOR]).length;
//            mag = pow(10, digitalOfYInterval-1);
//        } else if (yIntervalMag < 1) {
//            while (yIntervalMag < 1) {
//                mag /= 10;
//            }
//        }
//        yMajorInterval = [self roundYInterval:(majorYMax / self.horizentalGridLineAmount / mag)] * mag;
        yMajorInterval = [self getYInterval:majorYMax intervalCount:self.horizentalGridLineAmount];
        [self updateYInterval:yMajorInterval majorYMax:majorYMax yAxisMaxValues:yAxisMaxValues];
    } else if (isTheFirstRender) {
        yMajorInterval = 1;
        majorYMax = yMajorInterval * self.horizentalGridLineAmount;
        [self updateYInterval:yMajorInterval majorYMax:majorYMax yAxisMaxValues:yAxisMaxValues];
        isTheFirstRender = NO;
    }
}

-(float)roundYInterval:(float)yInterval {
    for (float i = 1.0; i <= 10; i=i+0.1) {
        if (yInterval <= i) {
            return i;
        }
    }
    return 10;
}

-(float)getYInterval:(float)yMax intervalCount:(uint)intervalCount {
    if (yMax <= 0) return 1;
    
    double yIntervalMag = yMax / intervalCount;
    double mag = 1;
    if (yIntervalMag > 10) {
        int yIntervalFLOOR = floor(yIntervalMag);
        NSUInteger digitalOfYInterval = ((NSString*)[NSString stringWithFormat:@"%i", yIntervalFLOOR]).length;
        mag = pow(10, digitalOfYInterval-1);
    } else if (yIntervalMag < 1) {
        while (yIntervalMag < 1) {
            mag /= 10;
            yIntervalMag*=10;
        }
    }
    return [self roundYInterval:(yMax / intervalCount / mag)] * mag;
}


-(void)updateYInterval:(float)yMajorInterval majorYMax:(float)majorYMax yAxisMaxValues:(NSArray*)yAxisMaxValues {
    CPTXYAxis* majorYAxis = (CPTXYAxis*)[self.hostedGraph.axisSet.axes objectAtIndex:1];
    majorYAxis.majorIntervalLength = CPTDecimalFromFloat(yMajorInterval);
    float yMajorLength = yMajorInterval * (self.horizentalGridLineAmount + 0.2);
    ((CPTXYPlotSpace*)(majorYAxis.plotSpace)).yRange = [[CPTPlotRange alloc]initWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromInt(yMajorLength)];
    
    NSMutableArray* scaleArray = [[NSMutableArray alloc]init];
    [scaleArray addObject:@(1)];
    // 绘制其他Y轴
    for (uint i = 2; i < self.hostedGraph.axisSet.axes.count; i++) {
        CPTXYAxis* yAxis =[self.hostedGraph.axisSet.axes objectAtIndex:i];
        float yMax = ((NSNumber*)[yAxisMaxValues objectAtIndex:i-1]).floatValue;
        float interval = [self getYInterval:yMax intervalCount:self.horizentalGridLineAmount];
        double scale = interval / yMajorInterval;
        [scaleArray addObject:@(scale)];
        
        ((REMYFormatter*)yAxis.labelFormatter).yScale = @(scale);
        yAxis.majorIntervalLength = majorYAxis.majorIntervalLength;
    }
    
    for (int i = 0; i < self.hostedGraph.allPlots.count; i++) {
        REMTrendChartSeries* s = self.series[i];
        s.yScale = scaleArray[s.yAxisIndex];
    }
}

-(void)initAxisSet {
    CPTXYGraph* graph = (CPTXYGraph*)self.hostedGraph;
    graph.plotAreaFrame.paddingBottom = self.xAxisConfig.reservedSpace.height + self.xAxisConfig.lineStyle.lineWidth;
    graph.plotAreaFrame.paddingRight=0.0f;
    graph.plotAreaFrame.paddingLeft=0.0f;
    graph.paddingTop = 0;
    graph.paddingLeft = 0;
    graph.paddingBottom = 0.0;
    graph.paddingRight = 0.0;
    
    CPTAxisSet *axisSet = graph.axisSet;
    NSMutableArray* axisArray = [[NSMutableArray alloc]init];
    CPTXYAxis *xAxis = [[CPTXYAxis alloc]init];
    xAxis.coordinate = CPTCoordinateX;
    xAxis.majorTickLength = 0;
    xAxis.minorTickLength = 0;
    xAxis.labelTextStyle = self.xAxisConfig.textStyle;
    xAxis.axisLineStyle = self.xAxisConfig.lineStyle;
    xAxis.labelFormatter = self.xAxisConfig.labelFormatter;
    xAxis.labelAlignment = CPTAlignmentCenter;
    [axisArray addObject:xAxis];
    xAxis.plotSpace = graph.defaultPlotSpace;
    if (self.verticalGridLine == YES) {
        xAxis.majorGridLineStyle = self.xAxisConfig.gridlineStyle;
    }
    CPTPlotRange* globalYRange = [[CPTPlotRange alloc]initWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromInt(INT32_MAX)];
    float reserveredRightSpace = 0;
    for (int i = 0; i < self.yAxisConfig.count; i++) {
        REMTrendChartAxisConfig* yAxisConfig = [self.yAxisConfig objectAtIndex:i];
        CPTXYAxis *yAxis = [[CPTXYAxis alloc]init];
        yAxis.coordinate = CPTCoordinateY;
        yAxis.majorTickLength = 0;
        yAxis.minorTickLength = 0;
        yAxis.labelTextStyle = yAxisConfig.textStyle;
        yAxis.axisLineStyle = yAxisConfig.lineStyle;
        yAxis.labelFormatter = yAxisConfig.labelFormatter;
        yAxis.labelAlignment = CPTAlignmentMiddle;
        if (i == 0) {
            yAxis.majorGridLineStyle = yAxisConfig.gridlineStyle;
            graph.plotAreaFrame.paddingTop = yAxisConfig.reservedSpace.height / 2;
            graph.plotAreaFrame.paddingLeft = yAxisConfig.reservedSpace.width + yAxisConfig.lineStyle.lineWidth;
            yAxis.plotSpace = graph.defaultPlotSpace;
            yAxis.plotSpace.delegate = self;
            yAxis.plotSpace.allowsUserInteraction = self.userInteractionEnabled;
            yAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0];
            ((CPTXYPlotSpace*)yAxis.plotSpace).globalYRange = globalYRange;
        } else {
            graph.plotAreaFrame.paddingRight = yAxisConfig.reservedSpace.width + yAxisConfig.lineStyle.lineWidth + graph.plotAreaFrame.paddingRight;
//            CPTXYPlotSpace* plotSpace = [[CPTXYPlotSpace alloc]init];
//            yAxis.plotSpace = plotSpace;
            yAxis.plotSpace = self.hostedGraph.defaultPlotSpace;
            yAxis.tickDirection = CPTSignPositive;
            yAxis.axisConstraints = [CPTConstraints constraintWithUpperOffset:reserveredRightSpace];
            reserveredRightSpace-=yAxisConfig.reservedSpace.width;
//            yAxis.plotSpace.allowsUserInteraction = NO;
//            [self.hostedGraph addPlotSpace:plotSpace];
        }
        yAxis.labelingPolicy = CPTAxisLabelingPolicyFixedInterval;
        [axisArray addObject:yAxis];
    }
    axisSet.axes = axisArray;
}

/*
 * 将series加入图形，并且设置maxXValOfSeries
 */
- (void)renderSeries {
    for (int i = 0; i < self.series.count; i++) {
        REMTrendChartSeries* s = [self.series objectAtIndex:i];
        CPTPlotSpace* plotSpace = ((CPTXYAxis*)[self.hostedGraph.axisSet.axes objectAtIndex:s.yAxisIndex + 1]).plotSpace;
        maxXValOfSeries = MAX(maxXValOfSeries, s.maxX);
        [s beforePlotAddToGraph:self.hostedGraph seriesList:self.series selfIndex:i];
        [self.hostedGraph addPlot:[s getPlot] toPlotSpace:plotSpace];
    }
    float xLength = (self.xGlobalLength == nil) ? maxXValOfSeries : self.xGlobalLength.floatValue;
    
    xStableStartPoint = -0.5;
    xStableEndPoint = xLength;
    xUnstableStartPoint = -100;
    xUnstableEndPoint = xLength + 200;
    
    CPTXYPlotSpace* majorPlotSpace = (CPTXYPlotSpace*)self.hostedGraph.defaultPlotSpace;
    majorPlotSpace.globalXRange = [[CPTPlotRange alloc]initWithLocation:CPTDecimalFromFloat(xUnstableStartPoint) length:CPTDecimalFromFloat(xUnstableEndPoint)];
}


-(CPTPlotRange*)plotSpace:(CPTXYPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate {
    if (coordinate == CPTCoordinateX) {
        if (isHighlightedStatus) {
            return space.xRange;
        } else {
            id s, e;
            
            REMChartDataProcessor* processor = self.series.count > 0 ? ((REMTrendChartSeries*) self.series[0]).dataProcessor: nil;
            if (processor) {
                s = [processor deprocessX:newRange.locationDouble];
                e = [processor deprocessX:newRange.lengthDouble+newRange.locationDouble];
            } else {
                s = [NSDecimalNumber decimalNumberWithDecimal:newRange.location];
                e = @([s doubleValue] + [NSDecimalNumber decimalNumberWithDecimal:newRange.length].doubleValue);
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(willRangeChange:end:)]) {
                [self.delegate willRangeChange:s end:e];
            }
            suspendDraw = YES;

            float newRangeStart = [NSDecimalNumber decimalNumberWithDecimal:newRange.location].floatValue;
            float newRangeLength = [NSDecimalNumber decimalNumberWithDecimal:newRange.length].floatValue;
            if (newRangeStart >= xStableStartPoint && newRangeStart + newRangeLength <= xStableEndPoint) {
                [self renderRange:newRangeStart length:newRangeLength];
            }
            suspendDraw = NO;
            return newRange;
        }
    } else if (coordinate == CPTCoordinateY) {
        return space.yRange; // disable y scrolling here.
    }
    return nil;
}

-(BOOL)plotSpace:(CPTXYPlotSpace *)space shouldHandlePointingDeviceUpEvent:(CPTNativeEvent *)event atPoint:(CGPoint)point {
    CPTPlotRange* newRange = space.xRange;
    
    float newRangeLocation = [NSDecimalNumber decimalNumberWithDecimal:newRange.location].floatValue;
    float newRangeLength = [NSDecimalNumber decimalNumberWithDecimal:newRange.length].floatValue;
    CPTPlotRange* animateRange = nil;
    if (newRangeLocation < xStableStartPoint) {
        animateRange = [[CPTPlotRange alloc]initWithLocation:[NSDecimalNumber numberWithFloat:xStableStartPoint].decimalValue length:newRange.length];
    } else if (newRangeLocation + newRangeLength > xStableEndPoint) {
        animateRange = [[CPTPlotRange alloc]initWithLocation:[NSDecimalNumber numberWithFloat:(xStableEndPoint-newRangeLength+xStableStartPoint)].decimalValue length:newRange.length];
    }
    if (animateRange != nil) {
        currentXLocation = animateRange.locationDouble;
        currentXLength = animateRange.lengthDouble;
        for (REMTrendChartSeries* s in self.series) {
            s.visableRange = NSMakeRange(animateRange.locationDouble, animateRange.lengthDouble);
        }
        for (CPTPlotSpace* s in self.hostedGraph.allPlotSpaces) {
            [CPTAnimation animate:s property:@"xRange" fromPlotRange:newRange toPlotRange:animateRange duration:0.2 withDelay:0 animationCurve:CPTAnimationCurveSinusoidalOut delegate:self];
        }
    }
    return YES;
}

-(void)setSeriesHiddenAtIndex:(NSUInteger)seriesIndex hidden:(BOOL)hidden {
    if (seriesIndex >= self.series.count) return;
    REMTrendChartSeries* s = self.series[seriesIndex];
    if ([s getPlot].hidden != hidden) {
        [[s getPlot] setHidden:hidden];
    }
}

-(void)cancelToolTipStatus {
    for (REMTrendChartSeries* s in self.series) {
        [s dehighlight];
    }
    isHighlightedStatus = NO;
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (isHighlightedStatus) {
        CPTXYPlotSpace* plotSpace = (CPTXYPlotSpace*)self.hostedGraph.defaultPlotSpace;
        NSDecimal pressedPoint[2];
        [plotSpace plotPoint:pressedPoint forPlotAreaViewPoint:[[touches anyObject] locationInView:self]];
        
        double xInCoor = [NSDecimalNumber decimalNumberWithDecimal:pressedPoint[0]].doubleValue;
        
        [self focusPointAtX:xInCoor];
    } else {
        [super touchesMoved:touches withEvent:event];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (isHighlightedStatus) {
        CPTXYPlotSpace* plotSpace = (CPTXYPlotSpace*)self.hostedGraph.defaultPlotSpace;
        NSDecimal pressedPoint[2];
        [plotSpace plotPoint:pressedPoint forPlotAreaViewPoint:[[touches anyObject] locationInView:self]];
        
        double xInCoor = [NSDecimalNumber decimalNumberWithDecimal:pressedPoint[0]].doubleValue;
        
        [self focusPointAtX:xInCoor];
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!isHighlightedStatus && self.delegate && [self.delegate respondsToSelector:@selector(touchEndedInNormalStatus:end:)]) {
        id s, e;
        
        REMChartDataProcessor* processor = self.series.count > 0 ? ((REMTrendChartSeries*) self.series[0]).dataProcessor: nil;
        CPTPlotRange* newRange = ((CPTXYPlotSpace*)self.hostedGraph.defaultPlotSpace).xRange;
        if (processor) {
            s = [processor deprocessX:newRange.locationDouble];
            e = [processor deprocessX:newRange.lengthDouble+newRange.locationDouble];
        } else {
            s = [NSDecimalNumber decimalNumberWithDecimal:newRange.location];
            e = @([s doubleValue] + [NSDecimalNumber decimalNumberWithDecimal:newRange.length].doubleValue);
        }
        [self.delegate touchEndedInNormalStatus:s end:e];
    }
    [super touchesEnded:touches withEvent:event];
}

-(void)focusPointAtX:(double)xInCoor {
    NSDecimal pressedPoint[2];
    CPTXYPlotSpace* plotSpace = (CPTXYPlotSpace*)self.hostedGraph.defaultPlotSpace;
    NSMutableArray* points = [[NSMutableArray alloc]init];
    NSMutableArray* colors = [[NSMutableArray alloc]init];
    NSMutableArray* targetNames = [[NSMutableArray alloc]init];
    [plotSpace plotPoint:pressedPoint forPlotAreaViewPoint:CGPointMake(0, 0)];
    
    BOOL highlightedXChanged = NO;
    for(NSUInteger i = 0; i < self.series.count; i++) {
        REMTrendChartSeries* s = self.series[i];
        NSUInteger index = [s getIndexOfCachePointByCoordinate:xInCoor]; // MAX(0, round(xInCoor.doubleValue-0.5) - ceil(basePoint.doubleValue));
        NSDictionary* cachedPoint = [[s getCurrentRangeSource] objectAtIndex:index];
        if (i == 0) {
            NSNumber* xVal = cachedPoint[@"x"];
            if (highlightedX == nil || ![xVal isEqualToNumber:highlightedX]) {
                highlightedX = xVal;
                highlightedXChanged = YES;
            }
        }
        if (highlightedXChanged) {
            if (cachedPoint) {
                [points addObject:cachedPoint[@"enenrgydata"]];
            } else {
                [points addObject:[NSNull null]];
            }
            
            [colors addObject:[s getSeriesColor]];
            
            if (s.target) {
                [targetNames addObject:s.target.name];
            } else {
                if (cachedPoint) [targetNames addObject:cachedPoint[@"targetname"]];
                else [targetNames addObject:[NSNull null]];
            }
            
            [s highlightAt:index];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(highlightPoints:colors:names:)] && highlightedXChanged) {
        [self.delegate highlightPoints:points colors:colors names:targetNames];
    }
}

-(void)longPress:(UILongPressGestureRecognizer*)recognizer {
    UIGestureRecognizerState gstate = recognizer.state;
    if (gstate == UIGestureRecognizerStateBegan) {
        isHighlightedStatus = YES;
        CPTXYPlotSpace* plotSpace = (CPTXYPlotSpace*)self.hostedGraph.defaultPlotSpace;
        NSDecimal pressedPoint[2];
        [plotSpace plotPoint:pressedPoint forPlotAreaViewPoint:[recognizer locationInView:self]];
        
        double xInCoor = [NSDecimalNumber decimalNumberWithDecimal:pressedPoint[0]].doubleValue;
        
        [self focusPointAtX:xInCoor];
    }
}

@end
