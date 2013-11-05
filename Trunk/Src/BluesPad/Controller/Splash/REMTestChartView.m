//
//  REMTestChartView.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/4/13.
//
//

#import "REMTestChartView.h"
#import "REMChartHeader.h"

@implementation REMTestChartView {
    NSUInteger currentLocation;
    NSUInteger xLength;
    NSUInteger seriesAmount;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        currentLocation = 0;
        xLength = 10;
        seriesAmount = 3;
        
        CPTGraphHostingView* hostingView = self;
        hostingView.hostedGraph=[[CPTXYGraph alloc] init];
        hostingView.allowPinchScaling = NO;
        hostingView.userInteractionEnabled = YES;
        hostingView.hostedGraph.plotAreaFrame.paddingTop=0.0;
        hostingView.hostedGraph.plotAreaFrame.paddingRight=0.0;
        hostingView.hostedGraph.plotAreaFrame.paddingBottom=1.0;
        hostingView.hostedGraph.plotAreaFrame.paddingLeft=1.0;
        hostingView.hostedGraph.plotAreaFrame.masksToBorder = NO;
        hostingView.backgroundColor = [UIColor blackColor];
        
        for (NSUInteger i = 0; i < seriesAmount; i++) {
            CPTBarPlot* barPlot = [[CPTBarPlot alloc]init];
            barPlot.dataSource = self;
            barPlot.barWidth = CPTDecimalFromFloat(0.8/seriesAmount);
            barPlot.barOffset = CPTDecimalFromFloat(0.8*i/seriesAmount);
            barPlot.fill = [CPTFill fillWithColor:[REMColor colorByIndex:i]];
            barPlot.delegate = self;
            [hostingView.hostedGraph addPlot:barPlot];
        }
        CPTXYAxisSet* set = (CPTXYAxisSet*)hostingView.hostedGraph.axisSet;
        CPTXYAxis* x = set.xAxis;
        CPTXYAxis* y = set.yAxis;
        CPTMutableLineStyle* lineStyle = [[CPTMutableLineStyle alloc]init];
        lineStyle.lineWidth = 1;
        lineStyle.lineColor = [CPTColor whiteColor];
        x.axisLineStyle = lineStyle;
        y.axisLineStyle = lineStyle;
        x.majorIntervalLength = CPTDecimalFromInt(1);
        y.majorIntervalLength = x.majorIntervalLength;
        y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0];
        
        CPTXYPlotSpace* thePlotSpace = (CPTXYPlotSpace*)hostingView.hostedGraph.defaultPlotSpace;
        thePlotSpace.globalXRange = [[CPTPlotRange alloc]initWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(100)];
        thePlotSpace.xRange = [[CPTPlotRange alloc]initWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(xLength)];
        thePlotSpace.globalYRange =[[CPTPlotRange alloc]initWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt([self numberOfRecordsForPlot:nil])];
        thePlotSpace.yRange =[[CPTPlotRange alloc]initWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt([self numberOfRecordsForPlot:nil])];
        thePlotSpace.delegate = self;
        thePlotSpace.allowsUserInteraction = YES;
    }
    return self;
}

-(CPTPlotRange*)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate {
    [self.hostedGraph reloadData];
    return newRange;
}

-(NSNumber*)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx {
    return @(idx+currentLocation);
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return xLength;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
