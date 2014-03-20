//
//  REMHTTPRequestOperationManager.h
//  Blues
//
//  Created by 张 锋 on 3/17/14.
//
//

#import "AFNetworking.h"
#import "REMDataStore.h"

/**
 *  Override to AFHTTPRequestOperation
 *
 *  This class has add a property "group" into AFHTTPRequestOperation
 *  to identify which group the operation belongs to
 *
 *  AFHTTPRequestOperation and REMHTTPRequestOperationManager class
 *  has provided grouping request feature together.
 *
 */
@interface REMHTTPRequestOperation : AFHTTPRequestOperation

/**
 *  Group, which identifies which group the operation belongs to
 */
@property (nonatomic,strong) NSString *group;

@end

/**
 *  Override to AFHTTPRequestOperationManager
 *
 *  Since we have defined our own HTTP request operation, 
 *  which has overrided AFHTTPRequestOperation, we have to
 *  create our own operation manager to create the customized
 *  HTTP request operation.
 *
 *  This class has also provided cancel class method to allow
 *  caller to cancel the specified group operations in the request
 *  queue.
 *
 *  AFHTTPRequestOperation and REMHTTPRequestOperationManager class
 *  has provided grouping request feature together.
 *
 */
@interface REMHTTPRequestOperationManager : AFHTTPRequestOperationManager

/**
 *  Make an instance of REMHTTPRequestOperation
 *
 *  @param request      The request to be executed
 *  @param responseType Json of Image, parse to NSDictionary or UIImage
 *  @param success      Success callback block
 *  @param failure      Failure callback block
 *
 *  @return <#return value description#>
 */
- (REMHTTPRequestOperation *)RequestOperationWithRequest:(NSURLRequest *)request responseType:(REMServiceResponseType)responseType  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  Cancel a group of operations in the request queue
 *
 *  @param group Group name, if this param is nil, all requests currently in the request queue will be canceled
 */
+ (void) cancel:(NSString *)group;

@end