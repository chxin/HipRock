//
//  REMRemoteService.m
//  Blues
//
//  Created by 张 锋 on 3/14/14.
//
//

#import "REMRemoteServiceRequest.h"
#import "AFNetworking.h"
#import "REMCommonDefinition.h"
#import "REMAppConfiguration.h"
#import "REMApplicationContext.h"
#import "REMEncryptHelper.h"
#import "REMApplicationInfo.h"
#import "REMHTTPRequestOperationManager.h"
#import "REMBusinessErrorInfo.h"
#import "REMError.h"

@interface REMRemoteServiceRequest()

@property (nonatomic,weak) REMHTTPRequestOperation *operation;

@end

@implementation REMRemoteServiceRequest


/**
 *  <#Description#>
 *
 *  @param success <#success description#>
 *  @param error   <#error description#>
 */
- (void) request:(REMDataAccessSuccessBlock)success failure:(REMDataAccessErrorBlock)failure
{
    REMHTTPRequestOperationManager *manager = [REMHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = self.dataStore.responseType == REMServiceResponseJson ? [AFJSONResponseSerializer serializer] : nil;
    
    NSURLRequest *request = [manager.requestSerializer requestBySerializingRequest:[self buildRequest] withParameters:self.dataStore.parameter error:nil] ;
    
    REMHTTPRequestOperation *operation = [manager RequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //if there is error message, enter ERROR status
        if([operation.responseString hasPrefix:@"{\"error\":"] == YES) {
            //TODO: process error message with different error types
            REMBusinessErrorInfo *businessError = [[REMBusinessErrorInfo alloc] initWithJSONString:operation.responseString];
            REMError *error = [[REMError alloc] initWithErrorInfo:businessError];
            
            failure(error, REMDataAccessErrorMessage, businessError);
        }
        else{ //if ok, enter SUCCESS status
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        REMDataAccessErrorStatus status = [self decideErrorStatus:error];
        
        failure(error, status, operation.responseString);
    }];
    
    operation.group = self.dataStore.groupName;
    
    [manager.operationQueue addOperation:operation];
    self.operation = operation;
}

/**
 *  <#Description#>
 */
- (void) cancel
{
    [self.operation cancel];
}


#pragma mark - @privates
-(NSMutableURLRequest *)buildRequest
{
    NSURL *url = [[NSURL alloc] initWithString:self.dataStore.url relativeToURL:REMAppConfig.currentDataSource[@"url"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setTimeoutInterval:REMAppConfig.requestTimeout];
    [request setCachePolicy:NSURLCacheStorageAllowedInMemoryOnly];
    [request setHTTPMethod: @"POST"];
    
    [request setAllHTTPHeaderFields:[self getHeaders]];
    
    return request;
}


- (NSDictionary *)getHeaders
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

-(REMDataAccessErrorStatus)decideErrorStatus:(NSError *)error
{
    REMDataAccessErrorStatus status = REMDataAccessFailed;
    
    if(error.code == -999){
        status = REMDataAccessCanceled;
        REMLogInfo(@"Request canceled");
    }
    else{
        status = REMDataAccessFailed;
        REMLogInfo(@"Network failure with code: %d", error.code);
    }
    
    return status;
}

@end
