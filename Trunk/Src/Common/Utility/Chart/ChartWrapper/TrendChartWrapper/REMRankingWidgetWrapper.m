//
//  REMRankingWidgetWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 10/22/13.
//
//

#import "REMRankingWidgetWrapper.h"

@implementation REMRankingWidgetWrapper
-(NSDictionary*)getSeriesAndAxisConfig:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    REMTrendChartRankingSeries* series =[[REMTrendChartRankingSeries alloc]initWithData:energyViewData.targetEnergyData dataProcessor:self.dataProcessor plotStyle:nil yAxisIndex:0 dataStep:REMEnergyStepHour];
    if (widgetSyntax.rankingSortOrder != NSOrderedSame) {
        _sortOrder = widgetSyntax.rankingSortOrder;
        series.sortOrder = widgetSyntax.rankingSortOrder;
    }
    NSNumber* minPosition = widgetSyntax.rankingMinPosition;
    if (minPosition == nil || minPosition == NULL || [minPosition isEqual:[NSNull null]] || [minPosition isLessThanOrEqualTo:[NSNumber numberWithInt:0]]) {
        self.location = 0;
    } else {
        self.location = minPosition.unsignedIntValue;
    }
    if (widgetSyntax.rankingRangeCode != REMRankingRangeAll) {
        self.length = widgetSyntax.rankingRangeCode;
    } else {
        self.length = UINT32_MAX;
    }
    if (self.length > energyViewData.targetEnergyData.count) {
        self.length = energyViewData.targetEnergyData.count;
    }
    
    
    [dic setObject:@[series] forKey:@"series"];
    
    REMTrendChartAxisConfig* yAxis = nil;
    if (self.status == REMWidgetStatusMinimized) {
        yAxis = [REMTrendChartAxisConfig getMinWidgetYConfig];
    } else {
        yAxis = [REMTrendChartAxisConfig getMaxWidgetYConfig];
    }
    [dic setObject:@[yAxis] forKey:@"yAxis"];
    
    [dic setObject:[NSNumber numberWithUnsignedInt:energyViewData.targetEnergyData.count-1] forKey:@"xGlobalLength"];
    [dic setObject:[NSNumber numberWithUnsignedInt:self.location] forKey:@"xStartLocation"];
    [dic setObject:[NSNumber numberWithUnsignedInt:self.location+self.length] forKey:@"xEndLocation"];
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
