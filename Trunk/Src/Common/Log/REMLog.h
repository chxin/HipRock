/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMLog.h
 * Created      : TanTan on 6/27/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "DDLog.h"
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
