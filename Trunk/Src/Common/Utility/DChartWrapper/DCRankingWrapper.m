//
//  DCRankingWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/22/13.
//
//

#import "DCRankingWrapper.h"
#import "_DCRankingXLabelFormatter.h"
#import "DCDataPoint.h"

@implementation DCRankingWrapper

-(NSUInteger)getSeriesAmount {
    return 1;
}

-(DCXYSeries*)createSeriesAt:(NSUInteger)index style:(DCChartStyle*)style {
    DCXYChartView* view = self.view;
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
    REMTargetEnergyData* t = nil;
    if (!REMIsNilOrNull(self.energyViewData) && self.energyViewData.targetEnergyData.count > 0) t = self.energyViewData.targetEnergyData[0];
    
    DCXYSeries* s = [[DCXYSeries alloc]initWithEnergyData:datas];
    s.color = [REMColor colorByIndex:0];
    s.target = t.target;
    if (!REMIsNilOrNull(t) && !REMIsNilOrNull(t.target) && !(REMIsNilOrNull(t.target.uomName))) {
        s.coordinateSystemName = t.target.uomName;
    } else {
        s.coordinateSystemName = REMEmptyString;
    }
    s.seriesKey = [REMSeriesKeyFormattor seriesKeyWithEnergyTarget:s.target energyData:self.energyViewData andWidgetContentSyntax:self.wrapperConfig.contentSyntax];
    
    DCSeriesStatus* state = self.seriesStates[s.seriesKey];
    if (REMIsNilOrNull(state)) {
        state = [self getDefaultSeriesState:s.target seriesIndex:0];
        [self.seriesStates setObject:state forKey:s.seriesKey];
    }
    [state applyToXYSeries:s];
    
    if (self.wrapperConfig.rankingSortOrder == NSOrderedDescending) [self swapeAllDatas:s];
    
    _DCRankingXLabelFormatter* formatter = [[_DCRankingXLabelFormatter alloc]initWithSeries:s];
    formatter.graphContext = view.graphContext;
    [view setXLabelFormatter:formatter];
    return s;
}
//-(DCSeriesStatus*)getDefaultSeriesState:(DCXYSeries*)series seriesIndex:(NSUInteger)index {
//    DCSeriesStatus* state = [[DCSeriesStatus alloc]init];
//    state.seriesKey = series.seriesKey;
//    state.seriesType = DCSeriesTypeStatusColumn;
//    state.avilableTypes = @[@(state.seriesType)];
//    state.hidden = NO;
//    state.canBeHidden = NO;
//    return state;
//}

-(void)customizeView:(DCXYChartView*)view {
    view.graphContext.pointHorizentalOffset = 0.5;
    view.graphContext.xLabelHorizentalOffset = 0.5;
}

-(void)setHiddenAtIndex:(NSUInteger)seriesIndex hidden:(BOOL)hidden {
    // Nothing to do. cannot hide series in ranking chart.
}

-(BOOL)canSeriesBeHiddenAtIndex:(NSUInteger)index {
    return NO;
}

-(void)swapeAllDatas:(DCXYSeries*)rankingSeries {
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

-(NSDictionary*)updateProcessorRangesFormatter:(REMEnergyStep)step {
    int rangeCode = self.wrapperConfig.rankingRangeCode;
    int datasAmount = self.energyViewData.targetEnergyData.count;
    
    return @{ @"globalRange": [[DCRange alloc]initWithLocation:0 length:datasAmount], @"beginRange": [[DCRange alloc]initWithLocation:0 length:MIN(rangeCode, datasAmount)], @"xformatter": [NSNull null] };
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

-(void)changeSortOrder:(NSComparisonResult)sortOrder {
    if (sortOrder == NSOrderedSame) return;
    if (self.wrapperConfig.rankingSortOrder != sortOrder) {
        self.wrapperConfig.rankingSortOrder = sortOrder;
        [self swapeAllDatas:self.view.seriesList[0]];
        [self.view reloadData];
    }
}
-(void)focusPointChanged:(NSArray *)dcpoints at:(int)x {
    BOOL refocus = NO;
    if (x >= ((DCXYSeries*)self.view.seriesList[0]).datas.count) {
        x = ((DCXYSeries*)self.view.seriesList[0]).datas.count - 1;
        refocus = YES;
    }
    if (x < 0) {
        refocus = YES;
        x = 0;
    }
    if (!refocus) {
        [super focusPointChanged:dcpoints at:x];
    } else {
        [self.view focusAroundX:x];
    }
}

-(DCRange*)updatePinchRange:(DCRange*)newRange pinchCentreX:(CGFloat)centreX pinchStopped:(BOOL)stopped {
    DCRange* globalRange= self.view.graphContext.globalHRange;
    double returnRangeEnd = newRange.end;
    double returnRangeStart = newRange.location;
    if (returnRangeStart < globalRange.location) returnRangeStart = globalRange.location;
    if (returnRangeEnd > globalRange.end) returnRangeEnd = globalRange.end;
    return [[DCRange alloc]initWithLocation:returnRangeStart length:returnRangeEnd-returnRangeStart];
}
@end
