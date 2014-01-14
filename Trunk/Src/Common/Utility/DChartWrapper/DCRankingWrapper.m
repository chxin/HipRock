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
    DCXYSeries* s = [[NSClassFromString(self.defaultSeriesClass) alloc]initWithEnergyData:datas];
    s.xAxis = view.xAxis;
//    s.yAxis = view.yAxis0;
    s.yAxis.axisTitle = targetEnergy.target.uomName;
    s.color = [REMColor colorByIndex:0];
    [self customizeSeries:s seriesIndex:index chartStyle:style];
    
    if (self.sortOrder == NSOrderedDescending) [self swapeAllDatas:s];
    
    _DCRankingXLabelFormatter* formatter = [[_DCRankingXLabelFormatter alloc]initWithSeries:s];
    formatter.graphContext = view.graphContext;
    [view setXLabelFormatter:formatter];
    return s;
}

-(void)customizeView:(DCXYChartView*)view {
    view.graphContext.pointAlignToTick = NO;
    view.graphContext.xLabelAlignToTick = NO;
}

-(NSArray*)createYAxes:(NSArray*)series {
    DCXYSeries* s = series[0];
    DCAxis* y = [[DCAxis alloc]init];
    y.coordinate = DCAxisCoordinateY;
    s.yAxis = y;
    y.axisTitle = REMEmptyString;
    y.labelToLine = self.style.yLabelToLine;
    if (self.style.yLineWidth > 0) {
        y.lineColor = self.style.yLineColor;
        y.lineWidth = self.style.yLineWidth;
    }
    if (self.style.yTextFont) {
        y.labelColor = self.style.yTextColor;
        y.labelFont = self.style.yTextFont;
    }
    y.axisTitleColor = self.style.yAxisTitleColor;
    y.axisTitleToTopLabel = self.style.yAxisTitleToTopLabel;
    y.axisTitleFontSize = self.style.yAxisTitleFontSize;
    return @[y];
}

-(void)setHiddenAtIndex:(NSUInteger)seriesIndex hidden:(BOOL)hidden {
    // Nothing to do. cannot hide series in ranking chart.
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
    int rangeCode = self.rankingRangeCode;
    int datasAmount = self.energyViewData.targetEnergyData.count;
    
    return @{ @"globalRange": [[DCRange alloc]initWithLocation:0 length:datasAmount], @"beginRange": [[DCRange alloc]initWithLocation:0 length:MIN(rangeCode, datasAmount)], @"xformatter": [NSNull null] };
}

-(void)extraSyntax:(DWrapperConfig*)wrapperConfig {
    _rankingRangeCode = wrapperConfig.rankingRangeCode;
    _sortOrder = wrapperConfig.rankingDefaultSortOrder;
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
        [self swapeAllDatas:self.view.seriesList[0]];
        [self.view relabelX];
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
@end
