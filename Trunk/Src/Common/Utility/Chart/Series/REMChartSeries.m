/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartSeries.m
 * Created      : Zilong-Oscar.Xu on 9/12/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
