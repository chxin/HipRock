//
//  _DCXLabelFormatter.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/21/13.
//
//

#import "_DCXLabelFormatter.h"
#import "REMTimeHelper.h"

@implementation _DCXLabelFormatter
-(_DCXLabelFormatter*)initWithStartDate:(NSDate*)startDate dataStep:(REMEnergyStep)step interval:(int)interval {
    self = [super init];
    if (self) {
        _startDate = startDate;
        _interval = interval;
        _step = step;
        _stepSupplementary = YES;
    }
    return self;
}
- (NSString *)stringForObjectValue:(id)obj {
    if (self.interval == 0) return REMEmptyString;
    int xVal = ((NSNumber*)obj).integerValue;
    if (xVal % self.interval == 0) {
        NSDate* date = nil;
        NSString* format = nil;
        if (self.step == REMEnergyStepHour) {
            date = [self.startDate dateByAddingTimeInterval:xVal*3600];
            if ([REMTimeHelper getHour:date] < self.interval && self.stepSupplementary) {
                format = NSLocalizedString(@"Chart_X_Axis_Format_DayHour", REMEmptyString);
            } else {
                format = NSLocalizedString(@"Chart_X_Axis_Format_Hour", REMEmptyString);
            }
        } else if (self.step == REMEnergyStepDay) {
            date = [self.startDate dateByAddingTimeInterval:xVal*86400];
            if ([REMTimeHelper getDay:date] <= self.interval && self.stepSupplementary) {
                format = NSLocalizedString(@"Chart_X_Axis_Format_MonthDay", REMEmptyString);
            } else {
                format = NSLocalizedString(@"Chart_X_Axis_Format_Day", REMEmptyString);
            }
        } else if (self.step == REMEnergyStepWeek) {
            date = [self.startDate dateByAddingTimeInterval:xVal*604800];
            format = NSLocalizedString(@"Chart_X_Axis_Format_MonthDay", REMEmptyString);
        } else if (self.step == REMEnergyStepMonth) {
            date = [REMTimeHelper addMonthToDate:self.startDate month:xVal];
            if ([REMTimeHelper getMonth:date] <= self.interval && self.stepSupplementary) {
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

-(double)getMaxXLabelLengthIn:(CGRect)plotRect {
    return INT32_MAX;
}
@end
