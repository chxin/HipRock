//
//  REMTrendChartView.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/13/13.
//
//

#import "REMTrendChart.h"

@interface REMXFormatter : NSFormatter
-(REMXFormatter*)initWithStartDate:(NSDate*)startDate dataStep:(REMEnergyStep)step interval:(int)interval;
@property (nonatomic, readonly) NSDate* startDate;
@property (nonatomic, readonly) REMEnergyStep step;
@property (nonatomic, readonly) int interval;
@end

@implementation REMXFormatter {
    NSDateFormatter *dateFormatter;
}
-(REMXFormatter*)initWithStartDate:(NSDate*)startDate dataStep:(REMEnergyStep)step interval:(int)interval {
    self = [super init];
    if (self) {
        _startDate = startDate;
        _interval = interval;
        _step = step;
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    return self;
}
- (NSString *)stringForObjectValue:(id)obj {
//    return ((NSNumber*)obj).stringValue;
    int xVal = ((NSNumber*)obj).integerValue;
    if (xVal % self.interval == 0) {
        NSDate* date = nil;
        if (self.step == REMEnergyStepHour) {
            date = [self.startDate dateByAddingTimeInterval:xVal*3600];
            if ([REMTimeHelper getHour:date] < self.interval) {
                [dateFormatter setDateFormat:@"dd日hh点"];
            } else {
                [dateFormatter setDateFormat:@"hh点"];
            }
        } else if (self.step == REMEnergyStepDay) {
            date = [self.startDate dateByAddingTimeInterval:xVal*86400];
            if ([REMTimeHelper getDay:date] <= self.interval) {
                [dateFormatter setDateFormat:@"MM月-dd日"];
            } else {
                [dateFormatter setDateFormat:@"dd日"];
            }
        } else if (self.step == REMEnergyStepWeek) {
            date = [self.startDate dateByAddingTimeInterval:xVal*604800];
            [dateFormatter setDateFormat:@"MM月-dd日"];
        } else if (self.step == REMEnergyStepMonth) {
            date = [REMTimeHelper addMonthToDate:self.startDate month:xVal];
            if ([REMTimeHelper getMonth:date] <= self.interval) {
                [dateFormatter setDateFormat:@"yyyy年-MM月"];
            } else {
                [dateFormatter setDateFormat:@"MM月"];
            }
        } else if (self.step == REMEnergyStepYear) {
            date = [REMTimeHelper addMonthToDate:self.startDate month:xVal*12];
            [dateFormatter setDateFormat:@"yyyy年"];
        }
        return [dateFormatter stringFromDate:date];
    } else {
        return @"";
    }
}
@end

@implementation REMTrendChartView {
    float maxXValOfSeries;
    float currentXLocation;
    float currentXLength;
    
    BOOL needRerenderXInterval;
}
-(REMTrendChartView*)initWithFrame:(CGRect)frame chartConfig:(REMTrendChartConfig*)config  {
    self = [super initWithFrame:frame];
    if (self) {
        self.allowPinchScaling = NO;
        maxXValOfSeries = INT32_MIN;
        needRerenderXInterval = YES;
        
        _step = config.step;
        _verticalGridLine = config.verticalGridLine;
        _xAxisConfig = config.xAxisConfig;
        _yAxisConfig = config.yAxisConfig;
        _horizentalGridLineAmount = config.horizentalGridLineAmount;
        _series = config.series;
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
        graph.backgroundColor = [UIColor redColor].CGColor;
        self.hostedGraph=graph;
        
        [self initAxisSet];
        [self renderSeries];
        [self renderRange:5 length:12];
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
    if (length == currentXLength && location == currentXLocation) return;
    CPTXYPlotSpace* majorPlotSpace = (CPTXYPlotSpace*)self.hostedGraph.defaultPlotSpace;
    if (location < [NSDecimalNumber decimalNumberWithDecimal: majorPlotSpace.globalXRange.location].floatValue) return;
    currentXLocation = location;
    currentXLength = length;
    
    [self rerenderYLabel];
    
    if (needRerenderXInterval == YES) {
        [self rerenderXLabel];
        needRerenderXInterval = NO;
    }
}

-(void)rerenderXLabel {
    CPTXYAxis* xAxis = [self.hostedGraph.axisSet.axes objectAtIndex:0];
    CPTPlotRange* xRange = [[CPTPlotRange alloc]initWithLocation:CPTDecimalFromFloat(currentXLocation) length:CPTDecimalFromFloat(currentXLength)];
    ((CPTXYPlotSpace*)(xAxis.plotSpace)).xRange = xRange;
    ((CPTXYAxis*)[self.hostedGraph.axisSet.axes objectAtIndex:1]).orthogonalCoordinateDecimal = [NSNumber numberWithFloat:currentXLocation].decimalValue;
    int xLabelInterval = [self getXInterval];
    REMXFormatter* formatter = [[REMXFormatter alloc]initWithStartDate:self.xStartDate dataStep:self.step interval:xLabelInterval];
    xAxis.labelFormatter = formatter;
    if (self.verticalGridLine) {
        xAxis.majorIntervalLength = [[NSNumber numberWithInt:1] decimalValue];
    } else {
        xAxis.majorIntervalLength = [[NSNumber numberWithInt:xLabelInterval] decimalValue];
    }
}

-(void)rerenderYLabel {
    NSMutableArray* yAxisMaxValues = [[NSMutableArray alloc]initWithCapacity:self.hostedGraph.axisSet.axes.count - 1];
    int startX = ceil(currentXLocation);
    int endX = floor(currentXLocation + currentXLength);
    for (int i = 0; i < self.series.count; i++) {
        REMTrendChartSeries* s = [self.series objectAtIndex:i];
        NSNumber* maxY = [NSNumber numberWithInt:0];
        REMTrendChartPoint* point = [s.points objectAtIndex:0];
        int j = 0;
        /*效率还可以改善*/
        for (j = 0; j < s.points.count; j++) {
            point = [s.points objectAtIndex:j];
            if (point.x < startX) continue;
            if (point.x > endX) break;
            if (point.y == nil || point.y == NULL || [point.y isLessThan:([NSNumber numberWithInt:0])]) continue;
            if (maxY.floatValue < point.y.floatValue) {
                maxY = point.y;
            }
        }
        
        if (s.yAxisIndex >= yAxisMaxValues.count) {
            [yAxisMaxValues addObject:maxY];
        } else {
            [yAxisMaxValues setObject:maxY atIndexedSubscript:s.yAxisIndex];
        }
    }
    
    
    CPTXYAxis* majorYAxis = (CPTXYAxis*)[self.hostedGraph.axisSet.axes objectAtIndex:1];
    float majorYMax = ((NSNumber*)[yAxisMaxValues objectAtIndex:0]).floatValue;
    
    
    double yInterval = 0;
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
        yInterval = ceil(yIntervalMag / mag * (self.horizentalGridLineAmount + 1)) * mag / (self.horizentalGridLineAmount + 1);
    } else {
        yInterval = 1;
    }
    majorYAxis.majorIntervalLength = CPTDecimalFromFloat(yInterval);
    ((CPTXYPlotSpace*)(majorYAxis.plotSpace)).yRange = [[CPTPlotRange alloc]initWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromInt(majorYMax + yInterval * 0.2)];
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
        xAxis.majorGridLineStyle = self.xAxisConfig.lineStyle;
    }
    CPTPlotRange* globalYRange = [[CPTPlotRange alloc]initWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromInt(INT32_MAX)];
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
            yAxis.majorGridLineStyle = yAxisConfig.lineStyle;
            graph.plotAreaFrame.paddingTop = yAxisConfig.reservedSpace.height / 2;
            graph.plotAreaFrame.paddingLeft = yAxisConfig.reservedSpace.width + yAxisConfig.lineStyle.lineWidth;
            yAxis.plotSpace = graph.defaultPlotSpace;
            yAxis.plotSpace.delegate = self;
            yAxis.plotSpace.allowsUserInteraction = YES;
            ((CPTXYPlotSpace*)yAxis.plotSpace).globalYRange = globalYRange;
        } else {
            graph.plotAreaFrame.paddingRight = yAxisConfig.reservedSpace.width + yAxisConfig.lineStyle.lineWidth + graph.plotAreaFrame.paddingRight;
            CPTXYPlotSpace* plotSpace = [[CPTXYPlotSpace alloc]init];
            yAxis.plotSpace = plotSpace;
            yAxis.plotSpace.allowsUserInteraction = NO;
            plotSpace.globalYRange = globalYRange;
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
        CPTXYAxis* yAxis = (CPTXYAxis*)[self.hostedGraph.axisSet.axes objectAtIndex:s.yAxisIndex + 1];
        s.plot.plotSpace = yAxis.plotSpace;
        REMTrendChartPoint* point = [s.points objectAtIndex:s.points.count - 1];
        maxXValOfSeries = MAX(maxXValOfSeries, point.x);
        s.plot.frame = self.hostedGraph.bounds;
        [self.hostedGraph addPlot:s.plot];
    }
    // set global X range
    CPTPlotRange* xGlobalRange = [[CPTPlotRange alloc]initWithLocation:CPTDecimalFromFloat(-0.5) length:CPTDecimalFromFloat(maxXValOfSeries+1)];
    
    CPTXYPlotSpace* majorPlotSpace = (CPTXYPlotSpace*)self.hostedGraph.defaultPlotSpace;
    majorPlotSpace.globalXRange = xGlobalRange;
}


-(CPTPlotRange*)plotSpace:(CPTXYPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate {
    if (coordinate == CPTCoordinateX) {
        CPTXYAxisSet *axisSet = (CPTXYAxisSet*)self.hostedGraph.axisSet;
        CPTXYAxis* yAxis = [axisSet.axes objectAtIndex:1];
        NSLog(@"SHOW RANGE AT:%@-%@", [NSDecimalNumber decimalNumberWithDecimal:newRange.location].stringValue,[NSDecimalNumber decimalNumberWithDecimal:yAxis.orthogonalCoordinateDecimal].stringValue);
        yAxis.orthogonalCoordinateDecimal = newRange.location;
        [self renderRange:[NSDecimalNumber decimalNumberWithDecimal: newRange.location].floatValue length:[NSDecimalNumber decimalNumberWithDecimal: newRange.length].floatValue];
    } else if (coordinate == CPTCoordinateY) {
        return space.yRange; // disable y scrolling here.
    }
    
    return newRange;
}
@end
