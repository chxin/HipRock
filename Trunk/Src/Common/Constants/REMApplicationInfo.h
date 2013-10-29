//
//  REMApplicationInfo.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 徐 子龙 on 13-7-3.
//
//

#import <Foundation/Foundation.h>

#define kFontUltra "HelveticaNeue-UltraLight"
#define kFontLight "HelveticaNeue-Light"
#define kFontSC "STHeitiSC-Medium"


@interface REMApplicationInfo : NSObject
+(void) initApplicationInfo;
+(NSString*)formatVersion:(NSString*)versionString;
+(const char*)getVersion;
+(NSString *)getApplicationCacheKey;
@end
