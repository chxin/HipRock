//
//  REMApplicationInfo.h
//  Blues
//
//  Created by 徐 子龙 on 13-7-3.
//
//

#import <Foundation/Foundation.h>


@interface REMApplicationInfo : NSObject
+(void) initApplicationInfo;
+(NSString*)formatVersion:(NSString*)versionString;
+(const char*)getVersion;
+(NSString *)getApplicationCacheKey;
@end
