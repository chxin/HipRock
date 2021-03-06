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
            return (int)[components hour];
        case REMDateTimePartDay:
            return (int)[components day];
        case REMDateTimePartMonth:
            return (int)[components month];
        case REMDateTimePartYear:
            return (int)[components year];
            
        default:
            return (int)[components hour];
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
        return REMIPadLocalizedString(@"Common_CustomTime");
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeLast7Day){
        return REMIPadLocalizedString(@"Common_Last7Day");
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeToday){
        return REMIPadLocalizedString(@"Common_Today");
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeYesterday){
        return REMIPadLocalizedString(@"Common_Yesterday");
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeThisMonth){
        return REMIPadLocalizedString(@"Common_ThisMonth");
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeLastMonth){
        return REMIPadLocalizedString(@"Common_LastMonth");
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeThisWeek){
        return REMIPadLocalizedString(@"Common_ThisWeek");
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeLastWeek){
        return REMIPadLocalizedString(@"Common_LastWeek");
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeThisYear){
        return REMIPadLocalizedString(@"Common_ThisYear");
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeLastYear){
        return REMIPadLocalizedString(@"Common_LastYear");
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeLast30Day){
        return REMIPadLocalizedString(@"Common_Last30Days");
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeLast12Month){
        return REMIPadLocalizedString(@"Common_Last12Months");
    }
    else{
        return REMIPadLocalizedString(@"Common_CustomTime");
    }

}

