//
//  REMXFormatter.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by Zilong-Oscar.Xu on 10/10/13.
//
//

#import "REMChartHeader.h"

@implementation REMXFormatter {
    NSDateFormatter *dateFormatter;
}
-(REMXFormatter*)initWithStartDate:(NSDate*)startDate dataStep:(REMEnergyStep)step interval:(int)interval {
    self = [super init];
    if (self) {
        _startDate = startDate;
        _interval = interval;
        _step = step;
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    return self;
}
- (NSString *)stringForObjectValue:(id)obj {
    //    return ((NSNumber*)obj).stringValue;
    if (self.interval == 0) return nil;
    int xVal = ((NSNumber*)obj).integerValue;
    if (xVal % self.interval == 0 && xVal >= 0) {
        NSDate* date = nil;
        if (self.step == REMEnergyStepHour) {
            date = [self.startDate dateByAddingTimeInterval:xVal*3600];
            date = [REMTimeHelper convertLocalDateToGMT:date];
            if ([REMTimeHelper getHour:date] < self.interval) {
                [dateFormatter setDateFormat:@"d日h点"];
            } else {
                [dateFormatter setDateFormat:@"h点"];
            }
        } else if (self.step == REMEnergyStepDay) {
            date = [self.startDate dateByAddingTimeInterval:xVal*86400];
            date = [REMTimeHelper convertLocalDateToGMT:date];
            if ([REMTimeHelper getDay:date] <= self.interval) {
                [dateFormatter setDateFormat:@"M月-d日"];
            } else {
                [dateFormatter setDateFormat:@"d日"];
            }
        } else if (self.step == REMEnergyStepWeek) {
            date = [self.startDate dateByAddingTimeInterval:xVal*604800];
            date = [REMTimeHelper convertLocalDateToGMT:date];
            [dateFormatter setDateFormat:@"M月-d日"];
        } else if (self.step == REMEnergyStepMonth) {
            date = [REMTimeHelper addMonthToDate:self.startDate month:xVal];
            date = [REMTimeHelper convertLocalDateToGMT:date];
            if ([REMTimeHelper getMonth:date] <= self.interval) {
                [dateFormatter setDateFormat:@"yyyy年-M月"];
            } else {
                [dateFormatter setDateFormat:@"M月"];
            }
        } else if (self.step == REMEnergyStepYear) {
            date = [REMTimeHelper addMonthToDate:self.startDate month:xVal*12];
            date = [REMTimeHelper convertLocalDateToGMT:date];
            [dateFormatter setDateFormat:@"yyyy年"];
        }
        return [dateFormatter stringFromDate:date];
    } else {
        return @"";
    }
}
@end
