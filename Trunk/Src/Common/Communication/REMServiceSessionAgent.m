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

@implementation REMServiceSessionAgent

#define kREMCommMaxQueueWifi 16
#define kREMCommMaxQueue3G 3

#define REMCurrentDevice ([UIDevice currentDevice])
#define REMBluesUserAgent ([NSString stringWithFormat:@"Blues/1.0(PS;%@;%@;%@;%@;%@;)", [[REMCurrentDevice identifierForVendor] UUIDString],[REMCurrentDevice localizedModel],[REMCurrentDevice systemName],[REMCurrentDevice systemVersion],[REMCurrentDevice model]])

static NSURLSessionConfiguration *sessionConfiguration = nil;
static NSOperationQueue *queue = nil;
static int kMaxQueueLength = kREMCommMaxQueueWifi;

+ (void) call: (REMServiceMeta *) service withBody:(id)body mask:(UIView *) maskContainer group:(NSString *)groupName success:(REMDataAccessSuccessBlock)success error:(REMDataAccessErrorBlock)error progress:(REMDataAccessProgressBlock)progress
{
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
        
        NSDictionary *additionalHeaders = @{@"Accept": @"application/json",
                                            @"accept-encoding": @"gzip,deflate,sdch",
                                            @"User-Agent": REMBluesUserAgent,
                                            @"Blues-Version": [NSString stringWithUTF8String:[REMApplicationInfo getVersion]],
                                            @"Blues-User": [REMEncryptHelper base64AES256EncryptString:[NSString stringWithFormat:@"%lld|%@|%lld",REMAppCurrentUser.userId,REMAppCurrentUser.name, REMAppCurrentUser.spId] withKey:REMSecurityTokenKey],
                                            };
        
        [sessionConfiguration setHTTPAdditionalHeaders:additionalHeaders];
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

@end
