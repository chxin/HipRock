//
//  REMChartSeries.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by Zilong-Oscar.Xu on 9/12/13.
//
//

#import "REMChartHeader.h"

@implementation REMChartSeries
-(REMChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMChartDataProcessor*)processor plotStyle:(NSDictionary*)plotStyle {
    self = [super init];
    if (self) {
        _plotStyle = plotStyle;
        _dataProcessor = processor;
        _energyData = energyData;
    }
    return self;
}

-(void)beforePlotAddToGraph:(CPTGraph*)graph seriesList:(NSArray*)seriesList selfIndex:(uint)selfIndex {
    plot.frame = graph.bounds;
    plot.dataSource = self;
    plot.delegate = self;
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return self.energyData.count;
}
-(CPTPlot*)getPlot {
    return plot;
}

@end
