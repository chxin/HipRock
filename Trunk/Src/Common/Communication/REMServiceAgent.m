//
//  REMServiceAgent.m
//  Blues
//
//  Created by zhangfeng on 7/5/13.
//
//

#import "REMServiceAgent.h"
#import "AFHTTPRequestOperation.h"
#import "REMServiceRequestOperation.h"
#import "REMServiceUrl.h"
#import "REMNetworkHelper.h"
#import "REMAlertHelper.h"
#import "REMLog.h"
#import "REMJSONHelper.h"
#import "REMMaskManager.h"
#import "REMStorage.h"
#import "REMApplicationContext.h"
#import "REMEncryptHelper.h"


@implementation REMServiceAgent

static NSOperationQueue *queue = nil;
static int maxQueueLength = 5;



+ (void) call: (NSString *) serviceUrl withBody:(id)body mask:(UIView *) maskContainer group:(NSString *)groupName store:(BOOL) isStore success:(void (^)(id data))success error:(void (^)(NSError *error, id response))error progress:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progress
{
    //check network status and notify if no connection or 3g or 2g
    if(![REMServiceAgent checkNetworkStatus])
    {
        return;
    }
    
    REMMaskManager *maskManager = nil;
    //handle mask
    if(maskContainer!=nil)
    {
        maskManager = [[REMMaskManager alloc] initWithContainer:maskContainer];
        [maskManager showMask];
    }
    
    NSData *postData;
    if([body isMemberOfClass:[NSData class]])
    {
        postData = body;
    }
    else
    {
        NSString *parameterString = [REMServiceAgent buildParameterString:(NSDictionary *)body];
        postData = [parameterString dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSURLRequest *request = [REMServiceAgent buildRequestWith:serviceUrl andPostData:postData];
    
    
    void (^onSuccess)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"%@", operation.responseString);
                
        NSDictionary *result = [REMServiceAgent deserializeResult:operation.responseString ofService:serviceUrl];

        //NSDictionary *errorInfo = (NSDictionary *)[result valueForKey:@"error"];
        //TODO: process error message with different error types
        
        if(isStore==YES)
        {
            [REMStorage set:serviceUrl key:[NSString stringWithUTF8String:[postData bytes]] value:operation.responseString expired:10000];
        }
        
        if(success)
        {
            success(result);
        }
        
        if(maskContainer!=nil && maskManager != nil) //if mask has already shown
        {
            [maskManager hideMask];
        }
    };
    
    void (^onFailure)(AFHTTPRequestOperation *operation, NSError *errorInfo) = ^(AFHTTPRequestOperation *operation, NSError *errorInfo)
    {
        REMLogError(@"Communication error: %@\nServer response: %@", [error description], operation.responseString);
        
        if(error)
        {
            error(errorInfo,operation.responseString);
        }
        
        if(maskContainer!=nil && maskManager != nil)
        {
            [maskManager hideMask];
        }
    };
    
    void (^onProgress)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) = ^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
    {
        if(progress)
            progress(bytesRead,totalBytesRead,totalBytesExpectedToRead);
    };
    
    REMServiceRequestOperation *serviceOperation = [REMServiceRequestOperation operationWithRequest:request];
    
    [serviceOperation setCompletionBlockWithSuccess:onSuccess failure:onFailure];
    [serviceOperation setDownloadProgressBlock:onProgress];
    
    if(groupName != NULL && groupName!=nil && [groupName isEqualToString:@""])
    {
        serviceOperation.groupName = groupName;
    }
        
    //[serviceOperation start];
    
    if(queue == nil)
    {
        [REMServiceAgent initializeQueue];
    }
    
    [queue addOperation:serviceOperation];
}


+ (void) cancel
{
    if(queue!=NULL && queue != nil && queue.operationCount > 0)
    {
        [queue cancelAllOperations];
    }
}

+ (void) cancel: (NSString *) group
{
    if(queue!=NULL && queue != nil && queue.operationCount > 0)
    {
        [queue setSuspended:YES];
        for(int i=0;i<[queue operationCount];i++)
        {
            REMServiceRequestOperation *operation = (REMServiceRequestOperation *)[queue.operations objectAtIndex:i];
            if(operation.groupName == group)
            {
                [operation cancel];
            }
        }
        [queue setSuspended:NO];
    }
}


+ (void) initializeQueue
{
    if(queue == nil)
    {
        queue = [[NSOperationQueue alloc] init];
        [queue setMaxConcurrentOperationCount:maxQueueLength];
    }
}


+ (BOOL) checkNetworkStatus
{
    NetworkStatus currentNetworkStatus = [REMNetworkHelper checkCurrentNetworkStatus];
    switch (currentNetworkStatus)
    {
        case NotReachable:
            [REMAlertHelper alert:@"亲，网络不给力 :(" withTitle:@""];
            maxQueueLength = 0;
            return NO;
        case ReachableViaWiFi:
            maxQueueLength = 5;
            break;
        case ReachableViaWWAN3G:
            maxQueueLength = 2;
            break;
        case ReachableViaWWAN2G:
            maxQueueLength = 1;
            break;
            
        default:
            break;
    }
    return YES;
}

+ (NSString *)buildParameterString: (NSDictionary *)parameter
{
    if(parameter==nil)
    {
        return nil;
    }
    
    NSString *parameterString = [REMJSONHelper stringByDictionary:parameter];
    
    return parameterString;
}

+ (NSURLRequest *)buildRequestWith: (NSString *)absoluteUrl andPostData:(NSData *)data
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:absoluteUrl]];
    [request setTimeoutInterval:60*10];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //this is added by Aries at home
    [request setTimeoutInterval:100.0];
    
    //add agent string
    [request setValue:[REMServiceAgent getUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    //add client version string
    [request setValue:@"0.0.0.1" forHTTPHeaderField:@"Blues-Version"];
    
    //add user info
    [request setValue:[REMServiceAgent getUserInfo] forHTTPHeaderField:@"Blues-User"];
    
    if(data!=NULL && data != nil && data.length > 0)
    {
        [request setHTTPBody:data];
    }
    
    return request;
}

+ (NSString *)getUserAgent
{
    return @"blues agent";
}

+ (NSString *)getUserInfo
{
    REMApplicationContext* context = [REMApplicationContext instance];
    NSString *original = [NSString stringWithFormat:@"%llu|%@",context.currentUser.userId,context.currentUser.name];
    
    NSData *encryptedData = [REMEncryptHelper AES256EncryptData:[original dataUsingEncoding:NSUTF8StringEncoding] withKey:@"41758bd9d7294737"];
    
    NSString *base64Encoded = [REMEncryptHelper encodeBase64Data:encryptedData];
    NSLog(@"%@",base64Encoded);
    return base64Encoded;
}

+(NSDictionary *)deserializeResult:(NSString *)resultJson ofService:(NSString *)service
{
    NSDictionary *result = [REMJSONHelper dictionaryByJSONString:resultJson];
    
    return (NSDictionary *)[result valueForKey:[NSString stringWithFormat:@"%@Result",[service lastPathComponent]]];
}

@end
