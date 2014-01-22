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
@synthesize isStacked = _isStacked;
@synthesize processors = _processors;
@synthesize sharedProcessor = _sharedProcessor;

-(BOOL)isSpecialType:(REMEnergyTargetType)type {
    return type != REMEnergyTargetCalcValue;
}

-(NSDictionary*)updateProcessorRangesFormatter:(DWrapperConfig*)wrapperConfig {
    REMEnergyStep step = wrapperConfig.step;
    _isStacked = NO;
    
    NSUInteger seriesAmount = [self getSeriesAmount];
    _processors = [[NSMutableArray alloc]init];
    
    
    _sharedProcessor = [[REMTrendChartDataProcessor alloc]init];
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

-(void)customizeSeries:(DCXYSeries *)series seriesIndex:(int)index chartStyle:(REMChartStyle *)style {
    [super customizeSeries:series seriesIndex:index chartStyle:style];
    if (series.type == DCSeriesTypeColumn) {
        series.color = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7f];
    } else {
        ((DCLineSeries*)series).symbolType = DCLineSymbolTypeRound;
    }
}
@end
