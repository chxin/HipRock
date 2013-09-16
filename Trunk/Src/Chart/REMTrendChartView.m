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
    graph.plotAreaFrame.paddingRight = 0;
    graph.plotAreaFrame.paddingTop = 0;
    
    NSMutableArray* axisArray = [[NSMutableArray alloc]init];
    CPTAxis *xAxis = [[CPTAxis alloc]init];
    xAxis.coordinate = CPTCoordinateX;
    xAxis.labelTextStyle = self.xAxisConfig.textStyle;
    xAxis.axisLineStyle = self.xAxisConfig.lineStyle;
    xAxis.labelAlignment = CPTAlignmentCenter;
    [axisArray addObject:xAxis];
    xAxis.plotSpace = graph.defaultPlotSpace;
    
    for (int i = 0; i < self.yAxisConfig.count; i++) {
        CPTAxis *yAxis = [[CPTAxis alloc]init];
        yAxis.coordinate = CPTCoordinateY;
        yAxis.labelTextStyle = self.xAxisConfig.textStyle;
        yAxis.axisLineStyle = self.xAxisConfig.lineStyle;
        yAxis.labelAlignment = CPTAlignmentMiddle;
        [axisArray addObject:yAxis];
        
        REMTrendChartAxisConfig* axConfig = [self.yAxisConfig objectAtIndex:i];
        if (i == 0) {
            graph.plotAreaFrame.paddingLeft = axConfig.reservedSpace.width + axConfig.lineStyle.lineWidth;
            yAxis.plotSpace = graph.defaultPlotSpace;
        } else {
            graph.plotAreaFrame.paddingRight = axConfig.reservedSpace.width + axConfig.lineStyle.lineWidth + graph.plotAreaFrame.paddingRight;
            CPTXYPlotSpace* plotSpace = [[CPTXYPlotSpace alloc]init];
            yAxis.plotSpace = plotSpace;
        }
    }
    
    CPTAxisSet *axisSet = [[CPTAxisSet alloc] init];
    axisSet.axes = axisArray;
    graph.axisSet = axisSet;
}
@end
