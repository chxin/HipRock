//
//  REMBuildingAverageWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 1/3/14.
//
//

#import "REMBuildingAverageWrapper.h"
#import "DCDataPoint.h"
#import "_DCXLabelFormatter.h"
#import "REMColor.h"

@implementation REMBuildingAverageWrapper
@synthesize processors = _processors;
@synthesize sharedProcessor = _sharedProcessor;

-(NSDictionary*)updateProcessorRangesFormatter:(REMEnergyStep)step {
    NSUInteger seriesAmount = [self getSeriesAmount];
    _processors = [[NSMutableArray alloc]init];
    
    _sharedProcessor = [[DCTrendChartDataProcessor alloc]init];
    self.sharedProcessor.step = step;
    
    for (int i = 0; i < seriesAmount; i++) {
        [self.processors addObject:self.sharedProcessor];
    }
    
    NSDate* now = [NSDate date];
    int year = [REMTimeHelper getTimePart:REMDateTimePartYear ofLocalDate:now];
    int month = [REMTimeHelper getTimePart:REMDateTimePartMonth ofLocalDate:now];
    NSDate* thisMonth = [REMTimeHelper dateFromYear:year Month:month Day:1 Hour:0];
    NSDate* baseDateOfX = [REMTimeHelper addMonthToDate:thisMonth month:-35];

    self.sharedProcessor.baseDate = baseDateOfX;
    _DCXLabelFormatter* formatter = [[_DCXLabelFormatter alloc]initWithStartDate:baseDateOfX dataStep:step interval:1];
    return @{ @"globalRange": [[DCRange alloc]initWithLocation:0 length:36], @"beginRange": [[DCRange alloc]initWithLocation:24 length:12], @"xformatter": formatter};
}

-(DCLineSymbolType)getSymbolTypeByIndex:(NSUInteger)index {
    return DCLineSymbolTypeRound;
}

-(NSString*)getKeyOfSeries:(DCXYSeries*)series {
    return [NSString stringWithFormat:@"%p", series];
}

-(DCSeriesStatus*)getDefaultSeriesState:(DCXYSeries *)series seriesIndex:(NSUInteger)index {
    DCSeriesStatus* state = [[DCSeriesStatus alloc]init];
    state.seriesKey = series.seriesKey;
    state.seriesType = series.target.type == REMEnergyTargetCalcValue ? DCSeriesTypeStatusColumn : DCSeriesTypeStatusLine;
    state.avilableTypes = state.seriesType;
    if (state.seriesType == DCSeriesTypeLine) {
        state.forcedColor = self.style.benchmarkColor;
    } else {
        state.forcedColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7f];
    }
    state.visible = YES;
    return state;
}
@end
