//
//  REMTrendWidget.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/27/13.
//
//

#import "REMTrendWidgetWrapper.h"

@implementation REMTrendWidgetWrapper

-(NSDictionary*)getSeriesAndAxisConfig:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    NSMutableArray* seriesArray = [[NSMutableArray alloc]init];
    int seriesCount = 0;
    if (energyViewData.targetEnergyData != nil && energyViewData.targetEnergyData != NULL) seriesCount =energyViewData.targetEnergyData.count;
    NSMutableArray* uomIdArray = [[NSMutableArray alloc]init];
    for (int seriesIndex = 0; seriesIndex < seriesCount; seriesIndex++) {
        REMTargetEnergyData* seriesData = [energyViewData.targetEnergyData objectAtIndex:seriesIndex];
        long uomId = seriesData.target.uomId;
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
        [seriesArray addObject: [self getSeriesConfigByData:seriesData step:widgetSyntax.step.intValue yAxisIndex:uomIndex seriesIndex:seriesIndex]];
    }
    [dic setObject:seriesArray forKey:@"series"];
    
    NSMutableArray* yAxisConfig = [[NSMutableArray alloc]init];
    for (int i = 0; i < uomIdArray.count; i++) {
        if (self.status == REMWidgetStatusMinimized) {
            [yAxisConfig addObject:[REMTrendChartAxisConfig getMinWidgetYConfig]];
        } else {
            [yAxisConfig addObject:[REMTrendChartAxisConfig getMaxWidgetYConfig]];
        }
    }
    [dic setObject:yAxisConfig forKey:@"yAxis"];
    
    REMTimeRange* theFirstTimeRange = [widgetSyntax.timeRanges objectAtIndex:0];
    NSDate *globalStart = theFirstTimeRange.startTime;
    int step = widgetSyntax.step.intValue;
    NSNumber* globalLength = [self roundDate:theFirstTimeRange.endTime startDate:globalStart step:step roundToFloor:NO]; //以后需要换成GlobalRange的ENDTime
    NSNumber* xLocation = [self roundDate:theFirstTimeRange.startTime startDate:globalStart step:step roundToFloor:YES];
    NSNumber* xEndLocation = [self roundDate:theFirstTimeRange.endTime startDate:globalStart step:step roundToFloor:NO];

    [dic setObject:globalLength forKey:@"xGlobalLength"];
    [dic setObject:xLocation forKey:@"xStartLocation"];
    [dic setObject:xEndLocation forKey:@"xEndLocation"];
    
    return dic;
}

-(NSNumber*)roundDate:(NSDate*)lengthDate startDate:(NSDate*)startDate step:(REMEnergyStep)step roundToFloor:(BOOL)roundToFloor {
    NSNumber* length = [self.dataProcessor processX:lengthDate startDate:startDate step:step];
    NSDate* edgeOfGlobalEnd = [self.dataProcessor deprocessX:length.intValue startDate:startDate step:step];
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


-(REMTrendChartView*)renderContentView:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax {
    REMTrendChartConfig* chartConfig = nil;
    if (self.status == REMWidgetStatusMinimized) {
        chartConfig = (REMTrendChartConfig*)[REMTrendChartConfig getMinimunWidgetDefaultSetting];
    } else {
        chartConfig = (REMTrendChartConfig*)[REMTrendChartConfig getMaximunWidgetDefaultSetting];
    }
    
    chartConfig.step = widgetSyntax.step.intValue;
    NSDictionary* dic = [self getSeriesAndAxisConfig:energyViewData widgetContext:widgetSyntax];
    chartConfig.series = [dic objectForKey:@"series"];
    chartConfig.yAxisConfig = [dic objectForKey:@"yAxis"];
    chartConfig.xGlobalLength = [dic objectForKey:@"xGlobalLength"];
    float rangeStart = ((NSNumber*)[dic objectForKey:@"xStartLocation"]).floatValue;
    float rangeEnd = ((NSNumber*)[dic objectForKey:@"xEndLocation"]).floatValue;

    REMTrendChartView* myView = [[REMTrendChartView alloc]initWithFrame:frame chartConfig:chartConfig];
    [myView renderRange: rangeStart length:rangeEnd-rangeStart];
    return  myView;
}

-(REMTrendChartSeries*) getSeriesConfigByData:(REMTargetEnergyData*)energyData step:(REMEnergyStep)step yAxisIndex:(uint)yAxisIndex seriesIndex:(uint)seriesIndex {
    return nil;
}
-(REMChartDataProcessor*)initializeProcessor {
    return [[REMTrendChartDataProcessor alloc]init];
}
@end
