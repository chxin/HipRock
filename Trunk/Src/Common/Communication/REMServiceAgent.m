/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMServiceAgent.m
 * Created      : zhangfeng on 7/5/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
#import "REMNetworkStatusIndicator.h"


@implementation REMServiceAgent

#define kREMCommMaxQueueWifi 16
#define kREMCommMaxQueue3G 3

static NSOperationQueue *queue = nil;
static int maxQueueLength = kREMCommMaxQueueWifi;
#define kREMLogResquest 0 //0:no log, 1:log partial, 2: log full

#ifdef DEBUG
static int requestTimeout = 1000; //(s)
#endif

#ifdef DailyBuild
static int requestTimeout = 45; //(s)
#endif

#ifdef InternalRelease
static int requestTimeout = 45; //(s)
#endif


#define NetworkIncreaseActivity() [[REMNetworkStatusIndicator sharedManager] increaseActivity];
#define NetworkDecreaseActivity() [[REMNetworkStatusIndicator sharedManager] decreaseActivity];
#define NetworkClearActivity() [[REMNetworkStatusIndicator sharedManager] noActivity];



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
#ifdef DEBUG
        [REMServiceAgent logResponse:service :operation];
#endif
        
        //if there is error message
        if([operation.responseString hasPrefix:@"{\"error\":"] == YES){
            //TODO: process error message with different error types
            REMBusinessErrorInfo *remErrorInfo = [[REMBusinessErrorInfo alloc] initWithJSONString:operation.responseString];
            
            REMError *remError = [[REMError alloc] initWithErrorInfo:remErrorInfo];
            
            error(remError,remErrorInfo);
            NetworkDecreaseActivity();
            
            if(maskContainer!=nil && maskManager != nil) //if mask has already shown
            {
                [maskManager hideMask];
            }
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
        
        NetworkDecreaseActivity();
        operation = nil;
    };
    
    void (^onFailure)(AFHTTPRequestOperation *operation, NSError *errorInfo) = ^(AFHTTPRequestOperation *operation, NSError *errorInfo)
    {
        REMLogError(@"Communication error: %@\nUrl: %@\nServer response: %@", [error description], [operation.request.URL description], operation.responseString);
        
        if(errorInfo.code == -1001){
            [REMAlertHelper alert:@"数据加载超时"];
        }
        else if(errorInfo.code == -999){
            REMLogInfo(@"Request canceled");
        }
        else{
            if(error)
            {
                error(errorInfo,operation.responseString);
            }
        }
        if(maskContainer!=nil && maskManager != nil)
        {
            [maskManager hideMask];
        }
        
        NetworkDecreaseActivity();
    };
    
    void (^onProgress)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) = ^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
    {
        if(progress)
            progress(bytesRead,totalBytesRead,totalBytesExpectedToRead);
    };
    
    REMServiceRequestOperation *serviceOperation = [REMServiceRequestOperation operationWithRequest:request];
    
    [serviceOperation setCompletionBlockWithSuccess:onSuccess failure:onFailure];
    [serviceOperation setDownloadProgressBlock:onProgress];
    [serviceOperation setMaskManager:maskManager];
    if(groupName!=nil && [groupName isEqual:[NSNull null]]==NO && [groupName isEqualToString:@""] == NO)
    {
        serviceOperation.groupName = groupName;
    }
    
    if(queue == nil)
    {
        [REMServiceAgent initializeQueue];
    }
    
//log the request
#ifdef DEBUG
    [REMServiceAgent logRequest:request];
#endif
    
    [queue addOperation:serviceOperation];
    
    NetworkIncreaseActivity();
}


+ (void) cancel
{
    if(queue!=NULL && queue != nil && queue.operationCount > 0)
    {
        [queue cancelAllOperations];
        
        NetworkClearActivity();
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
            NetworkDecreaseActivity();
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
            maxQueueLength = kREMCommMaxQueueWifi;
            break;
        case ReachableViaWWAN:
            maxQueueLength = kREMCommMaxQueue3G;
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
    [request setTimeoutInterval:requestTimeout];
    [request setCachePolicy:NSURLCacheStorageAllowedInMemoryOnly];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setTimeoutInterval:requestTimeout];
    
    //add agent string
    [request setValue:[REMServiceAgent getUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    //add client version string
    [request setValue:[NSString stringWithUTF8String:[REMApplicationInfo getVersion]] forHTTPHeaderField:@"Blues-Version"];
    
    //add user info
    [request setValue:[REMServiceAgent getUserInfo] forHTTPHeaderField:@"Blues-User"];
    
    //enable gzip
    [request setValue:@"gzip,deflate,sdch" forHTTPHeaderField:@"accept-encoding"];
    
    if(data!=NULL && data != nil && data.length > 0)
    {
        [request setHTTPBody:data];
    }
    
    return request;
}

+ (NSString *)getUserAgent
{
    NSString *userAgentFormat = @"Blues/0.4(PS;%@;%@;%@;%@;%@;)";
    UIDevice *device = [UIDevice currentDevice];
    
    NSString *content=[NSString stringWithFormat:userAgentFormat,[[device identifierForVendor] UUIDString],[device localizedModel],[device systemName],[device systemVersion],[device model]];
    
    return content;
}

+ (NSString *)getUserInfo
{
    NSString *original = [NSString stringWithFormat:@"%lld|%@|%lld",REMAppCurrentUser.userId,REMAppCurrentUser.name, REMAppCurrentUser.spId];
    
    NSData *encryptedData = [REMEncryptHelper AES256EncryptData:[original dataUsingEncoding:NSUTF8StringEncoding] withKey:@"41758bd9d7294737"];
    
    NSString *base64Encoded = [REMEncryptHelper encodeBase64Data:encryptedData];
    
    //NSLog(@"%@",original);
    //NSLog(@"%@",base64Encoded);
    
    return base64Encoded;
}

+(id)deserializeResult:(NSString *)resultJson ofService:(NSString *)service
{
    NSDictionary *result = [REMJSONHelper objectByString:resultJson];
    
    return [result valueForKey:[NSString stringWithFormat:@"%@Result",[service lastPathComponent]]];
}

+(void)logRequest:(NSURLRequest *)request
{
    if(kREMLogResquest != 0){
        NSLog(@"REM-REQUEST: %@", [request.URL description]);
    }
}

+(void)logResponse:(REMServiceMeta *)service :(AFHTTPRequestOperation *)operation
{
    if(kREMLogResquest !=0 ){
        int shortJsonStringLength = 48;
        if(service.responseType == REMServiceResponseJson){
            NSString *jsonString = operation.responseString;
            if(kREMLogResquest == 1 && jsonString.length > shortJsonStringLength){
                jsonString = [NSString stringWithFormat:@"%@..",[jsonString substringToIndex:shortJsonStringLength]];
            }
            NSLog(@"REM-RESPONSE url: %@", service.url);
            NSLog(@"REM-RESPONSE json: %@", jsonString);
        }
        else
            NSLog(@"REM-RESPONSE data: %d bytes", [operation.responseData length]);
    }
}
@end

