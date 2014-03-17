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
#import "REMAppDelegate.h"


@class REMDataPersistenceProcessor;

@interface REMCacheStoreHolder : NSObject
@property (atomic) BOOL gotoHolder;
@property (atomic, strong) NSMutableArray *holder;
@end

@implementation REMCacheStoreHolder @end



@interface REMDataStore()

@property (nonatomic,strong) REMDataAccessSuccessBlock success;

@end


@implementation REMDataStore


static NSDictionary *serviceMap = nil;
+ (NSDictionary *) serviceMap
{
    if(serviceMap == nil){
        serviceMap = REMMobileServices;
    }
    
    return serviceMap;
}
static REMCacheStoreHolder *cacheStoreHolder;
+ (REMCacheStoreHolder *) cacheStoreHolder
{
    if(cacheStoreHolder == nil){
        @synchronized(self){
            cacheStoreHolder = [[REMCacheStoreHolder alloc] init];
            cacheStoreHolder.gotoHolder = NO;
            cacheStoreHolder.holder = [[NSMutableArray alloc] init];
        }
    }
    
    return cacheStoreHolder;
}

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
    REMCacheStoreHolder *holder = [REMDataStore cacheStoreHolder];
    
    if(reachability == NotReachable){
        if(self.accessCache){
            
            if(!cacheMode){
                self.success = success;
                [holder.holder addObject:self];
                
                [REMAlertHelper alert:REMIPadLocalizedString(@"Common_NetNoConnectionLoadLocal") delegate:self];
                [[REMApplicationContext instance] setCacheMode:YES];
                holder.gotoHolder = YES;
            }
            else{
                //if there is parent store, access local directly
                if(self.parentStore==nil && holder.gotoHolder){
                    self.success = success;
                    [holder.holder addObject:self];
                }
                else{
                    [self accessLocal:success];
                }
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
    if (self.persistenceProcessor!=nil) {
       id data = [self.persistenceProcessor fetchData];
        success(data);
        return;
    }
    
    
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
        id newData = data;
        if (self.persistenceProcessor!=nil && self.persistManually==NO) {
            newData = [self.persistenceProcessor persistData:data];
        }
        
        success(newData);
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
    
    for(REMDataStore *store in cacheStoreHolder.holder){
        [store accessLocal:store.success];
    }
    
    cacheStoreHolder.gotoHolder = NO;
    [cacheStoreHolder.holder removeAllObjects];
    cacheStoreHolder = nil;
}

#pragma mark - coredata

- (id)newManagedObject:(NSString *)objectType{
    return [NSEntityDescription insertNewObjectForEntityForName:objectType inManagedObjectContext:self.managedObjectContext];
}

- (void)deleteManageObject:(NSManagedObject *)object
{
    [self.managedObjectContext deleteObject:object];
    [self persistManageObject];
}

- (void)persistManageObject{
    NSError *error = nil;
    [self.managedObjectContext save:&error];
}

- (id)fetchMangedObject:(NSString *)objectType withPredicate:(NSPredicate *)predicate{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:objectType];
    [request setPredicate:predicate];
    NSError *error = nil;
    //执行获取数据请求，返回数组
    NSMutableArray *mutableFetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    
    return mutableFetchResult;
}

-(id)fetchMangedObject:(NSString *)objectType{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:objectType];
    
    NSError *error = nil;
    //执行获取数据请求，返回数组
    NSMutableArray *mutableFetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    
    return mutableFetchResult;
}

- (void)setPersistenceProcessor:(REMDataPersistenceProcessor *)persistenceProcessor
{
    _persistenceProcessor = persistenceProcessor;
    _persistenceProcessor.dataStore = self;
}

-(NSManagedObjectModel *)managedObjectModel
{
    REMAppDelegate *app = [REMAppDelegate app];
    
    return app.managedObjectModel;

}
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    REMAppDelegate *app = [REMAppDelegate app];
    
    return app.persistentStoreCoordinator;
}

-(NSManagedObjectContext *)managedObjectContext
{
    REMAppDelegate *app = [REMAppDelegate app];
    
    return app.managedObjectContext;
    
}



@end


