//
//  REMWidgetAxisHelper.m
//  Blues
//
//  Created by 徐 子龙 on 13-7-16.
//
//

#import "REMWidgetAxisHelper.h"

@implementation REMWidgetAxisHelper

+(void)decorateAxisSet:(CPTXYGraph*)graph dataSource:(NSMutableArray*)dataSource startPointIndex:(double)xAxisStart endPointIndex:(double)xAxisLength
{
    [REMWidgetAxisHelper decorateAxisSet:graph dataSource:dataSource startPointIndex:xAxisStart endPointIndex:xAxisLength yStartZero:NO];
}


+(void)decorateAxisSet:(CPTXYGraph*)graph dataSource:(NSMutableArray*)dataSource startPointIndex:(double)xAxisStart endPointIndex:(double)xAxisLength yStartZero:(BOOL)isYStartFromZero
{
    [REMWidgetAxisHelper decorateAxisSet:graph dataSource:dataSource xStart:xAxisStart xLength:xAxisLength globalStart:0 globalRange:0 yStartZero:isYStartFromZero];
}


+(void)decorateAxisSet:(CPTXYGraph*)graph dataSource:(NSMutableArray*)dataSource xStart:(double)xAxisStart xLength:(double)xAxisLength globalStart:(double)globalXAxisStart globalRange:(double)globalXAxisLength yStartZero:(BOOL)isYStartFromZero
{
    graph.plotAreaFrame.masksToBorder=NO;
    
    graph.plotAreaFrame.paddingTop=0.0f;
    graph.plotAreaFrame.paddingRight=10.0f;
    graph.plotAreaFrame.paddingBottom=30.0f;
    graph.plotAreaFrame.paddingLeft=40.0f;
    graph.paddingBottom=40;
    //graph.hostingView.backgroundColor =[UIColor redColor];
    //graph.backgroundColor = [UIColor orangeColor].CGColor;
    const int tickOfX = 2;  // ticks amount of x-axis
    const int tickOfY = 4; // grid line amount of y-axis;
    //    const int cBoundOfY = 10;
    //    const int fBoundOfY = 6;
    
    double maxX = INT64_MIN;    // Max x value in datasource
    double minX = INT64_MAX;    // Min x value in datasource
    
    double maxDisplayY = INT64_MIN;    // Max y value of display points
    double minDisplayY = INT64_MAX;    // Min y value of display points
    
    for (int i = 0; i < [dataSource count]; i++) {
        NSMutableArray* data = [[dataSource objectAtIndex:i] objectForKey:@"data"];
        for (int j = 0; j < data.count; j++) {
            float x = [[data[j] objectForKey:@"x" ] timeIntervalSince1970];
            float y = [[data[j] objectForKey:@"y" ] floatValue];
            maxX = MAX(maxX, x);
            minX = MIN(minX, x);
            if ((xAxisStart == 0) || (x >= xAxisStart && x <= xAxisStart + xAxisLength)) {
                maxDisplayY = MAX(maxDisplayY, y);
                minDisplayY = MIN(minDisplayY, y);
            }
        }
    }
    
    if (xAxisStart == 0)
    {
        xAxisStart = minX;
        xAxisLength = maxX - minX;
    }
    
    if(isYStartFromZero)
        minDisplayY = 0;
    
    double tickIntevalOfX = xAxisLength / tickOfX;
    double tickIntevalOfY = (maxDisplayY - minDisplayY) / tickOfY;
    
    
    //double xPlotRange = maxX - minX;
    //double xPlotRangeFloor = minX;
    
    double yPlotRange = tickIntevalOfY * 0.6 + (maxDisplayY - minDisplayY);
    double yPlotRangeFloor = minDisplayY - tickIntevalOfY / 3;
    
    double xPlotRangeStart = xAxisStart, xPlotRangeLength = xAxisLength;
    double xGlobalRangeStart = minX, xGlobalRangeLength = maxX - minX;
    
    if(globalXAxisStart != 0 || globalXAxisLength!=0)
    {
        xGlobalRangeStart = globalXAxisStart;
        xGlobalRangeLength = globalXAxisLength;
    }
    
    if(isYStartFromZero) //for column chart
    {
        xPlotRangeStart = xPlotRangeStart - xPlotRangeLength/4;
        xGlobalRangeStart = xGlobalRangeStart - xGlobalRangeLength/4;
        
        xPlotRangeLength *= 1.5;
        xGlobalRangeLength *= 1.5;
    }
        
    
    
    CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(xPlotRangeStart) length:CPTDecimalFromDouble(xPlotRangeLength)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yPlotRangeFloor<0?0:yPlotRangeFloor) length:CPTDecimalFromFloat(yPlotRange)];
    plotSpace.globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(xGlobalRangeStart) length:CPTDecimalFromDouble(xGlobalRangeLength)];
    plotSpace.globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yPlotRangeFloor<0?0:yPlotRangeFloor) length:CPTDecimalFromFloat(yPlotRange)];
    
    
    CPTMutableLineStyle *hiddenLineStyle = [CPTMutableLineStyle lineStyle];
    hiddenLineStyle.lineWidth = 0;
    CPTMutableLineStyle *xTickStyle = [CPTMutableLineStyle lineStyle];
    xTickStyle.lineWidth = 1;
    xTickStyle.lineColor = [CPTColor blackColor];
    CPTXYAxisSet *axisSet = (CPTXYAxisSet*) graph.axisSet;
    CPTXYAxis* x = axisSet.xAxis;
    NSMutableArray *locations= [[NSMutableArray alloc]initWithCapacity:tickOfX];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    x.labelFormatter = formatter;
    NSMutableArray *tickLocations=[[NSMutableArray alloc]initWithCapacity:tickOfX];
    for (int i=0;i<tickOfX;i++) {
        double tickDate = minX + i * tickIntevalOfX;
        NSDate *date= [NSDate dateWithTimeIntervalSince1970:tickDate];
        NSString *text=[formatter stringFromDate:date];
        CPTAxisLabel *label = [[CPTAxisLabel alloc]initWithText:text textStyle:x.labelTextStyle];
        label.tickLocation= CPTDecimalFromInt(tickDate);
        label.offset=5;
        [locations addObject:label];
        [tickLocations addObject:[NSNumber numberWithDouble:tickDate]];
    }
    [x setLabelingPolicy:CPTAxisLabelingPolicyNone];
    x.majorTickLineStyle = xTickStyle;
    x.majorTickLength = 5;
    x.majorTickLocations=[NSSet setWithArray:tickLocations];
    x.axisLabels = [NSSet setWithArray:locations];
    x.orthogonalCoordinateDecimal=CPTDecimalFromInt(0);
    x.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0f];
    
    CPTXYAxis* y = axisSet.yAxis;
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:10];
    y.majorTickLineStyle = hiddenLineStyle;
    y.minorTickLineStyle = hiddenLineStyle;
    y.axisLineStyle = hiddenLineStyle;
    y.majorIntervalLength = CPTDecimalFromFloat(tickIntevalOfY);
    y.labelAlignment = CPTAlignmentBottom;
    
    CPTMutableLineStyle *gridLineStyle=[[CPTMutableLineStyle alloc]init];
    gridLineStyle.lineWidth=1.0f;
    gridLineStyle.lineColor=[CPTColor lightGrayColor];
    y.majorGridLineStyle = gridLineStyle;
    
    x.plotSpace = plotSpace;
    y.plotSpace = plotSpace;
}


