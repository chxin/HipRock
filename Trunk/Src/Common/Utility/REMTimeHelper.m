/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTimeHelper.m
 * Created      : TanTan on 7/11/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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

+ (NSString *)jsonStringFromDate:(NSDate *)date
{
    long long time=(long long)([date timeIntervalSince1970]*1000);
    NSString *str= [NSString stringWithFormat:@"/Date(%lld)/",time];
    return str;
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

+ (NSDate *) getDate:(NSDate *)fromDate monthsAhead:(NSInteger)months
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = months;
    NSCalendar *calendar = [REMTimeHelper currentCalendar];
    NSDate *previousDate = [calendar dateByAddingComponents:dateComponents
                                                     toDate:fromDate
                                                    options:0];
    return previousDate;
}

+ (NSDate *)getNextMondayFromDate:(NSDate *)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit fromDate:date];
    
    NSUInteger weekdayToday = [components weekday];
    
    if (weekdayToday==2 && [components hour]==0) {
        return date;
    }
    [components setHour:0];
    NSInteger daysToMonday = (9 - weekdayToday) % 7;
    
    NSDate *nextMonday = [date dateByAddingTimeInterval:60*60*24*daysToMonday];
    
    return nextMonday;
}

+ (NSDate *)add:(int)difference onPart:(REMDateTimePart)part ofDate:(NSDate *)date;
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
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

+ (NSUInteger)getYear:(NSDate *)date withCalendar:(NSCalendar *)calendar{
    NSDateComponents *dayComponents = [calendar components:(NSYearCalendarUnit) fromDate:date];
    
    return [dayComponents year];
}

+ (NSUInteger)getYear:(NSDate *)date {
    return [REMTimeHelper getYear:date withCalendar:[REMTimeHelper currentCalendar]];
}

+ (NSUInteger)getMonth:(NSDate *)date withCalendar:(NSCalendar *)calendar{
    
    NSDateComponents *dayComponents = [calendar components:(NSMonthCalendarUnit) fromDate:date];
    
    return [dayComponents month];
}

+ (NSUInteger)getMonth:(NSDate *)date{
    
    return [REMTimeHelper getMonth:date withCalendar:[REMTimeHelper currentCalendar]];
}

+ (NSUInteger)getWeekDay:(NSDate *)date {
    NSCalendar *calendar = [REMTimeHelper currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSWeekdayCalendarUnit) fromDate:date];
    
    return [dayComponents weekday];
}


+ (NSUInteger)getDay:(NSDate *)date {
    return [REMTimeHelper getDay:date withCalendar:[REMTimeHelper currentCalendar]];
    
}

+ (NSUInteger)getDay:(NSDate *)date withCalendar:(NSCalendar *)calendar{
    
    NSDateComponents *dayComponents = [calendar components:(NSDayCalendarUnit) fromDate:date];
    
    return [dayComponents day];
}
+ (int)getHour:(NSDate *)date withCalendar:(NSCalendar *)calendar{
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    NSInteger hour = [components hour];
    
    return (int)hour;
}
+ (int )getHour:(NSDate *)date  {
    return [REMTimeHelper getHour:date withCalendar:[REMTimeHelper currentCalendar]];
}

+ (int )getTimePart:(REMDateTimePart)timePart ofLocalDate:(NSDate *)date  {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    
    switch (timePart) {
        case REMDateTimePartHour:
            return [components hour];
        case REMDateTimePartDay:
            return [components day];
        case REMDateTimePartMonth:
            return [components month];
        case REMDateTimePartYear:
            return [components year];
            
        default:
            return [components hour];
            break;
    }
}

+ (int)getMinute:(NSDate *)date withCalendar:(NSCalendar *)calendar{
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    NSInteger minute = [components minute];
    
    return (int)minute;
}

+ (int)getMinute:(NSDate *)date {
    return [REMTimeHelper getMinute:date withCalendar:[REMTimeHelper currentCalendar]];
}

