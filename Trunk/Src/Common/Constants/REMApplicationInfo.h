//
//  REMApplicationInfo.h
//  Blues
//
//  Created by 徐 子龙 on 13-7-3.
//
//

#import <Foundation/Foundation.h>

#define kFontUltra "HelveticaNeue-UltraLight"
#define kFontLight "HelveticaNeue-Light"
#define kFontSC "Heiti SC"


@interface REMApplicationInfo : NSObject
+(void) initApplicationInfo;
+(NSString*)formatVersion:(NSString*)versionString;
+(const char*)getVersion;
+(NSString *)getApplicationCacheKey;
@end
