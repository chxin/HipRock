/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEncryptHelper.m
 * Created      : 张 锋 on 7/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMEncryptHelper.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

@implementation REMEncryptHelper

static const NSString *vector = @"EjRWeJCrze8SNFZ4kKvN7w==";

+ (NSData *)AES256EncryptData:(NSData *)data withKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr, kCCBlockSizeAES128,
                                          [[REMEncryptHelper decodeBase64Data:[vector dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]] bytes],
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}


+ (NSData *)AES256DecryptData:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr, kCCBlockSizeAES128,
                                          [[REMEncryptHelper decodeBase64Data:[vector dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]] bytes],
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

+(NSString *)base64AES256EncryptString:(NSString *)input withKey:(NSString *)key
{
    NSData *encryptedData = [REMEncryptHelper AES256EncryptData:[input dataUsingEncoding:NSUTF8StringEncoding] withKey:REMSecurityTokenKey];
    
    return [REMEncryptHelper encodeBase64StringWithData:encryptedData];
}

#pragma mark - base64
+ (NSString*)encodeBase64StringWithString:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    return  [REMEncryptHelper encodeBase64StringWithData:data];
}

+ (NSString*)decodeBase64StringWithString:(NSString * )encodedString {
    NSData *encodedData = [encodedString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    return  [REMEncryptHelper decodeBase64StringWithData:encodedData];
}

+ (NSString*)encodeBase64StringWithData:(NSData * )data {
    NSData *encodedData = [REMEncryptHelper encodeBase64Data:data];
    
    return  [[NSString alloc] initWithData:encodedData encoding:NSUTF8StringEncoding];
}

+ (NSString*)decodeBase64StringWithData:(NSData * )encodedData {
    NSData *decodedData = [REMEncryptHelper decodeBase64Data:encodedData];
    
    return  [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
}

+ (NSData *)encodeBase64Data:(NSData *)data {
    return [GTMBase64 encodeData:data];
//    return [data base64EncodedDataWithOptions:0];
}

+ (NSData *)decodeBase64Data:(NSData *)data {
    return [GTMBase64 decodeData:data];
//    return [[NSData alloc] initWithBase64EncodedData:data options:0];
}

@end

