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


@implementation REMDataStore


static NSDictionary *serviceMap = nil;

- (REMDataStore *)initWithName:(REMDataStoreType)name parameter:(id)parameter
{
    REMDataStore *store = [self init]; 
    
    store.name = name;
    store.parameter = parameter;
    store.serviceMeta = [[REMDataStore serviceMap] objectForKey:[NSNumber numberWithInt:name]];
    
    return store;
}

+ (NSDictionary *) serviceMap
{
    if(serviceMap == nil)
    {
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
    NetworkStatus netStaus = [REMNetworkHelper checkCurrentNetworkStatus];
    
    //if network is not ok, get from cache
    if(netStaus == NotReachable){
        [self accessLocal:success error:error];
    }
    //if network is ok, get from network and always update cache data
    else{
        [self accessRemote:success error:error progress:progress];
    }
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
- (void)accessLocal:(REMDataAccessSuccessBlock)success error:(REMDataAccessErrorBlock)error
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
    [REMServiceAgent call:self.serviceMeta withBody:self.parameter mask:self.maskContainer group:self.groupName store:YES success:success error:error progress:progress];
}

@end