+ (REMTimeRange *) relativeDateFromType:(REMRelativeTimeRangeType)relativeDateType
{
    NSDate *start,*end;
    NSCalendar *calendar = [REMTimeHelper currentCalendar];
    NSCalendar *calendarWithZone=[NSCalendar currentCalendar];
    
    if (relativeDateType == REMRelativeTimeRangeTypeLast7Day) {
        NSDate *last7day = [REMTimeHelper getDate:[NSDate date] daysAhead:-6];
        
        NSDateComponents *last7dayEndComps = [calendar components:(NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:last7day];
        [last7dayEndComps setMinute:0];
        [last7dayEndComps setHour:0];
        [last7dayEndComps setSecond:0];
        
        NSDateComponents *todayComps = [calendarWithZone components:(NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[REMTimeHelper getDate:[NSDate date] daysAhead:1]];
        [todayComps setHour:0];
        [todayComps setMinute:0];
        [todayComps setSecond:0];

        end = [calendar dateFromComponents:todayComps];
        start = [calendar dateFromComponents:last7dayEndComps];
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeToday)
    {
        NSDate *today = [NSDate date];
        NSDateComponents *todayComps = [calendarWithZone components:(NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[REMTimeHelper getDate:[NSDate date] daysAhead:1]];
        [todayComps setHour:0];
        [todayComps setMinute:0];
        [todayComps setSecond:0];
        
        NSDateComponents *todayStartComps = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [todayStartComps setMinute:0];
        [todayStartComps setSecond:0];
        [todayStartComps setHour:0];
        
        end = [calendar dateFromComponents:todayComps];
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
        
        NSDateComponents *todayComps = [calendarWithZone components:(NSWeekdayCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [todayComps setSecond:0];
        [todayComps setMinute:0];
        [todayComps setHour:0];
        
        long weekday = (long)todayComps.weekday - 2;
        long firstDayThisWeekToToday = weekday >= 0 ? weekday : weekday + 7;
        long todayToLastDayThisWeek = weekday >= 0 ? 7 - weekday : -weekday;
        
        NSDate *firstDayThisWeek = [REMTimeHelper getDate:today daysAhead: -firstDayThisWeekToToday];
        NSDate *lastDayThisWeek = [REMTimeHelper getDate:today daysAhead: todayToLastDayThisWeek];
        
        NSDateComponents *firstDayThisWeekComps = [calendarWithZone components:( NSWeekdayCalendarUnit| NSHourCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:firstDayThisWeek];
        [firstDayThisWeekComps setSecond:0];
        [firstDayThisWeekComps setMinute:0];
        [firstDayThisWeekComps setHour:0];
        
        NSDateComponents *lastDayThisWeekComps = [calendarWithZone components:( NSWeekdayCalendarUnit| NSHourCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:lastDayThisWeek];
        [lastDayThisWeekComps setSecond:0];
        [lastDayThisWeekComps setMinute:0];
        [lastDayThisWeekComps setHour:0];
        
        end = [calendar dateFromComponents:lastDayThisWeekComps];
        start = [calendar dateFromComponents:firstDayThisWeekComps];
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeLastWeek)
    {
        NSDate *today = [NSDate date];
        NSDateComponents *todayEndComps = [calendar components:(NSWeekdayCalendarUnit| NSHourCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [todayEndComps setMinute:0];
        [todayEndComps setSecond:0];
        [todayEndComps setHour:0];
        
        long weekday = (long)todayEndComps.weekday - 2;
        long firstDayLastWeekToToday = weekday >= 0 ? weekday + 7 : weekday + 14;
        long lastDayLastWeekToToday = weekday >= 0 ?  weekday : 7+weekday;
        
        NSDate *firstDayLastWeek = [REMTimeHelper getDate:today daysAhead: -firstDayLastWeekToToday];
        NSDate *lastDayLastWeek = [REMTimeHelper getDate:today daysAhead: -lastDayLastWeekToToday];
        
        NSDateComponents *firstDayLastWeekComps = [calendarWithZone components:( NSWeekdayCalendarUnit| NSHourCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:firstDayLastWeek];
        [firstDayLastWeekComps setSecond:0];
        [firstDayLastWeekComps setMinute:0];
        [firstDayLastWeekComps setHour:0];
        
        NSDateComponents *lastDayLastWeekComps = [calendarWithZone components:( NSWeekdayCalendarUnit| NSHourCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:lastDayLastWeek];
        [lastDayLastWeekComps setSecond:0];
        [lastDayLastWeekComps setMinute:0];
        [lastDayLastWeekComps setHour:0];
        
        end = [calendar dateFromComponents:lastDayLastWeekComps];
        start = [calendar dateFromComponents:firstDayLastWeekComps];
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeThisMonth)
    {
        NSDate *today = [NSDate date];
        NSDateComponents *todayComps = [calendarWithZone components:(NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[REMTimeHelper getDate:[NSDate date] monthsAhead:1]];
        [todayComps setDay:1];
        [todayComps setHour:0];
        [todayComps setMinute:0];
        [todayComps setSecond:0];
        
        NSDateComponents *firstDayOfMonth = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [firstDayOfMonth setMinute:0];
        [firstDayOfMonth setSecond:0];
        [firstDayOfMonth setHour:0];
        [firstDayOfMonth setDay:1];
        end = [calendar dateFromComponents:todayComps];
        start = [calendar dateFromComponents:firstDayOfMonth];
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeThisYear)
    {
        NSDate *today = [NSDate date];
        NSDateComponents *yearEnd = [calendarWithZone components:( NSHourCalendarUnit|NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [yearEnd setSecond:0];
        [yearEnd setMinute:0];
        [yearEnd setHour:0];
        [yearEnd setDay:1];
        [yearEnd setMonth:1];
        [yearEnd setYear:yearEnd.year+1];
        
        NSDateComponents *firstDayOfYear = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
        [firstDayOfYear setMinute:0];
        [firstDayOfYear setSecond:0];
        [firstDayOfYear setHour:0];
        [firstDayOfYear setDay:1];
        [firstDayOfYear setMonth:1];
        end = [calendar dateFromComponents:yearEnd];
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
        
        NSDate *last30days = [REMTimeHelper getDate:[NSDate date] daysAhead:-29];
        
        NSDateComponents *last30dayEndComps = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:last30days];
        [last30dayEndComps setMinute:0];
        [last30dayEndComps setHour:0];
        [last30dayEndComps setSecond:0];
        
        NSDateComponents *todayComps = [calendarWithZone components:(NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[REMTimeHelper getDate:[NSDate date] daysAhead:1]];
        [todayComps setHour:0];
        [todayComps setMinute:0];
        [todayComps setSecond:0];
        
        end = [calendar dateFromComponents:todayComps];
        start = [calendar dateFromComponents:last30dayEndComps];
    }
    else if(relativeDateType == REMRelativeTimeRangeTypeLast12Month){
        NSDate *last11months = [REMTimeHelper getDate:[NSDate date] monthsAhead:-11];
        
        NSDateComponents *last11monthEndComps = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:last11months];
        [last11monthEndComps setDay:1];
        [last11monthEndComps setHour:0];
        [last11monthEndComps setMinute:0];
        [last11monthEndComps setSecond:0];
        
        NSDateComponents *todayComps = [calendarWithZone components:(NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[REMTimeHelper getDate:[NSDate date] monthsAhead:1]];
        [todayComps setDay:1];
        [todayComps setHour:0];
        [todayComps setMinute:0];
        [todayComps setSecond:0];
        
        end = [calendar dateFromComponents:todayComps];
        start = [calendar dateFromComponents:last11monthEndComps];
    }
    
    REMTimeRange *range = [[REMTimeRange alloc]initWithStartTime:start EndTime:end];
    range.relativeTimeType = relativeDateType;
    
    return range;
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
        _formatter = [[NSDateFormatter alloc] init];
        
        NSString *language = [NSLocale canonicalLanguageIdentifierFromString:[NSLocale preferredLanguages][0]];
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:language];
//[NSLocale localeWithLocaleIdentifier:[NSLocale canonicalLanguageIdentifierFromString:[NSLocale preferredLanguages][0]]];
        
        [_formatter setLocale:locale];
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
    [f setDateFormat:REMIPadLocalizedString(@"Common_DateToMinuteFormat")];
    if(change24Hour==YES && [REMTimeHelper getHour:date]==0){
        [f setDateFormat:REMIPadLocalizedString(@"Common_DateFormat")];
        date = [date dateByAddingTimeInterval:-24*60*60];
        NSString *mid=[f stringFromDate:date];
        return [NSString stringWithFormat:@"%@ %@",mid,REMIPadLocalizedString(@"Common_2400Format")];
    }
    return [f stringFromDate:date];
}

+ (NSString *)formatTimeFullDay:(NSDate *)date isChangeTo24Hour:(BOOL)change24Hour;
{
    NSDateFormatter *f = [REMTimeHelper currentFormatter];
    [f setDateFormat:REMIPadLocalizedString(@"Common_DateFormat")];
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
    
    return [NSNumber numberWithInt:(int)monthTicks];
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
        NSString *language = [NSLocale canonicalLanguageIdentifierFromString:[NSLocale preferredLanguages][0]];
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:language];
        
        _currentCalendar = [NSCalendar currentCalendar];
        _currentCalendar.locale = locale;
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
        case REMEnergyStepMin15:{ // yyyy年MM月dd日 HH:00-HH:15    HH:00-HH:15 on dd/MM/yyyy
            f.dateFormat = REMIPadLocalizedString(@"Chart_Tooltip_TimeRangeRaw");
            
            NSString *s1 = [f stringFromDate:time];
            
            f.dateFormat = REMIPadLocalizedString(@"Chart_Tooltip_Hm");
            NSDate *newDate = [time dateByAddingTimeInterval:15*60];
            
            NSString *s2 = [f stringFromDate:newDate];
            if([REMTimeHelper getHour:newDate] ==0 && [REMTimeHelper getMinute:newDate]==0){
                s2 = REMIPadLocalizedString(@"Chart_Tooltip_24_OClock");
            }
            
            return [NSString stringWithFormat:s1,s2];
        }
        case REMEnergyStepMin30:{ // yyyy年MM月dd日 HH:00-HH:30    HH:00-HH:30 on dd/MM/yyyy
            f.dateFormat = REMIPadLocalizedString(@"Chart_Tooltip_TimeRangeRaw");
            
            NSString *s1 = [f stringFromDate:time];
            
            f.dateFormat = REMIPadLocalizedString(@"Chart_Tooltip_Hm");
            NSDate *newDate = [time dateByAddingTimeInterval:30*60];
            
            NSString *s2 = [f stringFromDate:newDate];
            if([REMTimeHelper getHour:newDate] ==0 && [REMTimeHelper getMinute:newDate]==0){
                s2 = REMIPadLocalizedString(@"Chart_Tooltip_24_OClock");
            }
            
            return [NSString stringWithFormat:s1,s2];
        }
        case REMEnergyStepHour:{ //yyyy年MM月dd日HH点-HH点      HH:00-HH:00 on dd/MM/yyyy
            [f setDateFormat:REMIPadLocalizedString(@"Chart_Tooltip_TimeRangeHour")];
            NSString *s1 = [f stringFromDate:time];
            
            [f setDateFormat:REMIPadLocalizedString(@"Chart_Tooltip_H")/*@"HH点"*/];
            
            NSDate *newDate = [time dateByAddingTimeInterval:60*60];
            NSString *s2 = [f stringFromDate:newDate];
            
            if([REMTimeHelper getHour:newDate] < [REMTimeHelper getHour:time]){
                s2 = REMIPadLocalizedString(@"Chart_Tooltip_24_OClock")/*@"24点"*/;
            }
            
            return [NSString stringWithFormat:s1,s2];
        }
        case REMEnergyStepDay:{
            [f setDateFormat:REMIPadLocalizedString(@"Chart_Tooltip_YMD")/*@"yyyy年MM月dd日"*/];
            return [f stringFromDate:time];
        }
        case REMEnergyStepMonth:{
            [f setDateFormat:REMIPadLocalizedString(@"Chart_Tooltip_YM")/*@"yyyy年MM月"*/];
            return [f stringFromDate:time];
        }
        case REMEnergyStepYear:{
            [f setDateFormat:REMIPadLocalizedString(@"Chart_Tooltip_Y")/*@"yyyy年"*/];
            return [f stringFromDate:time];
        }
        case REMEnergyStepWeek:{
            //week cn 2010年10月3日-10日,2010年10月29日-11月5日,2010年12月29日-2011年1月5日
            //week en 03-10 07/2010, 03/07-10/08 2010, 29/12/2010-03/01/2011
            
            int weekDay = [REMTimeHelper getWeekDay:time];
            NSDate *date = [REMTimeHelper add:(0-weekDay+2) onPart:REMDateTimePartDay ofDate:time];
            
            
            
            NSString *s1=@"", *s2 = @"";
            NSDate *newDate = [REMTimeHelper add:6 onPart:REMDateTimePartDay ofDate:date];
            if ([REMTimeHelper getYear:newDate] > [REMTimeHelper getYear:date]) {
                //2010年12月29日-2011年1月5日
                f.dateFormat = REMIPadLocalizedString(@"Chart_Tooltip_TimeRangeWeek3");
                s1 = [f stringFromDate:date];
                
                f.dateFormat = REMIPadLocalizedString(@"Chart_Tooltip_YMD");
                s2 = [f stringFromDate:newDate];
            }
            else if ([REMTimeHelper getMonth:newDate] > [REMTimeHelper getMonth:date]) {
                //2010年10月29日-11月5日
                f.dateFormat = REMIPadLocalizedString(@"Chart_Tooltip_TimeRangeWeek2");
                s1 = [f stringFromDate:date];
                
                [f setDateFormat:REMIPadLocalizedString(@"Chart_Tooltip_MD")/*@"MM月dd日"*/];
                s2 = [f stringFromDate:newDate];
            }
            else {
                //2010年10月3日-10日
                f.dateFormat = REMIPadLocalizedString(@"Chart_Tooltip_TimeRangeWeek1");
                s1 = [f stringFromDate:date];
                
                [f setDateFormat:REMIPadLocalizedString(@"Chart_Tooltip_D")/*@"dd日"*/];
                s2 = [f stringFromDate:newDate];
            }
            
            return [NSString stringWithFormat:s1,s2];
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

+(REMRelativeTimeRangeType)relativeTimeTypeByName:(NSString *)relativeTimeTypeName
{
    if([relativeTimeTypeName isEqualToString:@"Last7Day"]){
        return REMRelativeTimeRangeTypeLast7Day;
    }
    else if([relativeTimeTypeName isEqualToString:@"Last30Day"]){
        return REMRelativeTimeRangeTypeLast30Day;
    }
    else if([relativeTimeTypeName isEqualToString:@"Last12Month"]){
        return REMRelativeTimeRangeTypeLast12Month;
    }
    else if([relativeTimeTypeName isEqualToString:@"Today"]){
        return REMRelativeTimeRangeTypeToday;
    }
    else if([relativeTimeTypeName isEqualToString:@"Yesterday"]){
        return REMRelativeTimeRangeTypeYesterday;
    }
    else if([relativeTimeTypeName isEqualToString:@"ThisWeek"]){
        return REMRelativeTimeRangeTypeThisWeek;
    }
    else if([relativeTimeTypeName isEqualToString:@"LastWeek"]){
        return REMRelativeTimeRangeTypeLastWeek;
    }
    else if([relativeTimeTypeName isEqualToString:@"ThisMonth"]){
        return REMRelativeTimeRangeTypeThisMonth;
    }
    else if([relativeTimeTypeName isEqualToString:@"LastMonth"]){
        return REMRelativeTimeRangeTypeLastMonth;
    }
    else if([relativeTimeTypeName isEqualToString:@"ThisYear"]){
        return REMRelativeTimeRangeTypeThisYear;
    }
    else if([relativeTimeTypeName isEqualToString:@"LastYear"]){
        return REMRelativeTimeRangeTypeLastYear;
    }
    else{
        return REMRelativeTimeRangeTypeNone;
    }
}

+(NSDate *)add:(int)count steps:(REMEnergyStep)step onTime:(NSDate *)time
{
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:0 sinceDate:time];
    
    switch (step)
    {
        case REMEnergyStepMin15:
            date2 = [REMTimeHelper add:15 * count onPart:REMDateTimePartMinute ofDate:time]; //time.AddMinutes(15 * count);
            break;
        case REMEnergyStepMin30:
            date2 = [REMTimeHelper add:30 * count onPart:REMDateTimePartMinute ofDate:time]; //time.AddMinutes(15 * count);
            break;
        case REMEnergyStepHour:
            date2 = [REMTimeHelper add:1 * count onPart:REMDateTimePartHour ofDate:time];//time.AddHours(1 * count);
            break;
        case REMEnergyStepDay:
            date2 = [REMTimeHelper add:1 * count onPart:REMDateTimePartDay ofDate:time];//time.AddDays(1 * count);
            break;
        case REMEnergyStepWeek: //asume the input time is already the first day of week
            date2 = [REMTimeHelper add:7 * count onPart:REMDateTimePartDay ofDate:time];//time.AddDays(7 * count);
            break;
        case REMEnergyStepMonth:
            date2 = [REMTimeHelper add:1 * count onPart:REMDateTimePartMonth ofDate:time];//time.AddMonths(1 * count);
            break;
        case REMEnergyStepYear:
            date2 = [REMTimeHelper add:1 * count onPart:REMDateTimePartYear ofDate:time];//time.AddYears(1 * count);
            break;
        case REMEnergyStepNone:
        default:
            date2 = [REMTimeHelper add:15 * count onPart:REMDateTimePartMinute ofDate:time]; //time.AddMinutes(15 * count);
            break;
    }
    
    return  date2;

}

+(NSComparisonResult)compareStep:(REMEnergyStep)step1 toStep:(REMEnergyStep)step2
{
//    REMEnergyStepNone=-1,
//    REMEnergyStepMinute=0,
//    REMEnergyStepHour=1,
//    REMEnergyStepDay=2,
//    REMEnergyStepWeek=5,
//    REMEnergyStepMonth=3,
//    REMEnergyStepYear=4,
//    REMEnergyStepMin15 = 6,
//    REMEnergyStepMin30 = 7
    NSArray *order = @[@(REMEnergyStepNone),@(REMEnergyStepMin15),@(REMEnergyStepMin30),@(REMEnergyStepMinute),@(REMEnergyStepHour),@(REMEnergyStepDay),@(REMEnergyStepWeek),@(REMEnergyStepMonth),@(REMEnergyStepYear)];
    
    NSUInteger index1 = [order indexOfObject:@(step1)];
    NSUInteger index2 = [order indexOfObject:@(step2)];
    
    if (index1 > index2) {
        return NSOrderedDescending;
    }
    else if (index1 < index2) {
        return NSOrderedAscending;
    }
    else {
        return NSOrderedSame;
    }
}

@end
