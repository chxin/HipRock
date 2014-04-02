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
    
    REMHTTPRequestOperation *operation = [manager RequestOperationWithRequest:request responseType:self.dataStore.responseType success:^(AFHTTPRequestOperation *operation, id responseObject) {
#ifdef DEBUG
        [self logOperation:operation withError:nil];
#endif
        //if there is error message, enter ERROR status
        if([operation.responseString hasPrefix:@"{\"error\":"] == YES) {
            //TODO: process error message with different error types
            REMBusinessErrorInfo *businessError = [[REMBusinessErrorInfo alloc] initWithJSONString:operation.responseString];
            REMError *error = [[REMError alloc] initWithErrorInfo:businessError];
            
            failure(error, REMDataAccessErrorMessage, businessError);
        }
        else{ //if ok, enter SUCCESS status
            id result = self.dataStore.responseType == REMServiceResponseJson ? responseObject[[responseObject allKeys][0]] : responseObject;
            success(result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#ifdef DEBUG
        [self logOperation:operation withError:error];
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
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    
    NSString *userAgent = [NSString stringWithFormat:@"Blues/%@(ESS;%@;%@;%@;%@;%@;)", version, [[REMCurrentDevice identifierForVendor] UUIDString],[REMCurrentDevice localizedModel],[REMCurrentDevice systemName],[REMCurrentDevice systemVersion],[REMCurrentDevice model]];
    REMManagedUserModel *user = REMAppContext.currentUser;
    NSString *token = [REMEncryptHelper base64AES256EncryptString:[NSString stringWithFormat:@"%lld|%@|%lld",[user.id longLongValue],user.name, [user.spId longLongValue] ] withKey:REMSecurityTokenKey];
    
    NSString *accept = self.dataStore.responseType == REMServiceResponseJson ? @"*/*":@"image/webp,*/*;";
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary: @{ @"Accept": accept,
                              @"Content-Type": @"application/json",
                              @"accept-encoding": @"gzip,deflate,sdch",
                              @"User-Agent": userAgent,
                              @"Blues-Version": version,
                              @"Blues-User": token,
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
}

-(void)logOperation:(AFHTTPRequestOperation *)operation withError:(NSError *)error
{
    if(REMAppConfig.requestLogMode != nil && [REMAppConfig.requestLogMode integerValue] > 0) {
        NSURLRequest *request = operation.request;
        
        NSMutableString *log = [NSMutableString stringWithString:@"---------------------------------\n"];
        
        [log appendFormat:@"REQ:%@\n", [request.URL absoluteString]];
        
        if([REMAppConfig.requestLogMode integerValue] > 1){
            //[log appendFormat:@" User-Agent    : %@\n", request.allHTTPHeaderFields[@"User-Agent"]];
            //[log appendFormat:@" Blues-Version : %@\n", request.allHTTPHeaderFields[@"Blues-Version"]];
            [log appendFormat:@"-TOKN:%@\n", request.allHTTPHeaderFields[@"Blues-User"]];
            [log appendFormat:@"-BODY:%@\n", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]];
        }
        
        //[log appendString:@"\n"];
        
        if(error == nil){
            NSString *logContent = nil;
            if(self.dataStore.responseType == REMServiceResponseJson){
                logContent = [REMAppConfig.requestLogMode integerValue] > 1 ? operation.responseString : [NSString stringWithFormat:@"%@..",[operation.responseString substringToIndex:64]];
            }
            else{
                logContent = [NSString stringWithFormat:@"%d bytes data", [operation.responseData length]];
            }
            
            [log appendFormat:@"RSP:%@\n", logContent];
        }
        else{
            [log appendFormat:@"RSP:(ERROR) %@\n", [error description]];
        }
        
        NSLog(@"%@",log);
    }
}

@end
