//
//  REMServiceRequestOperation.h
//  Blues
//
//  Created by zhangfeng on 6/28/13.
//
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

@interface REMServiceRequestOperation : AFHTTPRequestOperation

@property (nonatomic,retain) NSString *groupName;

+ (instancetype)operationWithRequest:(NSURLRequest *)urlRequest;
//+ (instancetype)operationWithRequest:(NSURLRequest *)urlRequest success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
