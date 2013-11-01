//
//  REMTrendWidget.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by Zilong-Oscar.Xu on 9/27/13.
//
//

#import "REMTrendWidgetWrapper.h"
//@interface REMTrendWidgetWrapper()
//@property (nonatomic, weak) NSDate* baseDateOfX;
//@property (nonatomic) REMTrendChartDataProcessor* dataProcessor;
//@end

@implementation REMTrendWidgetWrapper

-(NSArray*)extraSeriesConfig {
    NSMutableArray* seriesArray = [[NSMutableArray alloc]init];
    uint seriesCount = [self getSeriesCount];
    NSMutableArray* uomIdArray = [[NSMutableArray alloc]init];
    for (uint seriesIndex = 0; seriesIndex < seriesCount; seriesIndex++) {
        REMTrendChartSeries* s = [self createSeriesConfigOfIndex:seriesIndex];
        long uomId = s.uomId;
        uint uomIndex = 0;
        for (; uomIndex < uomIdArray.count; uomIndex++) {
            NSNumber* otherUomId = [uomIdArray objectAtIndex:uomIndex];
            if (otherUomId.unsignedIntValue == uomId) {
                break;
            }
        }
        if (uomIndex == uomIdArray.count) {
            [uomIdArray addObject:[NSNumber numberWithLong:uomId]];
        }
        s.yAxisIndex = uomIndex;
        [seriesArray addObject: s];
    }
    return seriesArray;
}

-(uint)getSeriesCount {
    if (self.energyViewData.targetEnergyData != nil && self.energyViewData.targetEnergyData != NULL) {
        return self.energyViewData.targetEnergyData.count;
    } else {
        return 0;
    }
}

-(NSRange)createGlobalRange {
    NSDate* globalEndDate = nil;
    if (self.energyViewData.targetGlobalData != nil && self.energyViewData.targetGlobalData.energyData.count != 0) {
        self.baseDateOfX = ((REMEnergyData*)self.energyViewData.targetGlobalData.energyData[0]).localTime;
        globalEndDate = ((REMEnergyData*)self.energyViewData.targetGlobalData.energyData[self.energyViewData.targetGlobalData.energyData.count-1]).localTime;
    } else {
//        REMTimeRange* theFirstTimeRange = [self.widgetSyntax.timeRanges objectAtIndex:0];
//        self.baseDateOfX = theFirstTimeRange.startTime;
//        globalEndDate = theFirstTimeRange.endTime;
        REMTargetEnergyData* se = self.energyViewData.targetEnergyData[0];
        if (se.energyData.count == 0) {
            self.baseDateOfX = [NSDate dateWithTimeIntervalSince1970:0];
            globalEndDate = self.baseDateOfX;
        } else {
            self.baseDateOfX = ((REMEnergyData*)se.energyData[0]).localTime;
            globalEndDate = ((REMEnergyData*)se.energyData[se.energyData.count-1]).localTime;
        }
    }
    
    sharedProcessor = [[REMTrendChartDataProcessor alloc]init];
    sharedProcessor.step = self.widgetSyntax.step.intValue;
    sharedProcessor.baseDate = self.baseDateOfX;
    
    NSNumber* globalLength = [self roundDate:globalEndDate startDate:self.baseDateOfX step:self.widgetSyntax.step.intValue roundToFloor:NO];
    return NSMakeRange(0, globalLength.intValue);
}

-(NSRange)createInitialRange {
    REMTimeRange* theFirstTimeRange = [self.widgetSyntax.timeRanges objectAtIndex:0];
    NSDate* endDate = theFirstTimeRange.endTime;
    NSDate* startDate = theFirstTimeRange.startTime;
    int startPoint = [self roundDate:startDate startDate:self.baseDateOfX step:self.widgetSyntax.step.intValue roundToFloor:YES].intValue;
    int endPoint = [self roundDate:endDate startDate:self.baseDateOfX step:self.widgetSyntax.step.intValue roundToFloor:NO].intValue;
    return NSMakeRange(startPoint, endPoint - startPoint);
}

-(REMTrendChartSeries*)createSeriesConfigOfIndex:(uint)seriesIndex {
    return nil;
}

-(NSNumber*)roundDate:(NSDate*)lengthDate startDate:(NSDate*)startDate step:(REMEnergyStep)step roundToFloor:(BOOL)roundToFloor {
    NSNumber* length = [sharedProcessor processX:lengthDate];
    NSDate* edgeOfGlobalEnd = [sharedProcessor deprocessX:length.intValue];
    NSComparisonResult end = [edgeOfGlobalEnd compare:lengthDate];
    if (end == NSOrderedSame || end == NSOrderedDescending) {
        return length;
    } else if (roundToFloor) {
        length = @(length.intValue);
    } else {
        length = @(length.intValue+1);
    }
    return length;
}


-(REMTrendChartView*)renderContentView:(CGRect)frame chartConfig:(REMTrendChartConfig*)chartConfig {
    REMTrendChartView* myView = [[REMTrendChartView alloc]initWithFrame:frame chartConfig:chartConfig];
    NSRange initialRange = [self createInitialRange];
    [myView renderRange:initialRange.location length:initialRange.length];
    return  myView;
}

-(REMChartConfig*)getChartConfig:(NSDictionary*)style {
    REMTrendChartConfig* chartConfig = [[REMTrendChartConfig alloc]initWithDictionary:style];
    chartConfig.step = self.widgetSyntax.step.intValue;
    chartConfig.xGlobalLength = @([self createGlobalRange].length);
    
    chartConfig.series = [self extraSeriesConfig];
    NSMutableArray* yAxisList = [[NSMutableArray alloc]init];
    for (REMTrendChartSeries* s in chartConfig.series) {
        if (s.yAxisIndex >= yAxisList.count) {
            REMTrendChartAxisConfig* y = [[REMTrendChartAxisConfig alloc]initWithLineStyle:style[@"yLineStyle"] gridlineStyle:style[@"yGridlineStyle"] textStyle:style[@"yTextStyle"]];
            y.title = s.uomName;
            [yAxisList addObject:y];
            y.labelFormatter = [[REMYFormatter alloc]init];
        }
    }
    chartConfig.yAxisConfig = yAxisList;
    chartConfig.xAxisConfig.labelFormatter = [[REMXFormatter alloc]initWithStartDate:self.baseDateOfX dataStep:chartConfig.step interval:0];
    
    return chartConfig;
}
@end
