/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEncryptHelper.h
 * Created      : 张 锋 on 7/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>

@interface REMEncryptHelper : NSObject

+ (NSData *)AES256EncryptData:(NSData *)data withKey:(NSString *)key;   //加密
+ (NSData *)AES256DecryptData:(NSData *)data WithKey:(NSString *)key;   //解密

+(NSString *)base64AES256EncryptString:(NSString *)input withKey:(NSString *)key;

+ (NSString*)encodeBase64String:(NSString *)input;
+ (NSString*)decodeBase64String:(NSString *)input;
+ (NSString*)encodeBase64Data:(NSData *)data;
+ (NSString*)decodeBase64Data:(NSData *)data;

@end
