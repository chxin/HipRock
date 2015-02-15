//
//  DCBuildingTrendWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/27/13.
//
//

#import "REMBuildingTrendWrapper.h"
#import "_DCXLabelFormatter.h"

@implementation REMBuildingTrendWrapper
@synthesize processors = _processors;
@synthesize sharedProcessor = _sharedProcessor;

-(NSDictionary*)updateProcessorRangesFormatter:(REMEnergyStep)step {
    NSUInteger seriesAmount = [self getSeriesAmount];
    _processors = [[NSMutableArray alloc]init];
    
    NSDate* baseDateOfX = nil;
    _sharedProcessor = [[DCTrendChartDataProcessor alloc]init];
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
    switch (self.wrapperConfig.relativeDateType) {
        case REMRelativeTimeRangeTypeToday:
            length = [REMTimeHelper getTimePart:REMDateTimePartHour ofLocalDate:[NSDate date]];
            baseDateOfX = today0H;
            break;
        case REMRelativeTimeRangeTypeYesterday:
            baseDateOfX = [NSDate dateWithTimeInterval:-24*3600 sinceDate:today0H];
            length = 24;
            break;
        case REMRelativeTimeRangeTypeThisMonth:
            length = [REMTimeHelper getTimePart:REMDateTimePartDay ofLocalDate:[NSDate date]];
            baseDateOfX = thisMonth;
            break;
        case REMRelativeTimeRangeTypeLastMonth:
            length = (int)[REMTimeHelper getDaysOfDate:[REMTimeHelper addMonthToDate:[NSDate date] month:-1]];
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
    NSFormatter* formatter = nil;
    if (step == REMEnergyStepHour) {
        formatter = [[NSNumberFormatter alloc]init];
        [(NSNumberFormatter*)formatter setPositiveFormat:@"#点"];
    } else {
        formatter = [[_DCXLabelFormatter alloc]initWithStartDate:baseDateOfX dataStep:step interval:1];
        ((_DCXLabelFormatter*)formatter).stepSupplementary = NO;
    }
    return @{ @"globalRange": range, @"beginRange": range, @"xformatter": formatter};
}

-(void)customizeView:(DCXYChartView *)view {
    view.acceptPan = NO;
}

-(NSString*)getSeriesKeyByTarget:(REMEnergyTargetModel *)target seriesIndex:(NSUInteger)index {
    return [NSString stringWithFormat:@"%p", target];
}

-(DCLineSymbolType)getSymbolTypeByIndex:(NSUInteger)index {
    return DCLineSymbolTypeRound;
}

-(DCSeriesStatus*)getDefaultSeriesState:(REMEnergyTargetModel*)target seriesIndex:(NSUInteger)index {
    DCSeriesStatus* state = [[DCSeriesStatus alloc]init];
    state.seriesKey = [self getSeriesKeyByTarget:target seriesIndex:index];
    state.seriesType = DCSeriesTypeStatusLine;
    state.avilableTypes = DCSeriesTypeStatusLine;
    state.forcedColor = [self getSeriesColorByIndex:(int)index];
    state.visible = YES;
    return state;
}



-(NSUInteger)getSeriesAmount {
    const int maxSeriesAmount = 10;
    if (self.energyViewData.targetEnergyData.count <= maxSeriesAmount) {
        return self.energyViewData.targetEnergyData.count;
    } else {
        for (REMTargetEnergyData* t in self.energyViewData.targetEnergyData) {
            if (t.target.type == REMEnergyTargetTag) {
                return maxSeriesAmount;
            }
        }
        return maxSeriesAmount - 1;
    }
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
