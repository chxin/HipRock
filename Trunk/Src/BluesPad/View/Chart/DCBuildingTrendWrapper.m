//
//  DCBuildingTrendWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/27/13.
//
//

#import "DCBuildingTrendWrapper.h"
#import "_DCXLabelFormatter.h"

@implementation DCBuildingTrendWrapper
@synthesize isStacked = _isStacked;
@synthesize processors = _processors;
@synthesize sharedProcessor = _sharedProcessor;

-(void)extraSyntax:(REMWidgetContentSyntax*)syntax {
    _timeRangeType = syntax.relativeDateType;
}
-(NSDictionary*)updateProcessorRangesFormatter:(REMEnergyStep)step {
    _isStacked = NO;
    
    NSUInteger seriesAmount = self.energyViewData.targetEnergyData.count;
    _processors = [[NSMutableArray alloc]init];
    
    NSDate* baseDateOfX = nil;
    _sharedProcessor = [[REMTrendChartDataProcessor alloc]init];
    self.sharedProcessor.step = step;
    
    
    for (int i = 0; i < seriesAmount; i++) {
        [self.processors addObject:self.sharedProcessor];
    }
    
    int length = 0;
    NSDate* now = [NSDate date];
    int year = [REMTimeHelper getTimePart:REMDateTimePartYear ofLocalDate:now];
    int month = [REMTimeHelper getTimePart:REMDateTimePartMonth ofLocalDate:now];
    int date = [REMTimeHelper getTimePart:REMDateTimePartDay ofLocalDate:now];
    NSDate* today0H = [REMTimeHelper dateFromYear:year Month:month Day:date Hour:0];
    NSDate* thisMonth = [REMTimeHelper dateFromYear:year Month:month Day:1 Hour:0];
    switch (self.timeRangeType) {
        case REMRelativeTimeRangeTypeToday:
            length = [REMTimeHelper getTimePart:REMDateTimePartHour ofLocalDate:[NSDate date]];
            baseDateOfX = today0H;
            break;
        case REMRelativeTimeRangeTypeYesterday:
            baseDateOfX = [NSDate dateWithTimeInterval:24*3600 sinceDate:today0H];
            length = 24;
            break;
        case REMRelativeTimeRangeTypeThisMonth:
            length = [REMTimeHelper getTimePart:REMDateTimePartDay ofLocalDate:[NSDate date]];
            baseDateOfX = thisMonth;
            break;
        case REMRelativeTimeRangeTypeLastMonth:
            length = [REMTimeHelper getDaysOfDate:[REMTimeHelper addMonthToDate:[NSDate date] month:-1]];
            baseDateOfX = [REMTimeHelper addMonthToDate:thisMonth month:-1];
            break;
        case REMRelativeTimeRangeTypeThisYear:
            length = [REMTimeHelper getTimePart:REMDateTimePartMonth ofLocalDate:[NSDate date]];
            baseDateOfX = [REMTimeHelper dateFromYear:year Month:1 Day:1 Hour:0];
            break;
        case REMRelativeTimeRangeTypeLastYear:
            baseDateOfX = [REMTimeHelper dateFromYear:year-1 Month:1 Day:1 Hour:0];
            length = 12;
            break;
        default:
            break;
    }
    self.sharedProcessor.baseDate = baseDateOfX;
    DCRange* range = [[DCRange alloc]initWithLocation:0 length:length];
    
    return @{ @"globalRange": range, @"beginRange": range, @"xformatter": [[_DCXLabelFormatter alloc]initWithStartDate:baseDateOfX dataStep:step interval:1]};
}

-(void)customizeSeries:(DCLineSeries *)series seriesIndex:(int)index chartStyle:(REMChartStyle *)style {
    [super customizeSeries:series seriesIndex:index chartStyle:style];
    series.color = [self getSeriesColorByIndex:index];
    series.symbolType = DCLineSymbolTypeRound;
}

-(UIColor*)getSeriesColorByIndex:(int)index {
    NSString *color= @"#ffffff";
    switch (index) {
        case 0:
            color = @"#ffffff";
            break;
        case 1:
            color = @"#30a0d4";
            break;
        case 2:
            color = @"#9ac350";
            break;
        case 3:
            color = @"#9d6ba4";
            break;
        case 4:
            color = @"#aa9465";
            break;
        case 5:
            color = @"#74939b";
            break;
        case 6:
            color = @"#b9686e";
            break;
        case 7:
            color = @"#6887c5";
            break;
        case 8:
            color = @"#8aa386";
            break;
        case 9:
            color = @"#b93d95";
            break;
        default:
            break;
    }
    return [REMColor colorByHexString:color alpha:0.8];
}
@end
