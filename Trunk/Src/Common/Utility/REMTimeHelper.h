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

@interface REMTimeHelper : NSObject

+ (long long) longLongFromJSONString:(NSString *)jsonDate;

+(NSNumber *) numberFromJSONString:(NSString *)jsonDate;

+ (REMTimeRange *) relativeDateFromString:(NSString *)relativeDateString;

+ (NSString *) formatTimeFullHour:(NSDate *)date;

+ (REMTimeRange *) maxTimeRangeOfTimeRanges:(NSArray *)timeRanges;

@end
