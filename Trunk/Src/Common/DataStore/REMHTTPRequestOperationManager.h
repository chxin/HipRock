//
//  REMHTTPRequestOperationManager.h
//  Blues
//
//  Created by 张 锋 on 3/17/14.
//
//

#import "AFNetworking.h"
#import "REMDataStore.h"

@interface REMHTTPRequestOperation : AFHTTPRequestOperation

@property (nonatomic,strong) NSString *group;

@end

@interface REMHTTPRequestOperationManager : AFHTTPRequestOperationManager

- (REMHTTPRequestOperation *)RequestOperationWithRequest:(NSURLRequest *)request responseType:(REMServiceResponseType)responseType  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void) cancel:(NSString *)group;

@end