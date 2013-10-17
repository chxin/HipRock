//
//  REMTrendChartView.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/13/13.
//
//

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
    
    CPTAnimationOperation* elasticAnimation;
}

-(REMTrendChartView*)initWithFrame:(CGRect)frame chartConfig:(REMTrendChartConfig*)config  {
    self = [super initWithFrame:frame];
    if (self) {
        self.allowPinchScaling = NO;
        self.userInteractionEnabled = config.userInteraction;
        maxXValOfSeries = INT32_MIN;
        isTheFirstRender = YES;
        
        _step = config.step;
        _verticalGridLine = config.verticalGridLine;
        _xAxisConfig = config.xAxisConfig;
        _yAxisConfig = config.yAxisConfig;
        _horizentalGridLineAmount = config.horizentalGridLineAmount;
        _series = config.series;
        _xGlobalLength = config.xGlobalLength;
        if (config.xStartDate == nil) {
            _xStartDate = ((REMTrendChartSeries*)[self.series objectAtIndex:0]).startDate;
            for (int i = 1; i < self.series.count; i++) {
                REMTrendChartSeries* s = [self.series objectAtIndex:i];
                if (s.startDate < _xStartDate) {
                    _xStartDate = s.startDate;
                }
            }
        } else {
            _xStartDate = config.xStartDate;
        }
        
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
    if (length <= 0) return;
    location -= 0.5;
    if (length == currentXLength && location == currentXLocation) return;
//    CPTXYPlotSpace* majorPlotSpace = (CPTXYPlotSpace*)self.hostedGraph.defaultPlotSpace;
    if (location < [NSDecimalNumber numberWithFloat: xStableStartPoint].floatValue) return;
    currentXLocation = location;
    currentXLength = length;
    
    [self rerenderYLabel];
    
    if (isTheFirstRender == YES) {
        [self rerenderXLabel];
        isTheFirstRender = NO;
    }
}

-(void)rerenderXLabel {
    CPTXYAxis* xAxis = [self.hostedGraph.axisSet.axes objectAtIndex:0];
    CPTPlotRange* xRange = [[CPTPlotRange alloc]initWithLocation:CPTDecimalFromFloat(currentXLocation) length:CPTDecimalFromFloat(currentXLength)];
//    ((CPTXYPlotSpace*)(xAxis.plotSpace)).xRange = xRange;
    for (int i = 1; i < self.hostedGraph.axisSet.axes.count; i++) {
        CPTXYPlotSpace* pSpace = (CPTXYPlotSpace*)((CPTXYAxis*)[self.hostedGraph.axisSet.axes objectAtIndex:i]).plotSpace;
        pSpace.xRange = xRange;
    }
    ((CPTXYAxis*)[self.hostedGraph.axisSet.axes objectAtIndex:1]).orthogonalCoordinateDecimal = [NSNumber numberWithFloat:currentXLocation].decimalValue;
    int xLabelInterval = [self getXInterval];
    REMXFormatter* formatter = [[REMXFormatter alloc]initWithStartDate:self.xStartDate dataStep:self.step interval:xLabelInterval length:[NSDecimalNumber decimalNumberWithDecimal:((CPTXYPlotSpace*)xAxis.plotSpace).globalXRange.length].floatValue];
    xAxis.labelFormatter = formatter;
    if (self.verticalGridLine) {
        xAxis.majorIntervalLength = [[NSNumber numberWithInt:1] decimalValue];
    } else {
        xAxis.majorIntervalLength = [[NSNumber numberWithInt:xLabelInterval] decimalValue];
    }
}

-(void)rerenderYLabel {
    NSMutableArray* yAxisMaxValues = [[NSMutableArray alloc]initWithCapacity:self.hostedGraph.axisSet.axes.count - 1];
    int startX = floor(currentXLocation);
    int endX = ceil(currentXLocation + currentXLength);
    for (int i = 0; i < self.series.count; i++) {
        REMTrendChartSeries* s = [self.series objectAtIndex:i];
        NSNumber* maxY = [NSNumber numberWithInt:0];
        NSDate* xStartDate = [s.dataProcessor deprocessX:startX startDate:s.startDate step:s.step];
        NSDate* xEndDate = [s.dataProcessor deprocessX:endX startDate:s.startDate step:s.step];
        /*效率还可以改善*/
        for (int j = 0; j < s.energyData.count; j++) {
            REMEnergyData* point = [s.energyData objectAtIndex:j];
            if ([point.localTime timeIntervalSinceDate:xStartDate] < 0) continue;
            if ([point.localTime timeIntervalSinceDate:xEndDate] > 0) break;
            NSNumber* yVal = [s.dataProcessor processY:point.dataValue startDate:s.startDate step:s.step];
            if (yVal == nil || yVal == NULL || [yVal isLessThan:([NSNumber numberWithInt:0])]) continue;
            if (maxY.floatValue < yVal.floatValue) {
                maxY = yVal;
            }
        }
        
        if (s.yAxisIndex >= yAxisMaxValues.count) {
            [yAxisMaxValues addObject:maxY];
        } else {
            [yAxisMaxValues setObject:maxY atIndexedSubscript:s.yAxisIndex];
        }
    }
    
    
    float majorYMax = ((NSNumber*)[yAxisMaxValues objectAtIndex:0]).floatValue;
    
    double yMajorInterval = 0;
    if (majorYMax > 0) {
        double yIntervalMag = majorYMax / self.horizentalGridLineAmount;
        double mag = 1;
        if (yIntervalMag > 10) {
            int yIntervalFLOOR = floor(yIntervalMag);
            NSUInteger digitalOfYInterval = ((NSString*)[NSString stringWithFormat:@"%i", yIntervalFLOOR]).length;
            mag = pow(10, digitalOfYInterval);
        } else if (yIntervalMag < 1) {
            while (yIntervalMag < 1) {
                mag /= 10;
            }
        }
        yMajorInterval = ceil(yIntervalMag / mag * (self.horizentalGridLineAmount + 1)) * mag / (self.horizentalGridLineAmount + 1);
        [self updateYInterval:yMajorInterval majorYMax:majorYMax yAxisMaxValues:yAxisMaxValues];
    } else if (isTheFirstRender) {
        yMajorInterval = 1;
        majorYMax = yMajorInterval * self.horizentalGridLineAmount;
        [self updateYInterval:yMajorInterval majorYMax:majorYMax yAxisMaxValues:yAxisMaxValues];
        isTheFirstRender = NO;
    }
}



-(void)updateYInterval:(float)yMajorInterval majorYMax:(float)majorYMax yAxisMaxValues:(NSArray*)yAxisMaxValues {
    CPTXYAxis* majorYAxis = (CPTXYAxis*)[self.hostedGraph.axisSet.axes objectAtIndex:1];
    majorYAxis.majorIntervalLength = CPTDecimalFromFloat(yMajorInterval);
    float yMajorLength = majorYMax + yMajorInterval * 0.2;
    ((CPTXYPlotSpace*)(majorYAxis.plotSpace)).yRange = [[CPTPlotRange alloc]initWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromInt(yMajorLength)];
    
    // 绘制其他Y轴
    for (uint i = 2; i < self.hostedGraph.axisSet.axes.count; i++) {
        CPTXYAxis* yAxis =[self.hostedGraph.axisSet.axes objectAtIndex:i];
        CPTXYPlotSpace* thePlotspace = (CPTXYPlotSpace*)yAxis.plotSpace;
        
        float yMax = ((NSNumber*)[yAxisMaxValues objectAtIndex:i-1]).floatValue;
        if (yMax == majorYMax) {
            yAxis.majorIntervalLength = majorYAxis.majorIntervalLength;
            thePlotspace.yRange = ((CPTXYPlotSpace*)(majorYAxis.plotSpace)).yRange;
        } else if (yMax > majorYMax) {
            yAxis.majorIntervalLength = CPTDecimalFromFloat(yMajorInterval * ceil(yMax / majorYMax));
            thePlotspace.yRange = [[CPTPlotRange alloc]initWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromInt(yMajorLength * ceil(yMax / majorYMax))];
        } else {
            yAxis.majorIntervalLength = CPTDecimalFromFloat(yMajorInterval * ceil(majorYMax / yMax));
            thePlotspace.yRange = [[CPTPlotRange alloc]initWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromInt(yMajorLength * ceil(majorYMax / yMax))];
        }
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
            CPTXYPlotSpace* plotSpace = [[CPTXYPlotSpace alloc]init];
            yAxis.plotSpace = plotSpace;
            yAxis.tickDirection = CPTSignPositive;
            yAxis.axisConstraints = [CPTConstraints constraintWithUpperOffset:reserveredRightSpace];
            reserveredRightSpace-=yAxisConfig.reservedSpace.width;
            yAxis.plotSpace.allowsUserInteraction = NO;
            [self.hostedGraph addPlotSpace:plotSpace];
        }
        yAxis.labelFormatter = [[REMYFormatter alloc]init];
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
    xStableEndPoint = xLength + 1;
    xUnstableStartPoint = -100;
    xUnstableEndPoint = xLength + 200;
    
    CPTXYPlotSpace* majorPlotSpace = (CPTXYPlotSpace*)self.hostedGraph.defaultPlotSpace;
    majorPlotSpace.globalXRange = [[CPTPlotRange alloc]initWithLocation:CPTDecimalFromFloat(xUnstableStartPoint) length:CPTDecimalFromFloat(xUnstableEndPoint)];
}


-(CPTPlotRange*)plotSpace:(CPTXYPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate {
    if (coordinate == CPTCoordinateX) {
        // Move other plotspace with the default plotspace
        for (int i = 2; i < self.hostedGraph.axisSet.axes.count; i++) {
            CPTXYPlotSpace* pSpace = (CPTXYPlotSpace*)((CPTXYAxis*)[self.hostedGraph.axisSet.axes objectAtIndex:i]).plotSpace;
            pSpace.xRange = newRange;
        }
        float newRangeStart = [NSDecimalNumber decimalNumberWithDecimal:newRange.location].floatValue;
        float newRangeLength = [NSDecimalNumber decimalNumberWithDecimal:newRange.length].floatValue;
        if (newRangeStart >= xStableStartPoint && newRangeStart + newRangeLength <= xStableEndPoint) {
            [self renderRange:newRangeStart length:newRangeLength];
        }
    } else if (coordinate == CPTCoordinateY) {
        return space.yRange; // disable y scrolling here.
    }
    
    return newRange;
}

//-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDownEvent:(UIEvent *)event atPoint:(CGPoint)point {
//    if (elasticAnimation != nil) return NO;
//    else return YES;
//}

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
//    if (elasticAnimation != nil) {
//        [[CPTAnimation sharedInstance] removeAnimationOperation:elasticAnimation];
//    }
    if (animateRange != nil) {
//        elasticAnimation
        elasticAnimation = [CPTAnimation animate:space property:@"xRange" fromPlotRange:newRange toPlotRange:animateRange duration:0.2 withDelay:0 animationCurve:CPTAnimationCurveSinusoidalOut delegate:self];
    }
    return YES;
}

-(void)animationDidFinish:(CPTAnimationOperation *)operation {
    if (operation == elasticAnimation) {
        elasticAnimation = nil;
    }
}


@end
