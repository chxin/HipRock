//
//  REMRemoteService.m
//  Blues
//
//  Created by 张 锋 on 3/14/14.
//
//

#import "REMRemoteServiceRequest.h"
#import "AFNetworking.h"
#import "REMCommonHeaders.h"
#import "REMAppConfiguration.h"
#import "REMApplicationContext.h"
#import "REMEncryptHelper.h"
#import "REMHTTPRequestOperationManager.h"
#import "REMBusinessErrorInfo.h"
#import "REMError.h"

@interface REMRemoteServiceRequest()

/**
 *  Pointer to the actual operation
 */
@property (nonatomic,weak) REMHTTPRequestOperation *operation;

@end

@implementation REMRemoteServiceRequest


- (void) request:(REMDataAccessSuccessBlock)success failure:(REMDataAccessFailureBlock)failure
{
    REMHTTPRequestOperationManager *manager = REMAppContext.sharedRequestOperationManager;
    
    NSURLRequest *request = [manager.requestSerializer requestBySerializingRequest:[self buildRequest] withParameters:self.dataStore.parameter error:nil] ;
    
#ifdef DEBUG
    [self logRequest:request];
    NSDate *start = [NSDate date];
#endif
    
    REMHTTPRequestOperation *operation = [manager RequestOperationWithRequest:request responseType:self.dataStore.responseType success:^(AFHTTPRequestOperation *operation, id responseObject) {
#ifdef DEBUG
        [self logOperation:operation startedOn:start withError:nil];
#endif
        //authorization check
        NSString *auth = operation.response.allHeaderFields[@"Blues-Version"];
        if(!REMIsNilOrNull(auth) && ![auth isEqualToString:@"Allow"]){
            failure(nil,REMDataAccessUnsupported,nil);
            return;
        }
        
        //if there is error message, enter ERROR status
        if([operation.responseString hasPrefix:@"{\"error\":"] == YES) {
            //TODO: process error message with different error types
            REMBusinessErrorInfo *businessError = [[REMBusinessErrorInfo alloc] initWithJSONString:operation.responseString];
            REMError *error = [[REMError alloc] initWithErrorInfo:businessError];
            
            failure(error, REMDataAccessErrorMessage, businessError);
        }
        else{ //if ok, enter SUCCESS status
            id result = self.dataStore.responseType == REMServiceResponseJson ? ([responseObject allKeys].count > 0 ? responseObject[[responseObject allKeys][0]] : nil) : responseObject;
            success(result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#ifdef DEBUG
        [self logOperation:operation startedOn:start withError:error];
#endif
        REMDataAccessStatus status = [self decideErrorStatus:error];
        
        failure(error, status, operation.responseString);
    }];
    
    operation.group = self.dataStore.groupName;
    
    //NSLog(@"%@", request.URL.absoluteString);
    [manager.operationQueue addOperation:operation];
    self.operation = operation;
}

- (void) cancel
{
    [self.operation cancel];
}


#pragma mark - @privates
-(NSMutableURLRequest *)buildRequest
{
    NSURL *url = [[NSURL alloc] initWithString:self.dataStore.url relativeToURL:[NSURL URLWithString:REMAppConfig.currentDataSource[@"url"]]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setTimeoutInterval:REMAppConfig.requestTimeout];
    [request setCachePolicy:NSURLCacheStorageAllowedInMemoryOnly];
    [request setHTTPMethod: @"POST"];
    
    [request setAllHTTPHeaderFields:[self buildHeaders]];
    
    return request;
}


- (NSDictionary *)buildHeaders
{
    NSString *build = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSString *fullVersion = [NSString stringWithFormat:@"%@.%@",version,build];
    
    NSString *userAgent = [NSString stringWithFormat:@"Blues/%@(ESS;%@;%@;%@;%@;%@;)", fullVersion, [[REMCurrentDevice identifierForVendor] UUIDString],[REMCurrentDevice localizedModel],[REMCurrentDevice systemName],[REMCurrentDevice systemVersion],[REMCurrentDevice model]];
    REMManagedUserModel *user = REMAppContext.currentUser;
    NSString *info = [NSString stringWithFormat:@"%lld|%@|%lld",[user.id longLongValue],user.name, [user.spId longLongValue] == 0 ? -1 : [user.spId longLongValue]];
    NSLog(info);
    NSString *token = [REMEncryptHelper base64AES256EncryptString:info withKey:REMSecurityTokenKey];
    
    NSString *accept = self.dataStore.responseType == REMServiceResponseJson ? @"*/*":@"image/webp,*/*;";
    NSString *language = [NSLocale canonicalLanguageIdentifierFromString:[NSLocale preferredLanguages][0]];
    language = [language isEqualToString:@"zh-Hans"] ? @"zh_CN" : @"en_US";
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary: @{ @"Accept": accept,
                              @"Content-Type": @"application/json",
                              @"accept-encoding": @"gzip,deflate,sdch",
                              @"User-Agent": userAgent,
                              @"Blues-Version": fullVersion,
                              @"Blues-Token": token,
                              @"Blues-Language": language,
                              }];
    
    return headers;
}

-(REMDataAccessStatus)decideErrorStatus:(NSError *)error
{
    REMDataAccessStatus status = REMDataAccessFailed;
    
    if(error.code == -999){
        status = REMDataAccessCanceled;
        REMLogInfo(@"Request canceled");
    }
    else{
        status = REMDataAccessFailed;
        REMLogInfo(@"Network failure with code: %d, message: %@", error.code, error.description);
    }
    
    return status;
}

-(void)logRequest:(NSURLRequest *)request
{
    if(REMAppConfig.requestLogMode != nil && [REMAppConfig.requestLogMode integerValue] > 0) {
        NSLog(@"Outgoing request: %@", request.URL.absoluteString);
    }
}

-(void)logOperation:(AFHTTPRequestOperation *)operation startedOn:(NSDate *)date withError:(NSError *)error
{
    if(REMAppConfig.requestLogMode != nil && [REMAppConfig.requestLogMode integerValue] > 0) {
        NSTimeInterval totalTime = [[NSDate date] timeIntervalSinceDate:date];
        
        BOOL isJson = self.dataStore.responseType == REMServiceResponseJson;
        BOOL isFullLog = [REMAppConfig.requestLogMode integerValue] > 1;
        
        NSURLRequest *request = operation.request;
        NSHTTPURLResponse *response = operation.response;
        
        NSMutableString *log = [NSMutableString stringWithString:@"---------------------------------\n"];
        
        [log appendFormat:@"REQ:%@\n", [request.URL absoluteString]];
        
        if(isFullLog){
            //[log appendFormat:@" User-Agent    : %@\n", request.allHTTPHeaderFields[@"User-Agent"]];
            //[log appendFormat:@" Blues-Version : %@\n", request.allHTTPHeaderFields[@"Blues-Version"]];
            [log appendFormat:@"-TOKN:%@\n", request.allHTTPHeaderFields[@"Blues-Token"]];
            [log appendFormat:@"-BODY:%@\n", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]];
        }
        
        //[log appendString:@"\n"];
        
        if(error != nil){
            [log appendFormat:@"RSP:(ERROR) %@\n", [error description]];
            return;
        }
        
        [log appendFormat:@"RSP:%@ %d(bytes) in %f(s)\n", isJson ? @"json":@"data", [operation.responseData length],totalTime];
        
        if(isJson) {
            if(isFullLog){
                [log appendFormat:@"-AUTH:%@\n", response.allHeaderFields[@"Blues-Version"]];
                [log appendFormat:@"-BODY:%@\n", operation.responseString];
            }
            else{
                [log appendFormat:@"-BODY:%@", [NSString stringWithFormat:@"%@..",[operation.responseString substringToIndex:64]]];
            }
        }
        
        NSLog(@"%@",log);
    }
}

@end
