//
//  REMTimeHelper.h
//  Blues
//
//  Created by TanTan on 7/11/13.
//
//

#import <Foundation/Foundation.h>
#import "REMLog.h"
#import "REMTimeRange.h"

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
#define REMTIMEINTERVAL_DAY = 1000 * 60 * 60 * 24;
#define REMTIMEINTERVAL_WEEK = 1000 * 60 * 60 *24 * 7;

@interface REMTimeHelper : NSObject

+ (long long) longLongFromJSONString:(NSString *)jsonDate;

+(NSNumber *) numberFromJSONString:(NSString *)jsonDate;

+ (REMTimeRange *) relativeDateFromString:(NSString *)relativeDateString;

+ (NSString *) formatTimeFullHour:(NSDate *)date;

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
+(NSDate *)today;
+(NSDate *)tomorrow;
@end
