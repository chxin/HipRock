/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMDataAccessOption.m
 * Created      : zhangfeng on 7/12/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMDataStore.h"
#import "REMDataStoreType.h"
#import "REMServiceAgent.h"
#import "REMNetworkHelper.h"
#import "REMApplicationInfo.h"
#import "REMStorage.h"
#import "REMJSONHelper.h"
#import "REMAlertHelper.h"
#import "REMApplicationContext.h"
#import "REMBusinessErrorInfo.h"

@interface REMDataStore()

@property (nonatomic,strong) REMDataAccessSuccessBlock success;

@end


@implementation REMDataStore


static NSDictionary *serviceMap = nil;
static NSMutableArray *tempHolder = nil;

- (REMDataStore *)initWithName:(REMDataStoreType)name parameter:(id)parameter accessCache:(BOOL)accessCache andMessageMap:(NSDictionary *)messageMap
{
    self = [super init];
    
    if(self){
        self.name = name;
        self.parameter = parameter;
        self.serviceMeta = [[REMDataStore serviceMap] objectForKey:[NSNumber numberWithInt:name]];
        self.accessCache = accessCache;
        if(messageMap == nil)
            self.messageMap = REMNetworkMessageMap;
        else
            self.messageMap = messageMap;
    }
    
    
    return self;
}

+ (NSDictionary *) serviceMap
{
    if(serviceMap == nil){
        serviceMap = REMMobileServices;
    }
    
    return serviceMap;
}

- (void)access:(REMDataAccessSuccessBlock)succcess
{
    [self access:succcess error:nil progress:nil];
}
- (void)access:(REMDataAccessSuccessBlock)succcess error:(REMDataAccessErrorBlock)error
{
    [self access:succcess error:error progress:nil];
}
- (void)access:(REMDataAccessSuccessBlock)success error:(REMDataAccessErrorBlock)error progress:(REMDataAccessProgressBlock)progress
{
    NetworkStatus reachability = [REMNetworkHelper checkCurrentNetworkStatus];
    
    BOOL cacheMode = [REMApplicationContext instance].cacheMode;
    
    if(reachability == NotReachable){
        if(self.accessCache){
            
            if(!cacheMode){
                self.success = success;
                if(tempHolder == nil)
                    tempHolder = [[NSMutableArray alloc] init];
                [tempHolder addObject:self];
                
                [REMAlertHelper alert:REMLocalizedString(@"Common_NetNoConnectionLoadLocal") delegate:self];
                [[REMApplicationContext instance] setCacheMode:YES];
            }
            else{
                [self accessLocal:success];
            }
        }
        else{
            [REMAlertHelper alert:self.messageMap[@(REMDataAccessNoConnection)]];
            
            error(nil, REMDataAccessNoConnection, nil);
        }
        
        return;
    }
    
    [self accessRemote:success error:error progress:progress];
}


+ (void) cancelAccess
{
    [REMServiceAgent cancel];
}

+ (void) cancelAccess: (NSString *) groupName
{
    [REMServiceAgent cancel:groupName];
}


#pragma mark - private
- (void)accessLocal:(REMDataAccessSuccessBlock)success
{
    id cachedResult = nil;
    NSString *cacheKey = [REMServiceAgent buildParameterString:self.parameter];
    
    if(self.serviceMeta.responseType == REMServiceResponseJson)
    {
        cachedResult = [REMStorage get:self.serviceMeta.url key:cacheKey];
    }
    else if(self.serviceMeta.responseType == REMServiceResponseImage)
    {
        cachedResult = [REMStorage getFile:self.serviceMeta.url key:cacheKey];
    }
    
    if(self.serviceMeta.responseType == REMServiceResponseJson)
    {
        success([REMJSONHelper objectByString:cachedResult]);
    }
    else if(self.serviceMeta.responseType == REMServiceResponseImage)
    {
        success(cachedResult);
    }
}

-(void)accessRemote:(REMDataAccessSuccessBlock)success error:(REMDataAccessErrorBlock)error progress:(REMDataAccessProgressBlock)progress
{
    [REMServiceAgent call:self.serviceMeta withBody:self.parameter mask:self.maskContainer group:self.groupName success:^(id data) {
        //update cache mode to NO if cache mode is cache
        if([REMApplicationContext instance].cacheMode == YES){
            [[REMApplicationContext instance] setCacheMode:NO];
        }
        
        success(data);
    } error:^(NSError *errorInfo, REMDataAccessErrorStatus status, id response) {
        if(self.disableAlert == NO && (status == REMDataAccessNoConnection || status == REMDataAccessFailed || (status == REMDataAccessErrorMessage && [response isKindOfClass:[REMBusinessErrorInfo class]] && [((REMBusinessErrorInfo *)response).code isEqualToString:@"1"]))){
            NSString *message = self.messageMap[@(status)];
            [REMAlertHelper alert:message];
        }
        
        if(error)
            error(errorInfo,status,response);
    } progress:progress];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"store %@ index %d pressed", self.serviceMeta.url, buttonIndex);
    [self accessLocal:self.success];
    [tempHolder removeObject:self];
//    
//    for(REMDataStore *store in tempHolder){
//    }
//    
//    for(REMDataStore *store in tempHolder)
//        [tempHolder removeObject:store];
}


@end
