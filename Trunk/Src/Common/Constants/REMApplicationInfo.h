/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMApplicationInfo.h
 * Created      : 徐 子龙 on 13-7-3.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
