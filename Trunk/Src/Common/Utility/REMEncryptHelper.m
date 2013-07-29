//
//  REMEncryptHelper.m
//  Blues
//
//  Created by 张 锋 on 7/29/13.
//
//

#import "REMEncryptHelper.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation REMEncryptHelper

+ (NSString *)desEncrypt:(NSString *)plain
{
    return [plain copy];
}

+ (NSString *)encodeBase64:(NSString *)plain
{
    NSData *data = [plain dataUsingEncoding:NSUTF8StringEncoding];
    data 
}

+ (NSString *)decodeBase64:(NSString *)base64String
{
    
}

@end
