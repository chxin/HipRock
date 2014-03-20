//
//  REMDataStore.m
//  Blues
//
//  Created by 张 锋 on 3/14/14.
//
//

#import "REMDataStore.h"
#import "REMApplicationContext.h"
#import "REMCommonHeaders.h"
#import "REMAppDelegate.h"


@interface REMCacheStoreHolder : NSObject

@property (atomic) BOOL gotoHolder;
@property (atomic, strong) NSMutableArray *holder;

@end

@implementation REMCacheStoreHolder @end



@interface REMDataStore()

@property (nonatomic,strong) REMDataAccessSuccessBlock success;
//数据模型对象
@property(nonatomic,strong) NSManagedObjectModel *managedObjectModel;
//上下文对象
@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;
//持久性存储区
@property(nonatomic,strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation REMDataStore

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

#pragma mark - Override property setter
- (void)setPersistenceProcessor:(REMDataPersistenceProcessor *)persistenceProcessor
{
    _persistenceProcessor = persistenceProcessor;
    _persistenceProcessor.dataStore = self;
}

- (void)setRemoteServiceRequest:(REMRemoteServiceRequest *)remoteServiceRequest
{
    _remoteServiceRequest = remoteServiceRequest;
    _remoteServiceRequest.dataStore = self;
}

-(NSManagedObjectModel *)managedObjectModel
{
    return [REMAppDelegate app].managedObjectModel;
    
}
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    return [REMAppDelegate app].persistentStoreCoordinator;
}

-(NSManagedObjectContext *)managedObjectContext
{
    return [REMAppDelegate app].managedObjectContext;
}

#pragma mark - Store
- (REMDataStore *)initWithName:(REMDataStoreType)name parameter:(id)parameter accessCache:(BOOL)accessCache andMessageMap:(NSDictionary *)messageMap{
    self = [super init];
    
    if(self){
        NSDictionary *serviceItem = [self serviceConfigurationOfType:name];
        
        self.name = name;
        _parameter = parameter;
        _url = serviceItem[@"Url"];
        _responseType = [serviceItem[@"Type"] unsignedIntegerValue];
        self.isAccessCache = accessCache;
        if(messageMap == nil){
            self.messageMap = REMNetworkMessageMap;
        }
        else{
            self.messageMap = messageMap;
        }
    }
    
    return self;
}

- (void)access:(REMDataAccessSuccessBlock)success{
    [self access:success failure:nil];
}
- (void)access:(REMDataAccessSuccessBlock)success failure:(REMDataAccessFailureBlock)failure{
    NetworkStatus reachability = [REMHttpHelper checkCurrentNetworkStatus];
    
    BOOL cacheMode = [REMApplicationContext instance].cacheMode;
    REMCacheStoreHolder *holder = [REMDataStore cacheStoreHolder];
    
    if(reachability == NotReachable){
        if(self.isAccessCache){
            
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
            
            failure(nil, REMDataAccessNoConnection, nil);
        }
        
        return;
    }
    
    [self accessRemote:success failure:failure];
}

+ (void) cancel{
    [REMHTTPRequestOperationManager cancel:nil];
}

+ (void) cancel: (NSString *) groupName{
    [REMHTTPRequestOperationManager cancel:groupName];
}

#pragma mark - Core Data
- (id)newManagedObject:(NSString *)objectType{
    return [NSEntityDescription insertNewObjectForEntityForName:objectType inManagedObjectContext:self.managedObjectContext];
}

- (id)fetchMangedObject:(NSString *)objectType{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:objectType];
    
    NSError *error = nil;
    //执行获取数据请求，返回数组
    NSMutableArray *mutableFetchResult = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    
    return mutableFetchResult;
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

- (void)deleteManageObject:(NSManagedObject *)object{
    [self.managedObjectContext deleteObject:object];
    [self persistManageObject];
}

- (void)persistManageObject{
    NSError *error = nil;
    [self.managedObjectContext save:&error];
}


#pragma mark - @private
/**
 *  Gets configuration information from Configuration.plist for desired data store type
 *
 *  @param type: Data store type
 *
 *  @return Configuration dictionary of the required data store type
 */
-(NSDictionary *)serviceConfigurationOfType:(REMDataStoreType)type
{
    __block NSString *serviceName = REMEmptyString;
    
    [REMAppConfig.services enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if([obj[@"ID"] unsignedIntegerValue] == (NSUInteger)type){
            serviceName = key;
            *stop = YES;
        }
    }];
    
    return REMStringNilOrEmpty(serviceName) ? nil : REMAppConfig.services[serviceName];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"store %@ index %d pressed", self.serviceMeta.url, buttonIndex);
    
    for(REMDataStore *store in cacheStoreHolder.holder){
        [store accessLocal:store.success];
    }
    
    cacheStoreHolder.gotoHolder = NO;
    [cacheStoreHolder.holder removeAllObjects];
    cacheStoreHolder = nil;
}

- (void)accessLocal:(REMDataAccessSuccessBlock)success
{
    if (self.persistenceProcessor!=nil) {
        id data = [self.persistenceProcessor fetch];
        success(data);
        return;
    }
}

-(void)accessRemote:(REMDataAccessSuccessBlock)success failure:(REMDataAccessFailureBlock)failure
{
    REMRemoteServiceRequest *request = [[REMRemoteServiceRequest alloc] init];
    self.remoteServiceRequest = request;
    
    
    [self.remoteServiceRequest request:^(id data) {
        if([REMApplicationContext instance].cacheMode == YES){
            [[REMApplicationContext instance] setCacheMode:NO];
        }
        id newData = data;
        if (self.persistenceProcessor!=nil && self.persistManually==NO) {
            newData = [self.persistenceProcessor persist:data];
        }
        
        success(newData);
    } failure:^(NSError *error, REMDataAccessStatus status, id response) {
        if(self.isDisableAlert == NO && (status == REMDataAccessNoConnection || status == REMDataAccessFailed || (status == REMDataAccessErrorMessage && [response isKindOfClass:[REMBusinessErrorInfo class]] && [((REMBusinessErrorInfo *)response).code isEqualToString:@"1"]))){
            NSString *message = self.messageMap[@(status)];
            [REMAlertHelper alert:message];
        }
        
        if(failure)
            failure(error,status,response);
    }];
}

@end