+ (NSString *)relativeDateComponentFromType:(REMRelativeTimeRangeType)relativeDateType{
    if(relativeDateType == REMRelativeTimeRangeTypeNone ){
        return REMIPadLocalizedString(@"Common_CustomTime"); //@"自定义";
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeLast7Days){
        return REMIPadLocalizedString(@"Common_Last7Day"); //@"之前七天";
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeToday){
        return REMIPadLocalizedString(@"Common_Today"); //@"今天";
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeYesterday){
        return REMIPadLocalizedString(@"Common_Yesterday"); //@"昨天";
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeThisMonth){
        return REMIPadLocalizedString(@"Common_ThisMonth"); //@"本月";
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeLastMonth){
        return REMIPadLocalizedString(@"Common_LastMonth"); //@"上月";
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeThisWeek){
        return REMIPadLocalizedString(@"Common_ThisWeek"); //@"本周";
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeLastWeek){
        return REMIPadLocalizedString(@"Common_LastWeek"); //@"上周";
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeThisYear){
        return REMIPadLocalizedString(@"Common_ThisYear"); //@"今年";
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeLastYear){
        return REMIPadLocalizedString(@"Common_LastYear"); //@"去年";
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeLast30Day){
        return REMIPadLocalizedString(@"Common_Last30Days");
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeLast12Month){
        return REMIPadLocalizedString(@"Common_Last12Months");
    }
    else{
        return REMIPadLocalizedString(@"Common_CustomTime"); //@"自定义";
    }

}

