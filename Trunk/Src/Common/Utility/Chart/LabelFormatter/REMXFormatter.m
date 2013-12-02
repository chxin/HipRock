/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMXFormatter.m
 * Created      : Zilong-Oscar.Xu on 10/10/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMChartHeader.h"

@implementation REMXFormatter
-(REMXFormatter*)initWithStartDate:(NSDate*)startDate dataStep:(REMEnergyStep)step interval:(int)interval {
    self = [super init];
    if (self) {
        _startDate = startDate;
        _interval = interval;
        _step = step;
    }
    return self;
}
- (NSString *)stringForObjectValue:(id)obj {
    if (self.interval == 0) return REMEmptyString;
    int xVal = ((NSNumber*)obj).integerValue;
    if (xVal % self.interval == 0 && xVal >= 0) {
        NSDate* date = nil;
        NSString* format = nil;
        if (self.step == REMEnergyStepHour) {
            date = [self.startDate dateByAddingTimeInterval:xVal*3600];
            if ([REMTimeHelper getHour:date] < self.interval) {
                format = NSLocalizedString(@"Chart_X_Axis_Format_DayHour", REMEmptyString);
            } else {
                format = NSLocalizedString(@"Chart_X_Axis_Format_Hour", REMEmptyString);
            }
        } else if (self.step == REMEnergyStepDay) {
            date = [self.startDate dateByAddingTimeInterval:xVal*86400];
            if ([REMTimeHelper getDay:date] <= self.interval) {
                format = NSLocalizedString(@"Chart_X_Axis_Format_MonthDay", REMEmptyString);
            } else {
                format = NSLocalizedString(@"Chart_X_Axis_Format_Day", REMEmptyString);
            }
        } else if (self.step == REMEnergyStepWeek) {
            date = [self.startDate dateByAddingTimeInterval:xVal*604800];
            format = NSLocalizedString(@"Chart_X_Axis_Format_MonthDay", REMEmptyString);
        } else if (self.step == REMEnergyStepMonth) {
            date = [REMTimeHelper addMonthToDate:self.startDate month:xVal];
            if ([REMTimeHelper getMonth:date] <= self.interval) {
                format = NSLocalizedString(@"Chart_X_Axis_Format_YearMonth", REMEmptyString);
            } else {
                format = NSLocalizedString(@"Chart_X_Axis_Format_Month", REMEmptyString);
            }
        } else if (self.step == REMEnergyStepYear) {
            date = [REMTimeHelper addMonthToDate:self.startDate month:xVal*12];
            format = NSLocalizedString(@"Chart_X_Axis_Format_Year", REMEmptyString);
        } else {
            return [NSString stringWithFormat:@"%i", xVal];
        }
        return [REMTimeHelper formatTime:date withFormat:format];
    } else {
        return REMEmptyString;
    }
}
@end