+(void)decorateBuildingTrendAxisSet:(CPTXYGraph*)graph dataSource:(NSMutableArray*)dataSource interval:(REMRelativeTimeRangeType)t seriesIndex:(int)seriesIndex
{
    NSString* dateFormat = nil;
    if (t == Today || t == Yesterday) {
        dateFormat = @"H点";
    } else if (t == ThisMonth || t == LastMonth) {
        dateFormat = @"dd日";
    } else {
        dateFormat = @"MM月";
    }
    
    CPTMutableTextStyle* labelStyle = [[CPTMutableTextStyle alloc]init];
    labelStyle.color = [CPTColor colorWithComponentRed:255 green:255 blue:255 alpha:1];
    
    graph.plotAreaFrame.masksToBorder=NO;
//    graph.plotAreaFrame.paddingTop=0.0f;
//    graph.plotAreaFrame.paddingRight=10.0f;
//    graph.plotAreaFrame.paddingBottom=30.0f;
//    graph.plotAreaFrame.paddingLeft=40.0f;
//    graph.paddingBottom=40;
    
    double maxX = INT64_MIN;    // Max x value in datasource
    double minX = INT64_MAX;    // Min x value in datasource
    double maxDisplayY = INT64_MIN;    // Max y value of display points
    double minDisplayY = INT64_MAX;    // Min y value of display points
    NSMutableArray* data = [[dataSource objectAtIndex:seriesIndex] objectForKey:@"data"];
    for (int j = 0; j < data.count; j++) {
        float x = [[data[j] objectForKey:@"x" ] timeIntervalSince1970];
        float y = [[data[j] objectForKey:@"y" ] floatValue];
        maxX = MAX(maxX, x);
        minX = MIN(minX, x);
        maxDisplayY = MAX(maxDisplayY, y);
        minDisplayY = MIN(minDisplayY, y);
    }
    
    double yPlotRange = maxDisplayY - minDisplayY, yPlotRangeFloor = minDisplayY;
    double xPlotRangeStart = minX, xPlotRangeLength = maxX - minX;
    
    CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(xPlotRangeStart) length:CPTDecimalFromDouble(xPlotRangeLength)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yPlotRangeFloor<0?0:yPlotRangeFloor) length:CPTDecimalFromFloat(yPlotRange)];
    plotSpace.globalXRange = plotSpace.xRange;
    plotSpace.globalYRange = plotSpace.yRange;
    
    
    CPTMutableLineStyle *hiddenLineStyle = [CPTMutableLineStyle lineStyle];
    hiddenLineStyle.lineWidth = 0;
    CPTMutableLineStyle *xTickStyle = [CPTMutableLineStyle lineStyle];
    xTickStyle.lineWidth = 1;
    xTickStyle.lineColor = [CPTColor colorWithComponentRed:255 green:255 blue:255 alpha:1];
    //xTickStyle.lineCap
    CPTXYAxisSet *axisSet = (CPTXYAxisSet*) graph.axisSet;
    CPTXYAxis* x = axisSet.xAxis;
    
    NSMutableArray *locations= [[NSMutableArray alloc]initWithCapacity:data.count];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    x.labelFormatter = formatter;
    NSMutableArray *tickLocations=[[NSMutableArray alloc]initWithCapacity:data.count];
    for (int i=0;i<data.count;i++) {
        NSDate *date= [[data objectAtIndex:i] objectForKey:@"x"];
        NSString *text=[formatter stringFromDate:date];
        CPTAxisLabel *label = [[CPTAxisLabel alloc]initWithText:text textStyle:labelStyle];
        
        label.tickLocation= CPTDecimalFromInt([date timeIntervalSince1970]);
        label.offset=5;
        [locations addObject:label];
        [tickLocations addObject:[NSNumber numberWithDouble:[date timeIntervalSince1970]]];
    }
    [x setLabelingPolicy:CPTAxisLabelingPolicyNone];
    x.majorTickLineStyle = xTickStyle;
    x.majorTickLength = 5;
    x.majorTickLocations=[NSSet setWithArray:tickLocations];
    x.axisLabels = [NSSet setWithArray:locations];
    x.orthogonalCoordinateDecimal=CPTDecimalFromInt(0);
    x.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0f];
    x.axisLineStyle = xTickStyle;
    
    //x.minorTickLineStyle = xTickStyle;
    
    
    CPTXYAxis* y = axisSet.yAxis;
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:10];
    y.majorTickLineStyle = hiddenLineStyle;
    y.minorTickLineStyle = hiddenLineStyle;
    y.axisLineStyle = hiddenLineStyle;
    y.majorIntervalLength = CPTDecimalFromFloat((maxDisplayY - minDisplayY) / 5);
    
    y.labelAlignment = CPTAlignmentBottom;
    y.labelTextStyle = labelStyle;
//    NSMutableArray *yticks=[[NSMutableArray alloc]initWithCapacity:data.count];
//    for (int i=0;i<1;i++) {
//        NSDate *date= [[data objectAtIndex:i] objectForKey:@"x"];
//        [yticks addObject:[NSNumber numberWithDouble:[date timeIntervalSince1970]]];
//    }
//    x.minorTickLocations = [NSSet setWithArray:yticks];
//    //x.majorIntervalLength =
//    x.minorTickLineStyle = xTickStyle;
    //x.minorTickLength = 50;
    
    CPTMutableLineStyle *gridLineStyle=[[CPTMutableLineStyle alloc]init];
    gridLineStyle.lineWidth=1.0f;
    gridLineStyle.lineColor=[CPTColor colorWithComponentRed:255 green:255 blue:255 alpha:1];;
    y.majorGridLineStyle = gridLineStyle;
    
    
    x.plotSpace = plotSpace;
    y.plotSpace = plotSpace;
}


@end

