/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartView.m
 * Created      : Zilong-Oscar.Xu on 10/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMChartHeader.h"

@implementation REMPieChartView

-(REMPieChartView*)initWithFrame:(CGRect)frame chartConfig:(REMChartConfig*)config  {
    self = [super initWithFrame:frame];
    if (self) {
        _series = config.series;
        
        CPTXYGraph *graph=[[CPTXYGraph alloc]initWithFrame:self.bounds];
        self.hostedGraph=graph;
        graph.axisSet = nil;
        graph.paddingBottom = 0;
        graph.paddingLeft = 0;
        graph.paddingRight = 0;
        graph.paddingTop = 0;
        
        if (self.series.count == 1) {
            REMPieChartSeries* s = [self.series objectAtIndex:0];
            [s beforePlotAddToGraph:self.hostedGraph seriesList:self.series selfIndex:0];
            [self.hostedGraph addPlot:[s getPlot]];
        }
    }
    return self;
}
@end
