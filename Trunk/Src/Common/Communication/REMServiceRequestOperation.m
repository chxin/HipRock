//
//  REMServiceRequestOperation.m
//  Blues
//
//  Created by zhangfeng on 6/28/13.
//
//

#import "REMServiceRequestOperation.h"

@implementation REMServiceRequestOperation

+ (instancetype)operationWithRequest:(NSURLRequest *)urlRequest
{
    REMServiceRequestOperation *operation = [(REMServiceRequestOperation *)[self alloc] initWithRequest:urlRequest];
    
    return operation;
}

+ (instancetype)operationWithRequest:(NSURLRequest *)urlRequest success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    REMServiceRequestOperation *operation = [(REMServiceRequestOperation *)[self alloc] initWithRequest:urlRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
    
    return operation;
}

@end
