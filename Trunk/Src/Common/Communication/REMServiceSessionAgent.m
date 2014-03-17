//
//  REMServiceSessionAgent.m
//  Blues
//
//  Created by 张 锋 on 3/3/14.
//
//

#import "REMServiceSessionAgent.h"
#import "REMApplicationInfo.h"
#import "REMApplicationContext.h"
#import "REMEncryptHelper.h"
#import "REMCommonDefinition.h"
#import "Reachability.h"
#import "REMJSONObject.h"
#import "REMJSONHelper.h"
@implementation REMServiceSessionAgent

#define kREMCommMaxQueueWifi 16
#define kREMCommMaxQueue3G 3


static NSURLSessionConfiguration *sessionConfiguration = nil;
static NSOperationQueue *queue = nil;
static int kMaxQueueLength = kREMCommMaxQueueWifi;

+ (void) call: (REMServiceMeta *) service withBody:(id)body mask:(UIView *) maskContainer group:(NSString *)groupName success:(REMDataAccessSuccessBlock)success error:(REMDataAccessErrorBlock)error progress:(REMDataAccessProgressBlock)progress
{
    
    [REMServiceSessionAgent updateQueueLength];
    
    
    
    
    
    NSURLSession *session = [REMServiceSessionAgent getSession];
    NSURLRequest *request = [REMServiceSessionAgent buildRequestWithUrl:service.url andBody:body];
    
    
    
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        ;
    }];
    
    [task resume];
}

+ (NSURLRequest *)buildRequestWithUrl:(NSString *)absoluteUrl andBody:(id)body
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:absoluteUrl]];
    [request setTimeoutInterval:REMAppConfig.requestTimeout];
    [request setHTTPMethod: @"POST"];
    
    if(!REMIsNilOrNull(body)) {
        NSData *bodyData = [body isMemberOfClass:[NSData class]] ? body : [[REMJSONHelper stringByObject:body] dataUsingEncoding:NSUTF8StringEncoding];
        
        [request setHTTPBody:bodyData];
    }
    
    return request;
}

+(NSURLSession *)getSession
{
    if(sessionConfiguration == nil){
        sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        [sessionConfiguration setAllowsCellularAccess:YES];
        [sessionConfiguration setTimeoutIntervalForRequest:REMAppConfig.requestTimeout];
        [sessionConfiguration setHTTPAdditionalHeaders:[REMServiceSessionAgent getHeaders]];
    }
    
    return [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:[REMServiceSessionAgent getQueue]];
}

+ (NSOperationQueue *)getQueue
{
    if(queue == nil){
        queue = [[NSOperationQueue alloc] init];
        [queue setMaxConcurrentOperationCount:kMaxQueueLength];
    }
    
    return queue;
}

+ (NSDictionary *)getHeaders
{
    NSString *version = [NSString stringWithUTF8String:[REMApplicationInfo getVersion]];
    
    NSString *userAgent = [NSString stringWithFormat:@"Blues/%@(PS;%@;%@;%@;%@;%@;)", version, [[REMCurrentDevice identifierForVendor] UUIDString],[REMCurrentDevice localizedModel],[REMCurrentDevice systemName],[REMCurrentDevice systemVersion],[REMCurrentDevice model]];
    REMManagedUserModel *user = REMAppCurrentManagedUser;
    NSString *token = [REMEncryptHelper base64AES256EncryptString:[NSString stringWithFormat:@"%lld|%@|%lld",[user.id longLongValue],user.name, [user.spId longLongValue] ] withKey:REMSecurityTokenKey];
    
    NSDictionary *headers = @{@"Accept": @"application/json",
                              @"accept-encoding": @"gzip,deflate,sdch",
                              @"User-Agent": userAgent,
                              @"Blues-Version": version,
                              @"Blues-User": token,
                              };
    return headers;
}

+ (BOOL)updateQueueLength
{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus currentNetworkStatus = [reachability currentReachabilityStatus];
    switch (currentNetworkStatus)
    {
        case NotReachable:
            //[REMAlertHelper alert:@"无法获取最新能源数据" withTitle:@"无可用网络"];
            kMaxQueueLength = 0;
            return NO;
        case ReachableViaWiFi:
            kMaxQueueLength = kREMCommMaxQueueWifi;
            break;
        case ReachableViaWWAN:
            kMaxQueueLength = kREMCommMaxQueue3G;
            break;
            
        default:
            break;
    }
    return YES;
}

@end
