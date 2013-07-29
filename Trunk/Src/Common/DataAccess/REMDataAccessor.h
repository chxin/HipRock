//
//  REMDataAccessor.h
//  Blues
//
//  Created by zhangfeng on 6/28/13.
//
//

#import <Foundation/Foundation.h>
#import "REMDataStore.h"

@interface REMDataAccessor : NSObject


+ (void) access: (REMDataStore *) store success:(void (^)(id data))success;

+ (void) access: (REMDataStore *) store success:(void (^)(id data))success error:(void (^)(NSError *error, id response))error;

+ (void) access: (REMDataStore *) store success:(void (^)(id data))success error:(void (^)(NSError *error, id response))error progress:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progress;

+ (void) cancelAccess;

+ (void) cancelAccess: (NSString *) groupName;


@end
