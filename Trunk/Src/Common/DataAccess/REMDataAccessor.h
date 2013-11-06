/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMDataAccessor.h
 * Created      : zhangfeng on 6/28/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMDataStore.h"

@interface REMDataAccessor : NSObject


+ (void) access: (REMDataStore *) store success:(void (^)(id data))success;

+ (void) access: (REMDataStore *) store success:(void (^)(id data))success error:(void (^)(NSError *error, id response))error;

+ (void) access: (REMDataStore *) store success:(void (^)(id data))success error:(void (^)(NSError *error, id response))error progress:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progress;

+ (void) cancelAccess;

+ (void) cancelAccess: (NSString *) groupName;


@end
