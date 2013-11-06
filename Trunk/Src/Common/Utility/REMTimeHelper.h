//
//  REMTimeHelper.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by TanTan on 7/11/13.
//
//

#import <Foundation/Foundation.h>
#import "REMLog.h"
#import "REMTimeRange.h"
#import "REMEnum.h"

@class REMTimeRange;


typedef enum _REMDateTimePart : NSUInteger{
    REMDateTimePartSecond = 1,
    REMDateTimePartMinute = 2,
    REMDateTimePartHour = 3,
    REMDateTimePartDay = 4,
    REMDateTimePartMonth = 5,
    REMDateTimePartYear = 6,
} REMDateTimePart;


#define REMTIMEINTERVAL_SECOND 1000;
#define REMTIMEINTERVAL_MINUTE 1000 * 60;
#define REMTIMEINTERVAL_HOUR = 1000 * 60 * 60;
#define REMTIMEINTERVAL_DAY = 1000 * 60 * 60 * 24
#define REMTIMEINTERVAL_WEEK = 1000 * 60 * 60 *24 * 7;

@interface REMTimeHelper : NSObject

+ (long long) longLongFromJSONString:(NSString *)jsonDate;

+ (NSString *)jsonStringFromDate:(NSDate *)date;

+(NSNumber *) numberFromJSONString:(NSString *)jsonDate;

+ (REMTimeRange *) relativeDateFromType:(REMRelativeTimeRangeType)relativeDateType;

+ (NSString *)formatTimeFullHour:(NSDate *)date isChangeTo24Hour:(BOOL)change24Hour;

+ (NSString *)formatTimeFullDay:(NSDate *)date;

+ (NSString *)formatTimeRangeFullDay:(REMTimeRange *)range;

+ (NSString *)formatTimeRangeFullHour:(REMTimeRange *)range;

+ (REMTimeRange *) maxTimeRangeOfTimeRanges:(NSArray *)timeRanges;

+ (NSDate *)add:(int)difference onPart:(REMDateTimePart)part ofDate:(NSDate *)date;



+ (NSUInteger)getYear:(NSDate *)date;
+ (NSUInteger)getMonth:(NSDate *)date;
+ (NSUInteger)getDay:(NSDate *)date;
+ (int )getHour:(NSDate *)date;
+ (int)getMinute:(NSDate *)date;
+(NSNumber *)getMonthTicksFromDate:(NSDate *)date;
+(NSDate *)getDateFromMonthTicks:(NSNumber *)monthTicks;

+(NSUInteger)getDaysOfDate: (NSDate*)date;

+(NSDate*)addMonthToDate:(NSDate*)date month:(NSInteger)month;
+(NSDate*)dateFromYear:(int)year Month:(int)month Day:(int)day;
+(NSDate*)dateFromYear:(int)year Month:(int)month Day:(int)day Hour:(int)hour;
+(NSDate *)today;
+(NSDate *)tomorrow;
+(NSDate *)convertLocalDateToGMT:(NSDate *)localDate;

+(NSCalendar *)gregorianCalendar;
+(NSDate *)convertGMTDateToLocal:(NSDate *)GMTDate;
@end
