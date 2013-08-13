//
//  REMDataAccessor.m
//  Blues
//
//  Created by zhangfeng on 6/28/13.
//
//

#import <Foundation/NSJSONSerialization.h>
#import "REMDataAccessor.h"
#import "REMServiceAgent.h"
#import "REMNetworkHelper.h"
#import "REMApplicationInfo.h"
#import "REMStorage.h"


@implementation REMDataAccessor

+ (void) access: (REMDataStore *) store success:(void (^)(id data))success
{
    [REMDataAccessor access:store success:success error:nil progress:nil];
}

+ (void) access: (REMDataStore *) store success:(void (^)(id data))success error:(void (^)(NSError *error, id response))error
{
    [REMDataAccessor access:store success:success error:error progress:nil];
}

+ (void) access: (REMDataStore *) store success:(void (^)(id data))success error:(void (^)(NSError *error, id response))error progress:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progress
{
    //if access local or there is no network, get from local
    if(store.isAccessLocal || [REMNetworkHelper checkIsNoConnect])
    {
        [REMDataAccessor accessLocal:store success:success error:error];
    }
    else
    {
        [REMDataAccessor accessRemote:store success:success error:error progress:progress];
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

+ (void)accessLocal:(REMDataStore *)store success:(void (^)(id data))success error:(void (^)(NSError *error, id response))error
{
    NSString *data = [REMStorage get:store.serviceMeta.url key:[REMServiceAgent buildParameterString:store.parameter]];;
    
    BOOL isAccessRomoteIfLocalNoData = store.isAccessLocal;
    BOOL isLocalNoData = !(data != NULL && data!=nil && ![((NSString *)data) isEqualToString:@""]);
    
    //if there is no data local and get from remote if there is no local data, get from remote
    if(isLocalNoData && isAccessRomoteIfLocalNoData)
    {
        [REMDataAccessor accessRemote:store success:success error:error progress:nil];
    }
    else //just call data
    {
        NSDictionary *result = [REMServiceAgent deserializeResult:data ofService:store.serviceMeta.url];

        success(result);
    }
}

+(void)accessRemote:(REMDataStore *)store success:(void (^)(id data))success error:(void (^)(NSError *error, id response))error progress:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progress
{
    [REMServiceAgent call:store.serviceMeta withBody: store.parameter mask:store.maskContainer group:store.groupName store:store.isStoreLocal success:success error:error progress:progress];
}

@end
