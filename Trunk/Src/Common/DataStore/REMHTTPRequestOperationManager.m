//
//  REMHTTPRequestOperationManager.m
//  Blues
//
//  Created by 张 锋 on 3/17/14.
//
//

#import "REMHTTPRequestOperationManager.h"

@implementation REMHTTPRequestOperationManager

const static int kMAXQUEUEWIFI = 16;
const static int kMAXQUEUEWWAN = 3;

static NSOperationQueue *queue;

+ (instancetype)manager {
    REMHTTPRequestOperationManager *manager = [[[self class] alloc] initWithBaseURL:nil];
    manager.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusReachableViaWiFi){
            queue.maxConcurrentOperationCount = kMAXQUEUEWIFI;
        }
        else if(status == AFNetworkReachabilityStatusReachableViaWWAN){
            queue.maxConcurrentOperationCount = kMAXQUEUEWWAN;
        }
        else{
            queue.maxConcurrentOperationCount = 0;
        }
        
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    
    if(queue == nil){
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = [manager.reachabilityManager isReachableViaWiFi]?kMAXQUEUEWIFI:[manager.reachabilityManager isReachableViaWWAN] ? kMAXQUEUEWWAN : 0;
    }
    
    manager.operationQueue = queue;
    
    return manager;
}

- (REMHTTPRequestOperation *)RequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    REMHTTPRequestOperation *operation = [[REMHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = self.responseSerializer;
    operation.shouldUseCredentialStorage = self.shouldUseCredentialStorage;
    operation.credential = self.credential;
    operation.securityPolicy = self.securityPolicy;
    
    [operation setCompletionBlockWithSuccess:success failure:failure];
    
    return operation;
}


/**
 *  <#Description#>
 *
 *  @param group <#group description#>
 */
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

@implementation REMHTTPRequestOperation



@end