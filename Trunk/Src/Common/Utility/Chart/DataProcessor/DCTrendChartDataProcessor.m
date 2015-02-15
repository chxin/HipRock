//
//  DCTrendChartDataProcessor.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 3/14/14.
//
//

#import "DCTrendChartDataProcessor.h"
#import "REMTimeHelper.h"

@implementation DCTrendChartDataProcessor
-(NSNumber*)processX:(NSDate*)xLocalTime {
    float x = 0;
    REMEnergyStep step = self.step;
    NSDate* startDate = self.baseDate;
//    if (step == REMEnergyStepHour || step == REMEnergyStepDay || step == REMEnergyStepWeek || step == REMEnergyStepRaw) {
//        x = [xLocalTime timeIntervalSinceDate:startDate] / (step == REMEnergyStepRaw ? 900.0 : (step == REMEnergyStepHour ? 3600.0 : (step == REMEnergyStepDay ? 86400.0 : 604800.0)));
//    }
    if (step == REMEnergyStepHour || step == REMEnergyStepDay || step == REMEnergyStepWeek || step == REMEnergyStepMin15 || step == REMEnergyStepMin30) {
        NSTimeInterval length = 604800.0;
        switch (step) {
            case REMEnergyStepMin15:
                length = 900.0;
                break;
            case REMEnergyStepMin30:
                length = 1800.0;
                break;
            case REMEnergyStepHour:
                length = 3600.0;
                break;
            case REMEnergyStepDay:
                length = 86400.0;
                break;
                
            default:
                length = 604800.0;
                break;
        }
//        x = [xLocalTime timeIntervalSinceDate:startDate] / (step == REMEnergyStepRaw ? 900.0 : (step == REMEnergyStepHour ? 3600.0 : (step == REMEnergyStepDay ? 86400.0 : 604800.0)));
        x = [xLocalTime timeIntervalSinceDate:startDate] / length;
    }
    else {
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
    if (x == 0) return self.baseDate.copy;
    REMEnergyStep step = self.step;
    NSDate* startDate = self.baseDate;
//    if (step == REMEnergyStepRaw || step == REMEnergyStepHour || step == REMEnergyStepDay || step == REMEnergyStepWeek) {
//        float i = (step == REMEnergyStepRaw ? 900.0 : (step == REMEnergyStepHour ? 3600.0 : (step == REMEnergyStepDay ? 86400.0 : 604800.0)));
//        return[NSDate dateWithTimeInterval:i*x sinceDate:startDate];
    //    }
    if (step == REMEnergyStepHour || step == REMEnergyStepDay || step == REMEnergyStepWeek || step == REMEnergyStepMin15 || step == REMEnergyStepMin30) {
        NSTimeInterval length = 604800.0;
        switch (step) {
            case REMEnergyStepMin15:
                length = 900.0;
                break;
            case REMEnergyStepMin30:
                length = 1800.0;
                break;
            case REMEnergyStepHour:
                length = 3600.0;
                break;
            case REMEnergyStepDay:
                length = 86400.0;
                break;
                
            default:
                length = 604800.0;
                break;
        }
        
        return[NSDate dateWithTimeInterval:length*x sinceDate:startDate];
    }
    else {
        double monthToAdd = x;
        if (step == REMEnergyStepYear) {
            monthToAdd*=12;
        }
        int monthToAddInt = monthToAdd;
        NSDate* d = [REMTimeHelper addMonthToDate:startDate month:monthToAddInt];
        //        NSLog(@"this:%@ %f", d, x);
        d = [NSDate dateWithTimeInterval:28*24*3600*(monthToAdd-(double)monthToAddInt) sinceDate:d];
        //        NSLog(@"that:%@ %f", d,x);
        return d;
    }
}
@end
