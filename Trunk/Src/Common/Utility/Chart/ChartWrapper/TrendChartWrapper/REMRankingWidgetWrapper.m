//
//  REMRankingWidgetWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 10/22/13.
//
//

#import "REMRankingWidgetWrapper.h"
#import "REMTrendChartRankingSeries.h"

@implementation REMRankingWidgetWrapper
-(NSDictionary*)getSeriesAndAxisConfig:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:@[[[REMTrendChartRankingSeries alloc]initWithData:energyViewData.targetEnergyData dataProcessor:self.dataProcessor plotStyle:nil yAxisIndex:0 dataStep:REMEnergyStepHour]] forKey:@"series"];
    
    REMTrendChartAxisConfig* yAxis = nil;
    if (self.status == REMWidgetStatusMinimized) {
        yAxis = [REMTrendChartAxisConfig getMinWidgetYConfig];
    } else {
        yAxis = [REMTrendChartAxisConfig getMaxWidgetYConfig];
    }
    [dic setObject:@[yAxis] forKey:@"yAxis"];
    
    [dic setObject:[NSNumber numberWithUnsignedInt:energyViewData.targetEnergyData.count] forKey:@"xGlobalLength"];
    [dic setObject:[NSNumber numberWithUnsignedInt:0] forKey:@"xStartLocation"];
    [dic setObject:[NSNumber numberWithUnsignedInt:energyViewData.targetEnergyData.count] forKey:@"xEndLocation"];
    return dic;
}

-(void)setSortOrder:(NSComparisonResult)theSortOrder {
    if (self.sortOrder == theSortOrder || theSortOrder == NSOrderedSame) return;
    REMTrendChartRankingSeries* rankingSeries = [((REMTrendChartView*)self.view).series objectAtIndex:0];
    rankingSeries.sortOrder = theSortOrder;
    _sortOrder = theSortOrder;
}

-(void)reloadData {
    [((REMTrendChartView*)self.view) renderRange:self.location length:self.length];
//    REMTrendChartRankingSeries* rankingSeries = [((REMTrendChartView*)self.view).series objectAtIndex:0];
//    [[rankingSeries getPlot]reloadData];
}

@end
