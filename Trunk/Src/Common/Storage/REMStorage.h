//
//  REMStorage.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 徐 子龙 on 13-7-4.
//
//

#import <Foundation/Foundation.h>

typedef enum StorageExpirationType : NSUInteger {
    REMNeverExpired = 0,
    REMSessionExpired = 1,
    REMWindowActiated = 2
} StorageExpirationType;

@interface REMStorage : NSObject
+(void)set:(NSString*)sourceName key:(NSString*)key value:(NSString*)value expired:(StorageExpirationType)expired;
+(NSString*)get:(NSString*)sourceName key:(NSString*)key;
+(void)initialize;
+(void)clearSessionStorage;
+(void)clearOnApplicationActive;

+(NSData*)getFile:(NSString*)sourceName key:(NSString*)key;
+(void)setFile:(NSString*)sourceName key:(NSString*)key version:(long)version image:(NSData*)image;
@end
