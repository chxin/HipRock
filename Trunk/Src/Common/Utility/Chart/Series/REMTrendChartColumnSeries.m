//
//  REMTrendChartColumnSeries.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by Zilong-Oscar.Xu on 9/13/13.
//
//

#import "REMChartHeader.h"

@implementation REMTrendChartColumnSeries
-(REMChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMChartDataProcessor*)processor plotStyle:(NSDictionary*)plotStyle startDate:(NSDate*)startDate {
    self = [super initWithData:energyData dataProcessor:processor plotStyle:plotStyle startDate:startDate];
    occupy = YES;
    plot = [[CPTBarPlot alloc]init];
    ((CPTBarPlot*)plot).barBasesVary = NO;
    return self;
}

-(void)beforePlotAddToGraph:(CPTGraph*)graph seriesList:(NSArray*)seriesList selfIndex:(uint)selfIndex {
    [super beforePlotAddToGraph:graph seriesList:seriesList selfIndex:selfIndex];
    
    const float pointMargin = 0.3;  // 左右柱子离minorTick的距离，单位为柱子宽度，即30%*barWidth
    const float barMargin = 0.08; // 同x轴点柱子间的距离，单位为柱子宽度，即8%*barWidth
    
    CPTBarPlot* myPlot = (CPTBarPlot*)plot;
    CPTFill* plotFill = (self.plotStyle == nil ? nil : [self.plotStyle objectForKey:@"fill"]);
    if (plotFill == nil) {
        plotFill = [CPTFill fillWithColor:[REMColor colorByIndex:selfIndex]];
    }
    myPlot.fill = plotFill;
    myPlot.lineStyle = nil;
    
    float barWidth = 0;
    float barOffSet = 0;
    float occupySeriesCount = 0;    // 柱图序列的数量
    float myIndexOfOccupy = 0;
    
    for (REMTrendChartSeries* series in seriesList) {
        if ([series isOccupy]) {
            if (series == self) myIndexOfOccupy = occupySeriesCount;
            occupySeriesCount++;
        }
    }
    if (occupySeriesCount == 0) occupySeriesCount = 1;
    barWidth = 1 / (occupySeriesCount + pointMargin*2 + barMargin*(occupySeriesCount-1));
    barOffSet = ((pointMargin + 0.5 + myIndexOfOccupy + (myIndexOfOccupy * barMargin)) * barWidth) - 0.5;
    myPlot.barOffset = CPTDecimalFromFloat(barOffSet);
    myPlot.barWidth = CPTDecimalFromFloat(barWidth);
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    REMEnergyData* point = [self.energyData objectAtIndex:idx];
    if (fieldEnum == CPTBarPlotFieldBarLocation) {
        return [self.dataProcessor processX:point.localTime];
    } else if (fieldEnum == CPTBarPlotFieldBarTip) {
        return [self.dataProcessor processY:point.dataValue];
    } else {
        return nil;
    }
}
@end
