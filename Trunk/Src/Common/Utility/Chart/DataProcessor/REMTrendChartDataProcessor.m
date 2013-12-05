/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTrendChartDataProcessor.m
 * Created      : Zilong-Oscar.Xu on 9/12/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMChartHeader.h"
#import "REMTimeHelper.h"

@implementation REMTrendChartDataProcessor

-(NSNumber*)processX:(NSDate*)xLocalTime {
    float x = 0;
    REMEnergyStep step = self.step;
    NSDate* startDate = self.baseDate;
    if (step == REMEnergyStepHour || step == REMEnergyStepDay || step == REMEnergyStepWeek) {
        x = [xLocalTime timeIntervalSinceDate:startDate] / (step == REMEnergyStepHour ? 3600.0 : (step == REMEnergyStepDay ? 86400.0 : 604800.0));
    } else {
        double year = ((double)[REMTimeHelper getYear:xLocalTime] - (double)[REMTimeHelper getYear:startDate]);
        double month =(double)[REMTimeHelper getMonth:xLocalTime] - (double)[REMTimeHelper getMonth:startDate];
        double date = (double)[REMTimeHelper getDay:xLocalTime]-(double)[REMTimeHelper getDay:startDate];
        x = year * 12.0 + month + date/30;
        if (step == REMEnergyStepYear) {
            x = x/12;
        }
    }
    return [NSNumber numberWithFloat:x];
}
-(NSDate*)deprocessX:(float)x {
    REMEnergyStep step = self.step;
    NSDate* startDate = self.baseDate;
    if (step == REMEnergyStepHour || step == REMEnergyStepDay || step == REMEnergyStepWeek) {
        float i = (step == REMEnergyStepHour ? 3600.0 : (step == REMEnergyStepDay ? 86400.0 : 604800.0));
        return[NSDate dateWithTimeInterval:i*x sinceDate:startDate];
    } else {
        double monthToAdd = x;
        if (step == REMEnergyStepYear) {
            monthToAdd*=12;
        }
        int monthToAddInt = monthToAdd;
        NSDate* d = [REMTimeHelper addMonthToDate:startDate month:monthToAddInt];
        d = [NSDate dateWithTimeInterval:28*24*3600*(monthToAdd-(double)monthToAddInt) sinceDate:d];
        return d;
    }
}
@end
