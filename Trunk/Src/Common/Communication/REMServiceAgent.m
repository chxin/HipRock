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
#import "REMNetworkHelper.h"
#import "REMAlertHelper.h"
#import "REMLog.h"
#import "REMJSONHelper.h"
#import "REMMaskManager.h"
#import "REMStorage.h"
#import "REMApplicationContext.h"
#import "REMEncryptHelper.h"
#import "REMApplicationInfo.h"
#import "REMBusinessErrorInfo.h"
#import "REMError.h"


@implementation REMServiceAgent

static NSOperationQueue *queue = nil;
static int maxQueueLength = 5;
static int requestTimeout = 1000; //(s)



+ (void) call: (REMServiceMeta *) service withBody:(id)body mask:(UIView *) maskContainer group:(NSString *)groupName store:(BOOL) isStore success:(void (^)(id data))success error:(void (^)(NSError *error, id response))error progress:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progress
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
        
        //NSLog(@"%@",parameterString);
    }
    
    NSURLRequest *request = [REMServiceAgent buildRequestWithUrl:service.url andPostData:postData];
    
    
    void (^onSuccess)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        //NSLog(@"%@", operation.responseString);
        
        //if there is error message
        if([operation.responseString hasPrefix:@"{\"error\":"] == YES){
            //TODO: process error message with different error types
            REMBusinessErrorInfo *remErrorInfo = [[REMBusinessErrorInfo alloc] initWithJSONString:operation.responseString];
            
            REMError *remError = [[REMError alloc] initWithErrorInfo:remErrorInfo];
            
            error(remError,remErrorInfo);
            
            return;
        }
        
        id result;
        
        if(service.responseType == REMServiceResponseImage)
        {
            result = operation.responseData;
        }
        else
        {
            result = [REMServiceAgent deserializeResult:operation.responseString ofService:service.url];
        }
        
        if(isStore==YES)
        {
            NSString *storageKey = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            switch (service.responseType) {
                case REMServiceResponseJson:
                    [REMStorage set:service.url key:storageKey value:[REMJSONHelper stringByObject:result] expired:REMSessionExpired];
                    break;
                case REMServiceResponseImage:
                    [REMStorage setFile:service.url key:storageKey version:0 image:result];
                    break;
                    
                default:
                    break;
            }
        }
        
        if(success)
        {
            success(result);
        }
        
        if(maskContainer!=nil && maskManager != nil) //if mask has already shown
        {
            [maskManager hideMask];
        }
        
        //
        operation = nil;
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
    
    //NSLog(@"request: %@",[request.URL description]);
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
    
    NSString *parameterString = [REMJSONHelper stringByObject:parameter];
    
    return parameterString;
}

+ (NSURLRequest *)buildRequestWithUrl: (NSString *)absoluteUrl andPostData:(NSData *)data
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:absoluteUrl]];
    [request setTimeoutInterval:60*10];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setTimeoutInterval:requestTimeout];
    
    //add agent string
    [request setValue:[REMServiceAgent getUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    //add client version string
    [request setValue:[NSString stringWithUTF8String:[REMApplicationInfo getVersion]] forHTTPHeaderField:@"Blues-Version"];
    
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
    NSString *userAgentFormat = @"Blues/0.2(PS;%@;%@;%@;%@;%@;)";
    UIDevice *device = [UIDevice currentDevice];
    
    NSString *content=[NSString stringWithFormat:userAgentFormat,[[device identifierForVendor] UUIDString],[device localizedModel],[device systemName],[device systemVersion],[device model]];
    
    return content;
}

+ (NSString *)getUserInfo
{
    REMApplicationContext* context = [REMApplicationContext instance];
    NSString *original = [NSString stringWithFormat:@"%llu|%@|%llu",context.currentUser.userId,context.currentUser.name, context.currentUser.spId];
    //NSLog(@"%@",original);
    
    NSData *encryptedData = [REMEncryptHelper AES256EncryptData:[original dataUsingEncoding:NSUTF8StringEncoding] withKey:@"41758bd9d7294737"];
    
    NSString *base64Encoded = [REMEncryptHelper encodeBase64Data:encryptedData];
    //NSLog(@"%@",base64Encoded);
    return base64Encoded;
}

+(id)deserializeResult:(NSString *)resultJson ofService:(NSString *)service
{
    NSDictionary *result = [REMJSONHelper objectByString:resultJson];
    
    return [result valueForKey:[NSString stringWithFormat:@"%@Result",[service lastPathComponent]]];
}

@end
