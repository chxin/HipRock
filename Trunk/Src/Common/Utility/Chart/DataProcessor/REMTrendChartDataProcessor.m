//
//  REMTrendChartDataProcessor.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by Zilong-Oscar.Xu on 9/12/13.
//
//

#import "REMChartHeader.h"
#import "REMTimeHelper.h"

@implementation REMTrendChartDataProcessor

-(NSNumber*)processX:(NSDate*)xLocalTime {
    float x = 0;
    REMEnergyStep step = self.step;
    NSDate* startDate = self.baseDate;
    if (step == REMEnergyStepHour || step == REMEnergyStepDay || step == REMEnergyStepWeek) {
        x = [xLocalTime timeIntervalSinceDate:startDate] / (step == REMEnergyStepHour ? 3600 : (step == REMEnergyStepDay ? 86400 : 604800));
    } else if (step == REMEnergyStepYear) {
        x = (int)[REMTimeHelper getYear:xLocalTime] - (int)[REMTimeHelper getYear:startDate];
    } else {
        x = ((int)[REMTimeHelper getYear:xLocalTime] - (int)[REMTimeHelper getYear:startDate]) * 12 + (int)[REMTimeHelper getMonth:xLocalTime] - (int)[REMTimeHelper getMonth:startDate];
    }
    return [NSNumber numberWithFloat:x];
}
-(NSDate*)deprocessX:(float)x {
    REMEnergyStep step = self.step;
    NSDate* startDate = self.baseDate;
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
