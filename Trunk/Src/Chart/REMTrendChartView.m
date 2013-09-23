//
//  REMTrendChartView.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/13/13.
//
//

#import "REMTrendChart.h"

@implementation REMTrendChartView
-(REMTrendChartView*)initWithFrame:(CGRect)frame chartConfig:(REMTrendChartConfig*)config  {
    self = [super initWithFrame:frame];
    if (self) {
        CPTXYGraph *graph=[[CPTXYGraph alloc]initWithFrame:self.bounds];
        graph.backgroundColor = [UIColor redColor].CGColor;
        self.hostedGraph=graph;
        
        _verticalGridLine = config.verticalGridLine;
        _xAxisConfig = config.xAxisConfig;
        _yAxisConfig = config.yAxisConfig;
        _horizentalGridLineAmount = config.horizentalGridLineAmount;
        _horizentalReservedSpace = config.horizentalReservedSpace;
        
        [self initAxisSet];
        
    }
    return self;
}

-(void)initAxisSet {
    CPTXYGraph* graph = (CPTXYGraph*)self.hostedGraph;
    graph.plotAreaFrame.paddingBottom = self.xAxisConfig.reservedSpace.height + self.xAxisConfig.lineStyle.lineWidth;
//    graph.plotAreaFrame.paddingRight = 0;
//    graph.plotAreaFrame.paddingTop = 0;
//    graph.plotAreaFrame.paddingLeft = 38.0;
    graph.plotAreaFrame.paddingTop=18.0f;
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
    xAxis.labelTextStyle = self.xAxisConfig.textStyle;
    xAxis.axisLineStyle = self.xAxisConfig.lineStyle;
    xAxis.labelAlignment = CPTAlignmentCenter;
    [axisArray addObject:xAxis];
    xAxis.plotSpace = graph.defaultPlotSpace;

    for (int i = 0; i < self.yAxisConfig.count; i++) {
        CPTXYAxis *yAxis = [[CPTXYAxis alloc]init];
        yAxis.coordinate = CPTCoordinateY;
        yAxis.labelTextStyle = self.xAxisConfig.textStyle;
        yAxis.axisLineStyle = self.xAxisConfig.lineStyle;
        yAxis.labelAlignment = CPTAlignmentMiddle; 
        REMTrendChartAxisConfig* axConfig = [self.yAxisConfig objectAtIndex:i];
        if (i == 0) {
            graph.plotAreaFrame.paddingLeft = axConfig.reservedSpace.width + axConfig.lineStyle.lineWidth;
            yAxis.plotSpace = graph.defaultPlotSpace;
        } else {
            graph.plotAreaFrame.paddingRight = axConfig.reservedSpace.width + axConfig.lineStyle.lineWidth + graph.plotAreaFrame.paddingRight;
            CPTXYPlotSpace* plotSpace = [[CPTXYPlotSpace alloc]init];
            yAxis.plotSpace = plotSpace;
        }
        [axisArray addObject:yAxis];
    }
    
    axisSet.axes = [NSArray arrayWithArray:axisArray];
    
//    CPTXYAxis *leftY = [[CPTXYAxis alloc] init];
//    CPTXYAxis *rightY = [[CPTXYAxis alloc] init];
//    CPTXYAxis *x = [[CPTXYAxis alloc] init];
//    leftY.coordinate = CPTCoordinateY;
//    rightY.coordinate = CPTCoordinateY;
//    
////    leftY.paddingLeft = 300;
////    rightY.paddingLeft = 200;
//    CPTMutableLineStyle* axisLineStyle = [[CPTMutableLineStyle alloc]init];
//    
//    axisLineStyle.lineColor = [CPTColor colorWithCGColor:[UIColor whiteColor].CGColor];
//    leftY.axisLineStyle = axisLineStyle;
//    CPTMutableLineStyle* axisLineStyle2 = [[CPTMutableLineStyle alloc]init];
//    axisLineStyle2.lineColor = [CPTColor colorWithCGColor:[UIColor grayColor].CGColor];
//    rightY.axisLineStyle = axisLineStyle2;
//    axisSet.axes = [NSArray arrayWithObjects:x,leftY,rightY,nil];
//    rightY.orthogonalCoordinateDecimal = CPTDecimalFromFloat(10);
//    leftY.plotSpace = graph.defaultPlotSpace;
//    rightY.plotSpace = graph.defaultPlotSpace;
//    x.plotSpace = graph.defaultPlotSpace;
//
//    NSString* dateFormat = nil;
//    int amountOfY = 5;
//    //    int countOfX = 0;    // Max x value in datasource
//    double maxY = 100;    // Max y value of display points
//    double minY = 0;    // Min y value of display points
//
//    float xLabelOffset = 0;
//    float xGridlineOffset = 0;
//    int xLabelValOffset = 0;
//    
//        dateFormat = @"%d点";
//        xLabelOffset = -0.5;
//        xGridlineOffset = -0.5;
//        xLabelValOffset = 0;
//    
//    // 临时的计算x轴gridline和tick数量的方式
//    int xStep = 2;
//    NSMutableArray *xLabelLocations = [[NSMutableArray alloc]init];
//    NSMutableArray *xtickLocations = [[NSMutableArray alloc]init];
//    
//    CPTMutableTextStyle *xAxisLabelStyle = [CPTMutableTextStyle textStyle];
//    xAxisLabelStyle.fontSize = 11.0;
//    xAxisLabelStyle.color = [CPTColor whiteColor];
//    
//    int xCount = 20;
//    for (int i = 0; i < xCount + 1; i++) {
//        if (i % xStep == 0) [xLabelLocations addObject:[self makeXLabel:[NSString stringWithFormat:dateFormat, i + xLabelValOffset] location:i+xLabelOffset labelStyle: xAxisLabelStyle]];
//        [xtickLocations addObject:[NSNumber numberWithFloat:i+xGridlineOffset]];
//    }
//    NSMutableArray *ylocations = [[NSMutableArray alloc]init];
//    NSMutableArray *ytickLocations = [[NSMutableArray alloc]init];
//    
//    double yLength = maxY - minY;
//    double yInterval = 0;
//    if (yLength > 0) {
//        double mag = 1;
//        double yIntervalMag = yLength / amountOfY;
//        while (yIntervalMag > 10) {
//            yIntervalMag /= 10;
//            mag *= 10;
//        }
//        while (yIntervalMag < 1) {
//            yIntervalMag *= 10;
//            mag /= 10;
//        }
//        yInterval = ceil(yIntervalMag * 2) * mag / 2;
//    } else {
//        yInterval = 1;
//    }
//    float yRangeLength = yInterval * (amountOfY + 0.2);
//    int yLocationStart = minY / yInterval;
//    yLocationStart *= yInterval;
//    NSNumberFormatter* yFormatter = [[NSNumberFormatter alloc]init];
//    yFormatter.numberStyle = NSNumberFormatterDecimalStyle;
//    
//    
//    for (float i = yLocationStart; i < minY + yRangeLength; i = i + yInterval) {
//        NSString* ylabelText = @"999,999T";
//        CPTAxisLabel *label = [[CPTAxisLabel alloc]initWithText:ylabelText textStyle:[self yAxisLabelStyle]];
//        label.offset = 5;
//        label.tickLocation= CPTDecimalFromInt(i);
//        [ylocations addObject:label];
//        if (i != 0) [ytickLocations addObject:[NSNumber numberWithInt:i]];
//    }
    
    
    
//    CPTXYAxisSet *axisSet = (CPTXYAxisSet*)graph.axisSet;
//    CPTXYAxis* x = axisSet.xAxis;
//    CPTXYAxis* y = axisSet.yAxis;
    CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-0.5) length:CPTDecimalFromInt(12)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(30)];
//    x.axisLabels = [NSSet setWithArray:xLabelLocations];
//    x.majorTickLocations=[NSSet setWithArray:xtickLocations];
//    
//    leftY.axisLabels = [NSSet setWithArray:ylocations];
//    leftY.majorTickLocations = [NSSet setWithArray:ytickLocations];
}


- (CPTAxisLabel*)makeXLabel:(NSString*)labelText  location:(float)location labelStyle:(CPTTextStyle*)style {
    CPTAxisLabel *label = [[CPTAxisLabel alloc]initWithText:labelText textStyle:style];
    label.tickLocation= CPTDecimalFromFloat(location);
    label.offset=5;
    return label;
}
-(CPTTextStyle *)yAxisLabelStyle
{
        CPTMutableTextStyle *style = [CPTMutableTextStyle textStyle];
        style.fontSize = 12.0;
        style.color = [CPTColor whiteColor];
    
    return style;
}
@end
