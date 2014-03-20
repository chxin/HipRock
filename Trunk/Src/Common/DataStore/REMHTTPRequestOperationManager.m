//
//  REMHTTPRequestOperationManager.m
//  Blues
//
//  Created by 张 锋 on 3/17/14.
//
//

#import "REMHTTPRequestOperationManager.h"
#import "UIKit+AFNetworking.h"
#import "REMDataStore.h"

#pragma mark -
@implementation REMHTTPRequestOperation


@end


#pragma mark -

@implementation REMHTTPRequestOperationManager

const static int kMAXQUEUEWIFI = 16;
const static int kMAXQUEUEWWAN = 3;

static NSOperationQueue *queue;

+ (instancetype)manager {
    REMHTTPRequestOperationManager *manager = [[[self class] alloc] initWithBaseURL:nil];
    manager.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [manager.reachabilityManager startMonitoring];
    
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusReachableViaWiFi){
            queue.maxConcurrentOperationCount = kMAXQUEUEWIFI;
        }
        else if(status == AFNetworkReachabilityStatusReachableViaWWAN){
            queue.maxConcurrentOperationCount = kMAXQUEUEWWAN;
        }
        else{
            queue.maxConcurrentOperationCount = kMAXQUEUEWIFI;
        }
        
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    
    if(queue == nil){
        queue = [[NSOperationQueue alloc] init];
    }
    
    manager.operationQueue = queue;
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    return manager;
}

- (REMHTTPRequestOperation *)RequestOperationWithRequest:(NSURLRequest *)request responseType:(REMServiceResponseType)responseType  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    REMHTTPRequestOperation *operation = [[REMHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = self.responseSerializer;
    operation.shouldUseCredentialStorage = self.shouldUseCredentialStorage;
    operation.credential = self.credential;
    operation.securityPolicy = self.securityPolicy;
    
    [self setOperationAcceptableContentTypes:operation withResponseType:responseType];
    
    [operation setCompletionBlockWithSuccess:success failure:failure];
    
    return operation;
}

/**
 *  <#Description#>
 *
 *  @param operation    <#operation description#>
 *  @param responseType <#responseType description#>
 */
- (void)setOperationAcceptableContentTypes:(REMHTTPRequestOperation *)operation withResponseType:(REMServiceResponseType)responseType
{
    operation.responseSerializer = responseType == REMServiceResponseJson ? [AFJSONResponseSerializer serializer] : [AFImageResponseSerializer serializer];
    NSMutableSet *acceptableContentTypes = [NSMutableSet setWithSet:operation.responseSerializer.acceptableContentTypes];
    [acceptableContentTypes addObject:@"text/html"];
    operation.responseSerializer.acceptableContentTypes = acceptableContentTypes;
}


+(void)cancel:(NSString *)group
{
    if(queue!=NULL && queue != nil && queue.operationCount > 0)
    {
        NSMutableArray *cancelList = [[NSMutableArray alloc] init];
        
        [queue setSuspended:YES];
        for(int i=0;i<queue.operations.count;i++){
            id operation = nil;
            @try {
                if(i<=queue.operations.count-1){
                    operation = queue.operations[i];
                }
            }
            @catch (NSException *exception) {
                REMLogError(@"Cancel request error: %@", [exception description]);
                continue;
            }
            
            if(operation!=nil && [operation isEqual:[NSNull null]] == NO && [((REMHTTPRequestOperation *)operation).group isEqualToString:group] == YES){
                [cancelList addObject:operation];
            }
        }
        [queue setSuspended:NO];
        
        for(REMHTTPRequestOperation *operation in cancelList){
            [operation cancel];
        }
    }
}

@end
