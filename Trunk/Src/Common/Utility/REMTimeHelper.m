//
//  REMTimeHelper.m
//  Blues
//
//  Created by TanTan on 7/11/13.
//
//

#import "REMTimeHelper.h"

@implementation REMTimeHelper



+ (long long)longLongFromJSONString:(NSString *)jsonDate
{
    if(jsonDate == nil || [jsonDate isEqual:[NSNull null]]==YES){
        return 0;
    }
    
    
    NSError *error;
    NSRegularExpression *regex= [NSRegularExpression regularExpressionWithPattern:@"\\d+" options:0 error:&error];
    
    if(error == nil)
    {
        NSArray *matched= [regex matchesInString:jsonDate options:0 range:NSMakeRange(0, jsonDate.length)];
        NSTextCheckingResult *result= matched[0];
        NSString *ret= [jsonDate substringWithRange:result.range];
        return [ret longLongValue];
    }
    else
    {
        REMLogError(@"time parse error:%@",error);
    }
    
    return 0;
}

+ (NSNumber *)numberFromJSONString:(NSString *)jsonDate
{
    long long ret= [REMTimeHelper longLongFromJSONString:jsonDate];
    
    return [NSNumber numberWithLongLong:ret];
}

+ (NSDate *) getDate:(NSDate *)fromDate daysAhead:(NSInteger)days
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = days;
    NSCalendar *calendar = [REMTimeHelper currentCalendar];
    NSDate *previousDate = [calendar dateByAddingComponents:dateComponents
                                                     toDate:fromDate
                                                    options:0];
    return previousDate;
}

+ (NSDate *)add:(int)difference onPart:(REMDateTimePart)part ofDate:(NSDate *)date;
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    switch (part) {
        case REMDateTimePartSecond:
            [components setSecond:difference];
            break;
        case REMDateTimePartMinute:
            [components setMinute:difference];
            break;
        case REMDateTimePartHour:
            [components setHour:difference];
            break;
        case REMDateTimePartDay:
            [components setDay:difference];
            break;
        case REMDateTimePartMonth:
            [components setMonth:difference];
            break;
        case REMDateTimePartYear:
            [components setYear:difference];
            break;
            
        default:
            break;
    }
    
    return [calendar dateByAddingComponents:components toDate:date options:0];
}


+ (NSUInteger)getYear:(NSDate *)date {
    NSCalendar *calendar = [REMTimeHelper currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSYearCalendarUnit) fromDate:date];
    
    return [dayComponents year];
}


+ (NSUInteger)getMonth:(NSDate *)date{
    NSCalendar *calendar = [REMTimeHelper currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSMonthCalendarUnit) fromDate:date];
    
    return [dayComponents month];
}


+ (NSUInteger)getDay:(NSDate *)date {
    NSCalendar *calendar = [REMTimeHelper currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSDayCalendarUnit) fromDate:date];
    
    return [dayComponents day];
}

+ (int )getHour:(NSDate *)date  {
    NSCalendar *calendar = [REMTimeHelper currentCalendar];
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    NSInteger hour = [components hour];
    
    return (int)hour;
}


+ (int)getMinute:(NSDate *)date {
    NSCalendar *calendar = [REMTimeHelper currentCalendar];
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    NSInteger minute = [components minute];
    
    return (int)minute;
}


