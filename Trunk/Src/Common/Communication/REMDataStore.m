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
                
                [REMAlertHelper alert:REMLocalizedString(@"Common_NetNoConnectionLoadLocal") delegate:self];
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
        if (self.persistenceProcessor!=nil) {
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

- (void)setPersistenceProcessor:(REMDataPersistenceProcessor *)persistenceProcessor
{
    _persistenceProcessor = persistenceProcessor;
    _persistenceProcessor.dataStore = self;
}

-(NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BluesPad" ofType:@"momd"];
    NSURL *momURL = [NSURL fileURLWithPath:path];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
    
    return _managedObjectModel;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    //得到数据库的路径
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //CoreData是建立在SQLite之上的，数据库名称需与Xcdatamodel文件同名
    NSURL *storeUrl = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"BluesPad.sqlite"]];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    
    return _persistentStoreCoordinator;
}

-(NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator =[self persistentStoreCoordinator];
    
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc]init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}



@end


