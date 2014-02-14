/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMServiceRequestOperation.h
 * Created      : zhangfeng on 6/28/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "REMMaskManager.h"

//typedef void(^REMDataAccessProgressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);
typedef void(^REMServiceOperationSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void(^REMServiceOperationFailureBlock)(AFHTTPRequestOperation *operation, NSError *errorInfo);
typedef void(^REMServiceOperationProgressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);


@interface REMServiceRequestOperation : AFHTTPRequestOperation

@property (nonatomic,retain) NSString *groupName;

@property (nonatomic,strong) REMMaskManager *maskManager;

+ (instancetype)operationWithRequest:(NSURLRequest *)urlRequest;
//+ (instancetype)operationWithRequest:(NSURLRequest *)urlRequest success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
