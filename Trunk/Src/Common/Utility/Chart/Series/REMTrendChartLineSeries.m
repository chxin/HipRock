//
//  REMTrendChartScatterSeries.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/13/13.
//
//

#import "REMChartHeader.h"

@implementation REMTrendChartLineSeries
-(CPTPlot*)makePlot {
    CPTPlot* plot = [[CPTScatterPlot alloc]init];
    plot.dataSource = self;
    plot.delegate = self;
    return plot;
}
-(REMTrendChartSeriesType)getSeriesType {
    return 0;
}
-(int)getXAxisField {
    return CPTScatterPlotFieldX;
}
@end
