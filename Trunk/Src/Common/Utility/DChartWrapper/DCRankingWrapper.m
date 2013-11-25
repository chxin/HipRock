//
//  DCRankingWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/22/13.
//
//

#import "DCRankingWrapper.h"
@interface DCTrendWrapper()
@property (nonatomic, strong) DCRange* beginRange;
@property (nonatomic, strong) DCRange* globalRange;
@end

@implementation DCRankingWrapper

-(NSUInteger)getSeriesAmount {
    return 1;
}

-(DCXYSeries*)createSeriesAt:(NSUInteger)index style:(REMChartStyle*)style {
    DCXYChartView* view = self.view;
    REMTargetEnergyData* targetEnergy = self.energyViewData.targetEnergyData[index];
    NSMutableArray* datas = [[NSMutableArray alloc]init];
    for (REMTargetEnergyData* targetEnergy in self.energyViewData.targetEnergyData) {
        if (REMIsNilOrNull(targetEnergy.energyData) || targetEnergy.energyData.count == 0 ) continue;
        DCDataPoint* point = [[DCDataPoint alloc]init];
        point.target = targetEnergy.target;
        point.energyData = targetEnergy.energyData[0];
        point.value = point.energyData.dataValue;
        if (REMIsNilOrNull(point.value)) {
            point.pointType = DCDataPointTypeBreak;
        } else {
            point.pointType = DCDataPointTypeNormal;
        }
        [datas addObject:point];
    }
    [self quickSort:datas left:0 right:datas.count-1];
    if (self.sortOrder == NSOrderedDescending) [self swapeAllDatas];
    DCXYSeries* s = [[NSClassFromString(self.defaultSeriesClass) alloc]initWithEnergyData:datas];
    s.xAxis = view.xAxis;
    s.yAxis = view.yAxis0;
    s.yAxis.axisTitle = targetEnergy.target.uomName;
    [self customizeSeries:s seriesIndex:index chartStyle:style];
    return s;
}

-(void)setSeriesHiddenAtIndex:(NSUInteger)seriesIndex hidden:(BOOL)hidden {
    // Nothing to do. cannot hide series in ranking chart.
}

-(void)swapeAllDatas {
    DCXYSeries* rankingSeries = self.view.seriesList[0];
    DCDataPoint* temp = nil;
    int i = 0, j = rankingSeries.datas.count - 1;
    NSMutableArray* datas = rankingSeries.datas.mutableCopy;
    while (i < j) {
        temp = datas[i];
        datas[i] = datas[j];
        datas[j] = temp;
        i++;
        j--;
    }
    rankingSeries.datas = datas;
}

-(void)updateProcessorRangesFormatter:(REMEnergyStep)step {
    int rangeCode = self.rankingRangeCode;
    int datasAmount = self.energyViewData.targetEnergyData.count;
    self.beginRange = [[DCRange alloc]initWithLocation:-0.5 length:MIN(rangeCode, datasAmount)];
    self.globalRange = [[DCRange alloc]initWithLocation:-0.5 length:datasAmount];
}

-(void)extraSyntax:(REMWidgetContentSyntax*)syntax {
    _rankingRangeCode = syntax.rankingRangeCode;
    _sortOrder = syntax.rankingSortOrder;
}

-(void)quickSort:(NSMutableArray*)energyList left:(int)left right:(int)right {
    if (left >= right) return;
    int index = [self sortUnit:energyList left:left right:right];
    [self quickSort:energyList left:left right:index-1];
    [self quickSort:energyList left:index+1 right:right];
}

-(int)sortUnit:(NSMutableArray*)energyList left:(int)left right:(int)right {
    DCDataPoint* keyPoint = [energyList objectAtIndex:left];
    NSNumber* key = [self getYValueOfEnergyData:keyPoint];
    
    while (left < right) {
        while ([[self getYValueOfEnergyData:[energyList objectAtIndex:right]] isGreaterThanOrEqualTo:key] && right > left)
            --right;
        
        energyList[left] = energyList[right];
        while ([[self getYValueOfEnergyData:[energyList objectAtIndex:left]] isLessThanOrEqualTo:key] && right > left)
            ++left;
        
        energyList[right] = energyList[left];
    }
    energyList[left] = keyPoint;
    return right;
}

-(NSNumber*)getYValueOfEnergyData:(DCDataPoint*)energyPoint {
    NSNumber* yValue = energyPoint.value;
    if (yValue == nil || yValue == NULL|| [yValue isEqual:[NSNull null]]) return @(-1);
    else return yValue;
}

-(void)setSortOrder:(NSComparisonResult)sortOrder {
    if (sortOrder == NSOrderedSame) return;
    if (_sortOrder != sortOrder) {
        _sortOrder = sortOrder;
        [self swapeAllDatas];
        
        DCXYSeries* rankingSeries = self.view.seriesList[0];
        [rankingSeries.seriesLayer setNeedsDisplay];
    }
}
@end
