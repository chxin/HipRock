/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMRankingWidgetWrapper.m
 * Created      : Zilong-Oscar.Xu on 10/22/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMRankingWidgetWrapper.h"

@implementation REMRankingWidgetWrapper
-(uint)getSeriesCount {
    return 1;
}
-(NSRange)createGlobalRange {
    return NSMakeRange(0, self.energyViewData.targetEnergyData.count);
}

-(NSRange)createInitialRange {
    int xLength = self.rankingRangeCode;
    if (xLength == 0 || xLength > self.energyViewData.targetEnergyData.count) xLength = self.energyViewData.targetEnergyData.count;
    return NSMakeRange(0, xLength);
}

-(REMTrendChartRankingSeries*)createSeriesConfigOfIndex:(uint)seriesIndex {
//    _sortOrder = self.widgetSyntax.rankingSortOrder;
    
    REMTrendChartRankingSeries* s =[[REMTrendChartRankingSeries alloc]initWithData:self.energyViewData.targetEnergyData dataProcessor:nil plotStyle:nil];
    REMTargetEnergyData* targetEnergyData = (REMTargetEnergyData*)self.energyViewData.targetEnergyData[0];
    s.uomId = targetEnergyData.target.uomId;
    s.uomName = targetEnergyData.target.uomName;
    s.sortOrder = self.sortOrder;
    return s;
}
-(void)extraSyntax:(REMWidgetContentSyntax*)widgetSyntax {
    [super extraSyntax:widgetSyntax];
    _sortOrder = widgetSyntax.rankingSortOrder;
    _rankingRangeCode = widgetSyntax.rankingRangeCode;
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
