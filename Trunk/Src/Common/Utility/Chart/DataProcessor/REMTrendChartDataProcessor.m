//
//  REMTrendChartDataProcessor.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/12/13.
//
//

#import "REMChartHeader.h"
#import "REMTimeHelper.h"

@implementation REMTrendChartDataProcessor

-(NSNumber*)processX:(REMEnergyData*)point startDate:(NSDate*)startDate step:(REMEnergyStep)step  {
    float x = 0;
    if (step == REMEnergyStepHour || step == REMEnergyStepDay || step == REMEnergyStepWeek) {
        x = [point.localTime timeIntervalSinceDate:startDate] / (step == REMEnergyStepHour ? 3600 : (step == REMEnergyStepDay ? 86400 : 604800));
    } else if (step == REMEnergyStepYear) {
        x = [REMTimeHelper getYear:point.localTime] - [REMTimeHelper getYear:startDate];
    } else {
        x = ([REMTimeHelper getYear:point.localTime] - [REMTimeHelper getYear:startDate]) * 12 + [REMTimeHelper getMonth:point.localTime] - [REMTimeHelper getMonth:startDate];
    }
    return [NSNumber numberWithFloat:x];
}
-(NSDate*)deprocessX:(float)x startDate:(NSDate*)startDate step:(REMEnergyStep)step {
    if (step == REMEnergyStepHour || step == REMEnergyStepDay || step == REMEnergyStepWeek) {
        float i = (step == REMEnergyStepHour ? 3600 : (step == REMEnergyStepDay ? 86400 : 604800));
        return[NSDate dateWithTimeInterval:i*x sinceDate:startDate];
    } else if (step == REMEnergyStepYear) {
        int monthToAdd = 12*x;
        return [REMTimeHelper addMonthToDate:startDate month:monthToAdd];
    } else {
        int monthToAdd = x;
        return [REMTimeHelper addMonthToDate:startDate month:monthToAdd];
    }
}
@end