+ (REMTimeRange *)relativeDateFromString:(NSString *)relativeDateString
{
    NSDate *start,*end;
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    if ([relativeDateString isEqualToString:@"Last7Day"] == YES) {

        

        NSDate *last7day = [REMTimeHelper getDate:[NSDate date] daysAhead:-7];
        
        NSDateComponents *last7dayEndComps = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:last7day];
        [last7dayEndComps setMinute:0];
        [last7dayEndComps setHour:0];
        [last7dayEndComps setSecond:0];
        
        NSDateComponents *todayComps = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
        [todayComps setMinute:0];
        [todayComps setHour:0];
        [todayComps setSecond:0];

        end = [calendar dateFromComponents:todayComps];
        start = [calendar dateFromComponents:last7dayEndComps];
    }
    else if([relativeDateString isEqualToString:@"Today"] == YES)
    {
        NSDate *today = [NSDate date];
        NSDateComponents *todayEndComps = [calendar components:( NSHourCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [todayEndComps setMinute:0];
        [todayEndComps setSecond:0];
        
        NSDateComponents *todayStartComps = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [todayStartComps setMinute:0];
        [todayStartComps setSecond:0];
        [todayStartComps setHour:0];
        end = [calendar dateFromComponents:todayEndComps];
        start = [calendar dateFromComponents:todayStartComps];
    }
    else if([relativeDateString isEqualToString:@"Yesterday"] == YES)
    {
        NSDate *today = [NSDate date];
        NSDateComponents *todayEndComps = [calendar components:( NSHourCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [todayEndComps setMinute:0];
        [todayEndComps setSecond:0];
        [todayEndComps setHour:0];
        
        NSDateComponents *yesterday = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [yesterday setMinute:0];
        [yesterday setSecond:0];
        [yesterday setHour:0];
        
        [yesterday setDay:todayEndComps.day-1];
        
        end = [calendar dateFromComponents:todayEndComps];
        start = [calendar dateFromComponents:yesterday];
    }
    else if([relativeDateString isEqualToString:@"LastMonth"] == YES)
    {
        NSDate *today = [NSDate date];
        NSDateComponents *todayEndComps = [calendar components:( NSHourCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [todayEndComps setMinute:0];
        [todayEndComps setSecond:0];
        [todayEndComps setHour:0];
        
        NSDateComponents *firstDayOfMonth = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [firstDayOfMonth setMinute:0];
        [firstDayOfMonth setSecond:0];
        [firstDayOfMonth setHour:0];
        [firstDayOfMonth setDay:1];
        
        NSDateComponents *firstDayOfLastMonth = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[calendar dateFromComponents: firstDayOfMonth]];
        
        [firstDayOfLastMonth setMonth:firstDayOfMonth.month-1];
        
        end = [calendar dateFromComponents:firstDayOfMonth];
        start = [calendar dateFromComponents:firstDayOfLastMonth];
    }
    else if([relativeDateString isEqualToString:@"ThisWeek"] == YES)
    {
        NSDate *today = [NSDate date];
        NSDateComponents *todayEndComps = [calendar components:( NSWeekdayCalendarUnit| NSHourCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [todayEndComps setMinute:0];
        [todayEndComps setSecond:0];
        [todayEndComps setHour:0];
        
        NSDateComponents *firstDayOfThisWeek = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        
        [firstDayOfThisWeek setDay:([todayEndComps day] - ([todayEndComps weekday] - 2))];
        
        
        end = [calendar dateFromComponents:todayEndComps];
        start = [calendar dateFromComponents:firstDayOfThisWeek];
    }
    else if([relativeDateString isEqualToString:@"LastWeek"] == YES)
    {
        NSDate *today = [NSDate date];
        NSDateComponents *todayEndComps = [calendar components:(NSWeekdayCalendarUnit| NSHourCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [todayEndComps setMinute:0];
        [todayEndComps setSecond:0];
        [todayEndComps setHour:0];
        
        NSDateComponents *firstDayOfThisWeek = [calendar components:(NSWeekdayCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [firstDayOfThisWeek setDay:([todayEndComps day] - ([todayEndComps weekday] - 2))];
        
        NSDateComponents *firstDayOfLastWeek = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[calendar dateFromComponents: firstDayOfThisWeek]];
        [firstDayOfLastWeek setDay:firstDayOfThisWeek.day-7];
        
        
        end = [calendar dateFromComponents:firstDayOfThisWeek];
        start = [calendar dateFromComponents:firstDayOfLastWeek];
    }
    else if([relativeDateString isEqualToString:@"ThisMonth"] == YES)
    {
        NSDate *today = [NSDate date];
        NSDateComponents *todayEndComps = [calendar components:( NSHourCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [todayEndComps setMinute:0];
        [todayEndComps setSecond:0];
        [todayEndComps setHour:0];
        
        NSDateComponents *firstDayOfMonth = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [firstDayOfMonth setMinute:0];
        [firstDayOfMonth setSecond:0];
        [firstDayOfMonth setHour:0];
        [firstDayOfMonth setDay:1];
        end = [calendar dateFromComponents:todayEndComps];
        start = [calendar dateFromComponents:firstDayOfMonth];
    }
    else if([relativeDateString isEqualToString:@"ThisYear"] == YES)
    {
        NSDate *today = [NSDate date];
        NSDateComponents *todayComps = [calendar components:( NSHourCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [todayComps setMinute:0];
        [todayComps setSecond:0];
        [todayComps setHour:0];
        
        NSDateComponents *firstDayOfYear = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [firstDayOfYear setMinute:0];
        [firstDayOfYear setSecond:0];
        [firstDayOfYear setHour:0];
        [firstDayOfYear setDay:1];
        [firstDayOfYear setMonth:1];
        end = [calendar dateFromComponents:todayComps];
        start = [calendar dateFromComponents:firstDayOfYear];
    }
    else if([relativeDateString isEqualToString:@"LastYear"] == YES)
    {
        NSDate *today = [NSDate date];
        NSDateComponents *todayComps = [calendar components:( NSHourCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [todayComps setMinute:0];
        [todayComps setSecond:0];
        [todayComps setHour:0];
        [todayComps setMonth:1];
        [todayComps setDay:1];
        
        NSDateComponents *lastYearComps = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [lastYearComps setMinute:0];
        [lastYearComps setSecond:0];
        [lastYearComps setHour:0];
        [lastYearComps setDay:1];
        [lastYearComps setMonth:1];
        [lastYearComps setYear:todayComps.year-1];
        end = [calendar dateFromComponents:todayComps];
        start = [calendar dateFromComponents:lastYearComps];
    }
    
    
    return [[REMTimeRange alloc]initWithStartTime:start EndTime:end];
}

+(NSDate*)dateFromYear:(int)year Month:(int)month Day:(int)day
{
    NSString *date = [NSString stringWithFormat:@"%4d-%02d-%02d", year, month, day];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    return [formater dateFromString:date];
}

// returns days amount of a date object
+(NSUInteger)getDaysOfDate: (NSDate*)date {
    return [[REMTimeHelper currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
}

+(NSDate*)addMonthToDate:(NSDate*)date month:(NSInteger)month {
    NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
    [dateComponents setMonth:month];
    NSCalendar* calendar = [REMTimeHelper currentCalendar];
    return [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
}

+ (NSString *)formatTimeFullHour:(NSDate *)date
{
    NSDateFormatter *f = [[NSDateFormatter alloc]init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [f stringFromDate:date];
}


+ (REMTimeRange *) maxTimeRangeOfTimeRanges:(NSArray *)timeRanges
{
    NSTimeInterval startInterval = INT64_MAX;
    NSTimeInterval endInterval = INT64_MIN;
    
    for(int i=0;i<timeRanges.count; i++)
    {
        REMTimeRange *timeRange = (REMTimeRange *)timeRanges[i];
        
        if([timeRange.startTime timeIntervalSince1970]<startInterval)
            startInterval = [timeRange.startTime timeIntervalSince1970];
        if([timeRange.endTime timeIntervalSince1970]>endInterval)
            endInterval = [timeRange.endTime timeIntervalSince1970];
    }
    
    return [[REMTimeRange alloc] initWithStartTime:[NSDate dateWithTimeIntervalSince1970:startInterval] EndTime:[NSDate dateWithTimeIntervalSince1970:endInterval]];

}



+(NSNumber *)getMonthTicksFromDate:(NSDate *)date
{
    NSInteger monthTicks = [REMTimeHelper getYear:date] * 12 + [REMTimeHelper getMonth:date] - 1;
    
    return [NSNumber numberWithInt:monthTicks];
}

+(NSDate *)getDateFromMonthTicks:(NSNumber *)monthTicks
{
    int year = [monthTicks intValue] / 12;
    int month = [monthTicks intValue] % 12;
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:1];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    return [[REMTimeHelper gregorianCalendar] dateFromComponents:components];
}

+(NSDate *)today
{
    NSDate *now = [NSDate date];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:[REMTimeHelper getYear:now]];
    [components setMonth:[REMTimeHelper getMonth:now]];
    [components setDay:[REMTimeHelper getDay:now]];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    return [[REMTimeHelper gregorianCalendar] dateFromComponents:components];
}

+(NSDate *)tomorrow
{
    return [REMTimeHelper add:1 onPart:REMDateTimePartDay ofDate:[REMTimeHelper today]];
}

static NSCalendar *_gregorianCalendar;
+(NSCalendar *)gregorianCalendar
{
    if(_gregorianCalendar == nil)
        _gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    return _gregorianCalendar;
}

static NSCalendar *_currentCalendar;
+(NSCalendar *)currentCalendar
{
    if(_currentCalendar == nil)
        _currentCalendar = [NSCalendar currentCalendar];
    
    return _currentCalendar;
}

+(NSDate *)convertLocalDateToGMT:(NSDate *)localDate
{
    NSTimeInterval timeZoneOffset = [[NSTimeZone timeZoneWithName:@"Asia/Shanghai"] secondsFromGMT];
    NSTimeInterval gmtTimeInterval = [localDate timeIntervalSinceReferenceDate] - timeZoneOffset;
    NSDate *gmtDate = [NSDate dateWithTimeIntervalSinceReferenceDate:gmtTimeInterval];
    
    return gmtDate;
}

+(NSDate *)convertGMTDateToLocal:(NSDate *)GMTDate
{
    NSTimeInterval timeZoneOffset = [[NSTimeZone timeZoneWithName:@"Asia/Shanghai"] secondsFromGMT];
    NSTimeInterval localTimeInterval = [GMTDate timeIntervalSinceReferenceDate] + timeZoneOffset;
    NSDate *localDate = [NSDate dateWithTimeIntervalSinceReferenceDate:localTimeInterval];
    
    return localDate;
}

@end
