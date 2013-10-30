//
//  REMLog.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by TanTan on 6/27/13.
//
//

#import <Foundation/Foundation.h>
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "DDFileLogger.h"
#import "REMLogManager.h"


#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_ERROR;
#endif

#define REMLogError DDLogError
#define REMLogInfo DDLogInfo
#define REMLogWarn DDLogWarn
#define REMLogVerbose DDLogVerbose

#define NSLog REMLogInfo

@interface REMLog : NSObject
+ (void) bind;
+ (void) logErrorContent:(NSString *)content;
@end