+ (REMTimeRange *) relativeDateFromType:(REMRelativeTimeRangeType)relativeDateType
{
    NSDate *start,*end;
    NSCalendar *calendar = [REMTimeHelper currentCalendar];
    NSCalendar *calendarWithZone=[NSCalendar currentCalendar];
    
    if (relativeDateType == REMRelativeTimeRangeTypeLast7Days) {
        NSDate *last7day = [REMTimeHelper getDate:[NSDate date] daysAhead:-7];
        
        NSDateComponents *last7dayEndComps = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:last7day];
        [last7dayEndComps setMinute:0];
        [last7dayEndComps setHour:0];
        [last7dayEndComps setSecond:0];
        
        NSDateComponents *todayComps = [calendarWithZone components:(NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
        [todayComps setMinute:0];
        [todayComps setSecond:0];

        end = [calendar dateFromComponents:todayComps];
        start = [calendar dateFromComponents:last7dayEndComps];
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeToday)
    {
        NSDate *today = [NSDate date];
        NSDateComponents *todayEndComps = [calendarWithZone components:( NSHourCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [todayEndComps setMinute:0];
        [todayEndComps setSecond:0];
        [todayEndComps setYear:todayEndComps.year];
        [todayEndComps setMonth:todayEndComps.month];
        [todayEndComps setDay:todayEndComps.day];
        
        NSDateComponents *todayStartComps = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [todayStartComps setMinute:0];
        [todayStartComps setSecond:0];
        [todayStartComps setHour:0];
        end = [calendar dateFromComponents:todayEndComps];
        start = [calendar dateFromComponents:todayStartComps];
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeYesterday)
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
    else if(relativeDateType == REMRelativeTimeRangeTypeLastMonth)
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
    else if(relativeDateType == REMRelativeTimeRangeTypeThisWeek)
    {
        NSDate *today = [NSDate date];
        NSDateComponents *todayEndComps = [calendarWithZone components:( NSWeekdayCalendarUnit| NSHourCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [todayEndComps setMinute:0];
        [todayEndComps setSecond:0];
        [todayEndComps setYear:todayEndComps.year];
        [todayEndComps setMonth:todayEndComps.month];
        [todayEndComps setDay:todayEndComps.day];
        
        NSDateComponents *firstDayOfThisWeek = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        
        int gap=todayEndComps.weekday-2;
        if(gap<0) gap=6;
        
        [firstDayOfThisWeek setDay:([todayEndComps day] - gap)];
        
        
        end = [calendar dateFromComponents:todayEndComps];
        start = [calendar dateFromComponents:firstDayOfThisWeek];
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeLastWeek)
    {
        NSDate *today = [NSDate date];
        NSDateComponents *todayEndComps = [calendar components:(NSWeekdayCalendarUnit| NSHourCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [todayEndComps setMinute:0];
        [todayEndComps setSecond:0];
        [todayEndComps setHour:0];
        
        NSDateComponents *firstDayOfThisWeek = [calendar components:(NSWeekdayCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [firstDayOfThisWeek setDay:([todayEndComps day] - ([todayEndComps weekday] - 2))];
        
        end = [calendar dateFromComponents:firstDayOfThisWeek];
        start = [REMTimeHelper getDate:end daysAhead:-7];
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeThisMonth)
    {
        NSDate *today = [NSDate date];
        NSDateComponents *todayEndComps = [calendarWithZone components:( NSHourCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [todayEndComps setYear:todayEndComps.year];
        [todayEndComps setMonth:todayEndComps.month];
        [todayEndComps setDay:todayEndComps.day];
        [todayEndComps setMinute:0];
        [todayEndComps setSecond:0];
        
        NSDateComponents *firstDayOfMonth = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [firstDayOfMonth setMinute:0];
        [firstDayOfMonth setSecond:0];
        [firstDayOfMonth setHour:0];
        [firstDayOfMonth setDay:1];
        end = [calendar dateFromComponents:todayEndComps];
        start = [calendar dateFromComponents:firstDayOfMonth];
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeThisYear)
    {
        NSDate *today = [NSDate date];
        NSDateComponents *todayComps = [calendarWithZone components:( NSHourCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [todayComps setMinute:0];
        [todayComps setSecond:0];
        [todayComps setDay:todayComps.day];
        [todayComps setHour:todayComps.hour];
        [todayComps setYear:todayComps.year];
        [todayComps setMonth:todayComps.month];
        
        NSDateComponents *firstDayOfYear = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [firstDayOfYear setMinute:0];
        [firstDayOfYear setSecond:0];
        [firstDayOfYear setHour:0];
        [firstDayOfYear setDay:1];
        [firstDayOfYear setMonth:1];
        end = [calendar dateFromComponents:todayComps];
        start = [calendar dateFromComponents:firstDayOfYear];
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeLastYear)
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
    else if(relativeDateType == REMRelativeTimeRangeTypeLast30Day){
        
        NSDate *last30days = [REMTimeHelper getDate:[NSDate date] daysAhead:-30];
        
        NSDateComponents *last30dayEndComps = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:last30days];
        [last30dayEndComps setMinute:0];
        [last30dayEndComps setHour:0];
        [last30dayEndComps setSecond:0];
        
        NSDateComponents *todayComps = [calendarWithZone components:(NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
        
        end = [calendar dateFromComponents:todayComps];
        start = [calendar dateFromComponents:last30dayEndComps];
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeLast12Month){
        NSDate *last12months = [REMTimeHelper getDate:[NSDate date] monthsAhead:-12];
        
        NSDateComponents *last12monthEndComps = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:last12months];
        [last12monthEndComps setDay:1];
        [last12monthEndComps setHour:0];
        [last12monthEndComps setMinute:0];
        [last12monthEndComps setSecond:0];
        
        NSDateComponents *todayComps = [calendarWithZone components:(NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
        
        end = [calendar dateFromComponents:todayComps];
        start = [calendar dateFromComponents:last12monthEndComps];
    }
    
    
    return [[REMTimeRange alloc]initWithStartTime:start EndTime:end];
}

+(NSDate*)dateFromYear:(int)year Month:(int)month Day:(int)day
{
    NSString *date = [NSString stringWithFormat:@"%4d-%02d-%02d", year, month, day];
    NSDateFormatter *formater = [REMTimeHelper currentFormatter];
    [formater setDateFormat:@"yyyy-MM-dd"];
    return [formater dateFromString:date];
}

+ (NSDate *)dateFromYear:(int)year Month:(int)month Day:(int)day Hour:(int)hour{
    NSString *date = [NSString stringWithFormat:@"%4d-%02d-%02d %02d", year, month, day,hour];
    NSDateFormatter *formater = [REMTimeHelper currentFormatter];
    [formater setDateFormat:@"yyyy-MM-dd HH"];
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
    return [calendar dateByAddingComponents:dateComponents toDate:date options:0];
}


static NSDateFormatter *_formatter;
+(NSDateFormatter *)currentFormatter
{
    if(_formatter == nil){
        _formatter = [[NSDateFormatter alloc]init];
        [_formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    }
    
    return _formatter;
}
static NSDateFormatter *_localFormatter;
+(NSDateFormatter *)currentLocalFormatter
{
    if(_localFormatter == nil){
        _localFormatter = [[NSDateFormatter alloc]init];
    }
    
    return _localFormatter;
}

+ (NSString *)formatTimeFullHour:(NSDate *)date isChangeTo24Hour:(BOOL)change24Hour
{
    NSDateFormatter *f = [REMTimeHelper currentFormatter];
    [f setDateFormat:@"yyyy-MM-dd HH:mm"];
    if(change24Hour==YES && [REMTimeHelper getHour:date]==0){
        [f setDateFormat:@"yyyy-MM-dd"];
        date = [date dateByAddingTimeInterval:-24*60*60];
        NSString *mid=[f stringFromDate:date];
        return [NSString stringWithFormat:@"%@ %@",mid,@"24:00"];
    }
    return [f stringFromDate:date];
}

+ (NSString *)formatTimeFullDay:(NSDate *)date isChangeTo24Hour:(BOOL)change24Hour;
{
    NSDateFormatter *f = [REMTimeHelper currentFormatter];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSString *ret;
    if(change24Hour ==YES && [REMTimeHelper getHour:date]==0){
        NSDate *newEndDate=[REMTimeHelper add:-1 onPart:REMDateTimePartDay ofDate:date];
        ret=[f stringFromDate:newEndDate];
    }
    else{
        ret=[f stringFromDate:date];
    }
    return ret;
}

+ (NSString *)formatTimeFullMonth:(NSDate *)date{
    NSDateFormatter *f = [REMTimeHelper currentFormatter];
    [f setDateFormat:REMIPadLocalizedString(@"Common_YearMonthFormat")];
    
    return [f stringFromDate:date];
}

+ (NSString *)formatTimeFullYear:(NSDate *)date{
    NSDateFormatter *f = [REMTimeHelper currentFormatter];
    [f setDateFormat:REMIPadLocalizedString(@"Common_WholeYearFormat")];
    
    return [f stringFromDate:date];
}

+ (NSString *)formatTimeRangeFullDay:(REMTimeRange *)range{
    NSString *start=[REMTimeHelper formatTimeFullDay:range.startTime isChangeTo24Hour:NO];
    NSString *end =[REMTimeHelper formatTimeFullDay:range.endTime isChangeTo24Hour:YES];
    return [NSString stringWithFormat:@"%@ -- %@",start,end];
}

+ (NSString *)formatTimeRangeFullHour:(REMTimeRange *)range{
    NSString *start=[REMTimeHelper formatTimeFullHour:range.startTime isChangeTo24Hour:NO];
    NSString *end=[REMTimeHelper formatTimeFullHour:range.endTime isChangeTo24Hour:YES];
    
    return [NSString stringWithFormat:@"%@ -- %@",start,end];
}

+(NSString*)formatTime:(NSDate *)date withFormat:(NSString*)format {
    NSDateFormatter *f = [REMTimeHelper currentFormatter];
    [f setDateFormat:format];
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

+ (NSDate *)now
{
    NSDate *today = [NSDate date];
    
    NSCalendar *calendar = [REMTimeHelper gregorianCalendar];
    
    NSDateComponents *todayEndComps = [calendar components:(NSMinuteCalendarUnit| NSHourCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    [todayEndComps setYear:todayEndComps.year];
    [todayEndComps setMonth:todayEndComps.month];
    [todayEndComps setDay:todayEndComps.day];
    [todayEndComps setHour:todayEndComps.hour];
    [todayEndComps setMinute:todayEndComps.minute];
    [todayEndComps setSecond:0];
    
    NSDate *now=[calendar dateFromComponents:todayEndComps];
    
    return now;
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
    if(_currentCalendar == nil){
        _currentCalendar = [NSCalendar currentCalendar];
        [_currentCalendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"] ];
    }
    
    return _currentCalendar;
}

+ (NSDate *)convertToUtc:(NSDate *)date{
    
    
    NSCalendar *calendar = [REMTimeHelper currentCalendar];
    
    NSDateComponents *comp = [calendar components:(NSMinuteCalendarUnit| NSHourCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
    NSDateComponents *utcComp=[[NSDateComponents alloc]init];
    [utcComp setYear:comp.year];
    [utcComp setMonth:comp.month];
    [utcComp setDay:comp.day];
    [utcComp setHour:comp.hour];
    [utcComp setMinute:comp.minute];
    [utcComp setSecond:0];
    NSCalendar *calendarWithZone=[NSCalendar currentCalendar];
    NSDate *utc=[calendarWithZone dateFromComponents:utcComp];
    
    return utc;
}

//+(NSDate *)convertLocalDateToGMT:(NSDate *)localDate
//{
//    NSTimeInterval timeZoneOffset = [[NSTimeZone timeZoneWithName:@"Asia/Shanghai"] secondsFromGMT];
//    NSTimeInterval gmtTimeInterval = [localDate timeIntervalSinceReferenceDate] - timeZoneOffset;
//    NSDate *gmtDate = [NSDate dateWithTimeIntervalSinceReferenceDate:gmtTimeInterval];
//    
//    return gmtDate;
//}

+(NSDate *)convertGMTDateToLocal:(NSDate *)GMTDate
{
    NSTimeInterval timeZoneOffset = [[NSTimeZone timeZoneWithName:@"Asia/Shanghai"] secondsFromGMT];
    NSTimeInterval localTimeInterval = [GMTDate timeIntervalSinceReferenceDate] + timeZoneOffset;
    NSDate *localDate = [NSDate dateWithTimeIntervalSinceReferenceDate:localTimeInterval];
    
    return localDate;
}

+(NSString *)formatTooltipTime:(NSDate *)time byStep:(REMEnergyStep)step inRange:(REMTimeRange *)timeRange
{
    if(time == nil){
        return @"";
    }
    
    NSDateFormatter *f = [REMTimeHelper currentFormatter];
    
    switch (step) {
        case REMEnergyStepHour:{
            [f setDateFormat:@"yyyy年MM月dd日HH点"];
            NSString *s1 = [f stringFromDate:time];
            
            NSDate *newDate = [time dateByAddingTimeInterval:60*60];
            NSString *s2 = @"";
            
            if([REMTimeHelper getHour:newDate] < [REMTimeHelper getHour:time]){
                s2 = @"24点";
            }
            else{
                [f setDateFormat:@"HH点"];
                s2 = [f stringFromDate:newDate];
            }
            
            return [NSString stringWithFormat:@"%@-%@",s1,s2];
        }
        case REMEnergyStepDay:{
            [f setDateFormat:@"yyyy年MM月dd日"];
            return [f stringFromDate:time];
        }
        case REMEnergyStepMonth:{
            [f setDateFormat:@"yyyy年MM月"];
            return [f stringFromDate:time];
        }
        case REMEnergyStepYear:{
            [f setDateFormat:@"yyyy年"];
            return [f stringFromDate:time];
        }
        case REMEnergyStepWeek:{//week 2010年10月3日-10日,2010年10月29日-11月5日,2010年12月29日-2011年1月5日{}
            [f setDateFormat:@"yyyy年MM月dd日"];
            
            int weekDay = [REMTimeHelper getWeekDay:time];
            NSDate *date = [REMTimeHelper add:(0-weekDay+2) onPart:REMDateTimePartDay ofDate:time]; //[time dateByAddingTimeInterval:(0-weekDay+1) * 60 * 60];
            NSString *s1 = [f stringFromDate:date];
            
            NSString *s2 = @"";
            NSDate *newDate = [REMTimeHelper add:6 onPart:REMDateTimePartDay ofDate:date];
            if ([REMTimeHelper getYear:newDate] > [REMTimeHelper getYear:date]) {
                //2010年12月29日-2011年1月5日
                //str += '-' + eft(newDate, ft.FullDay);
                s2 = [f stringFromDate:newDate];
            }
            else if ([REMTimeHelper getMonth:newDate] > [REMTimeHelper getMonth:date]) {
                //2010年10月29日-11月5日
                //str += '-' + eft(newDate, ft.MonthDate);
                [f setDateFormat:@"MM月dd日"];
                s2 = [f stringFromDate:newDate];
            }
            else {
                //2010年10月3日-10日
                //str += '-' + eft(newDate, ft.Day);
                [f setDateFormat:@"dd日"];
                s2 = [f stringFromDate:newDate];
            }
            
            return [NSString stringWithFormat:@"%@-%@",s1,s2];
        }
            
        default:
            return [REMTimeHelper formatTimeFullHour:time isChangeTo24Hour:YES];
    }
}

+(REMTimeRange *)getREMSystemTimeRangeLimit
{
    NSDate *start = [NSDate dateWithTimeIntervalSince1970:0];
    
    
    NSDateComponents *component=[[NSDateComponents alloc]init];
    [component setYear:2050];
    [component setMonth:1];
    [component setDay:1];
    [component setHour:0];
    [component setMinute:0];
    [component setSecond:0];
    NSCalendar *calendar = [REMTimeHelper currentCalendar];
    
    NSDate *end = [calendar dateFromComponents:component];
    
    
    REMTimeRange *range = [[REMTimeRange alloc] initWithStartTime:start EndTime:end];
    
    return range;
}

@end
