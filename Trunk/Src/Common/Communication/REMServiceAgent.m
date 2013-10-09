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

#ifdef DEBUG
static int requestTimeout = 1000; //(s)
#endif

#ifdef DailyBuild
static int requestTimeout = 45; //(s)
#endif

#ifdef InternalRelease
static int requestTimeout = 45; //(s)
#endif



+ (void) call: (REMServiceMeta *) service withBody:(id)body mask:(UIView *) maskContainer group:(NSString *)groupName store:(BOOL) isStore success:(void (^)(id data))success error:(void (^)(NSError *error, id response))error progress:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progress
{
    //check network status and notify if no connection or 3g or 2g
    if([REMServiceAgent checkNetworkStatus] == NO)
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
        if(service.responseType == REMServiceResponseJson)
            NSLog(@"%@", operation.responseString);
        
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
                    [REMStorage set:service.url key:storageKey value:[REMJSONHelper stringByObject:result] expired:REMWindowActiated];
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
        
        operation = nil;
    };
    
    void (^onFailure)(AFHTTPRequestOperation *operation, NSError *errorInfo) = ^(AFHTTPRequestOperation *operation, NSError *errorInfo)
    {
        REMLogError(@"Communication error: %@\nServer response: %@", [error description], operation.responseString);
        
        if(errorInfo.code == -1001){
            [REMAlertHelper alert:@"数据加载超时"];
            return;
        }
        if(errorInfo.code == -999){
            REMLogInfo(@"Request canceled");
            return;
        }
        
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
    serviceOperation.maskManager=maskManager;
    if(groupName!=nil && [groupName isEqual:[NSNull null]]==NO && [groupName isEqualToString:@""] == NO)
    {
        serviceOperation.groupName = groupName;
    }
        
    //[serviceOperation start];
    
    if(queue == nil)
    {
        [REMServiceAgent initializeQueue];
    }
    
    NSLog(@"request: %@",[request.URL description]);
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
        NSMutableArray *cancelList = [[NSMutableArray alloc] init];
        
        [queue setSuspended:YES];
        for(int i=0;i<queue.operations.count;i++)
        {
            id operation = nil;
            @try {
                if(i<=queue.operations.count-1)
                    operation = queue.operations[i];
            }
            @catch (NSException *exception) {
                REMLogError(@"Cancel request error: %@", [exception description]);
                continue;
            }
            
            if(operation!=nil && [operation isEqual:[NSNull null]] == NO && [((REMServiceRequestOperation *)operation).groupName isEqualToString:group] == YES)
            {
                [cancelList addObject:operation];
            }
        }
        [queue setSuspended:NO];
        
        for(REMServiceRequestOperation *operation in cancelList){
            if(operation.maskManager!=nil){
                [operation.maskManager hideMask];
            }
            [operation cancel];
        }
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
            [REMAlertHelper alert:@"无法获取最新能源数据" withTitle:@"无可用网络"];
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
    NSString *original = [NSString stringWithFormat:@"%lld|%@|%lld",context.currentUser.userId,context.currentUser.name, context.currentUser.spId];
    NSLog(@"%@",original);
    
    NSData *encryptedData = [REMEncryptHelper AES256EncryptData:[original dataUsingEncoding:NSUTF8StringEncoding] withKey:@"41758bd9d7294737"];
    
    NSString *base64Encoded = [REMEncryptHelper encodeBase64Data:encryptedData];
    NSLog(@"%@",base64Encoded);
    return base64Encoded;
}

+(id)deserializeResult:(NSString *)resultJson ofService:(NSString *)service
{
    NSDictionary *result = [REMJSONHelper objectByString:resultJson];
    
    return [result valueForKey:[NSString stringWithFormat:@"%@Result",[service lastPathComponent]]];
}

@end
