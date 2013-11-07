/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMPieChartSeries.m
 * Created      : Zilong-Oscar.Xu on 10/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMChartHeader.h"

@implementation REMPieChartSeries

-(REMChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMChartDataProcessor*)processor plotStyle:(NSDictionary*)plotStyle {
    self = [super initWithData:energyData dataProcessor:processor plotStyle:plotStyle];
    CPTPieChart* thePlot = [[CPTPieChart alloc]init];
    thePlot.pieInnerRadius=0;
//    thePlot.startAngle = M_PI;
//    thePlot.endAngle = -M_PI;
    thePlot.identifier=@"pieplot1";
    
    thePlot.sliceDirection=CPTPieDirectionClockwise;
//    CPTMutableLineStyle* borderStyle = [[CPTMutableLineStyle alloc]init];
//    borderStyle.lineColor = [CPTColor whiteColor];
//    borderStyle.lineWidth = 1.0f;
    thePlot.borderLineStyle = nil;
    
//    CPTMutableShadow* shadow = [CPTMutableShadow shadow];
//    shadow.shadowColor = [CPTColor whiteColor];
//    shadow.shadowBlurRadius = 5;
//    thePlot.shadow = shadow;
    
    plot = thePlot;
    return self;
}

-(void)beforePlotAddToGraph:(CPTGraph*)graph seriesList:(NSArray*)seriesList selfIndex:(uint)selfIndex {
    [super beforePlotAddToGraph:graph seriesList:seriesList selfIndex:selfIndex];
    CPTPieChart* thePlot = (CPTPieChart*)plot;
    thePlot.pieRadius = (MIN(graph.bounds.size.height, graph.bounds.size.width)-2) / 3;
//    [CPTAnimation animate:plot
//        property:@"endAngle"
//        from: thePlot.endAngle
//        to: thePlot.startAngle
//        duration:self.animationDuration
//        withDelay:0
//        animationCurve:CPTAnimationCurveDefault
//    delegate:self];
}
-(void)animationDidFinish:(CPTAnimationOperation *)operation {
    CPTPieChart* thePlot = (CPTPieChart*)plot;
//    thePlot.startAngle = M_PI;
    thePlot.endAngle = NAN;
    [CPTAnimation animate:plot
                 property:@"startAngle"
                     from: thePlot.startAngle
                       to: M_PI_2
                 duration:self.animationDuration
                withDelay:0
           animationCurve:CPTAnimationCurveDefault
                 delegate:nil];
}
- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    REMEnergyData* point = [self.energyData objectAtIndex:idx];
    if (fieldEnum == CPTPieChartFieldSliceWidth) {
        return [self.dataProcessor processY:point.dataValue];
    } else {
        return [NSNumber numberWithInteger:idx];
    }
}

-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx {
    return [CPTFill fillWithColor:[REMColor colorByIndex:idx]];
}
@end
