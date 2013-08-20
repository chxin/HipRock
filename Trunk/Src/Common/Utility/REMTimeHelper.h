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

@interface REMTimeHelper : NSObject

+ (long long) longLongFromJSONString:(NSString *)jsonDate;

+(NSNumber *) numberFromJSONString:(NSString *)jsonDate;

+ (REMTimeRange *) relativeDateFromString:(NSString *)relativeDateString;

+ (NSString *) formatTimeFullHour:(NSDate *)date;

+ (REMTimeRange *) maxTimeRangeOfTimeRanges:(NSArray *)timeRanges;

+ (NSDate *)add:(int)difference onPart:(REMDateTimePart)part ofDate:(NSDate *)date;

@end
