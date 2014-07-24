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
#import "REMDataPersistenceProcessor.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "REMManagedUserModel.h"
#import "REMManagedCustomerModel.h"
#import "REMManagedAdministratorModel.h"


@interface REMCacheStoreHolder : NSObject

@property (atomic) BOOL gotoHolder;
@property (atomic, strong) NSMutableArray *holder;

@end

@implementation REMCacheStoreHolder @end



@interface REMDataStore()

@property (nonatomic,strong) REMDataAccessSuccessBlock success;

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
    NetworkStatus reachability = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];

    BOOL cacheMode = REMAppContext.cacheMode;
    REMCacheStoreHolder *holder = [REMDataStore cacheStoreHolder];
    
    if(reachability == NotReachable){
        if(self.isAccessCache){
            
            if(!cacheMode){
                self.success = success;
                [holder.holder addObject:self];
                
                [REMAlertHelper alert:REMIPadLocalizedString(@"Common_NetNoConnectionLoadLocal") delegate:self];
                [REMAppContext setCacheMode:YES];
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
            if(failure){
                failure(nil, REMDataAccessNoConnection, nil);
            }
        }
        
        return;
    }
    else{
        [self accessRemote:success failure:failure];
    }
}

+ (void) cancel{
    [REMHTTPRequestOperationManager cancel:nil];
}

+ (void) cancel: (NSString *) groupName{
    [REMHTTPRequestOperationManager cancel:groupName];
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
    else{
        success(nil);
    }
}

-(void)accessRemote:(REMDataAccessSuccessBlock)success failure:(REMDataAccessFailureBlock)failure
{
    REMRemoteServiceRequest *request = [[REMRemoteServiceRequest alloc] init];
    self.remoteServiceRequest = request;
    
    
    [self.remoteServiceRequest request:^(id data) {
        if(REMAppContext.cacheMode == YES){
            [REMAppContext setCacheMode:NO];
        }
        id newData = data;
        if (self.persistenceProcessor!=nil && self.persistManually==NO) {
            newData = [self.persistenceProcessor persist:data];
        }
        
        if(success)
            success(newData);
    } failure:^(NSError *error, REMDataAccessStatus status, id response) {
        if(status == REMDataAccessUnsupported){
            [REMAppContext applicationDidBecomeUnsupported];
        }
        
        if(self.isDisableAlert == NO && (status == REMDataAccessNoConnection || status == REMDataAccessFailed || (status == REMDataAccessErrorMessage && [response isKindOfClass:[REMBusinessErrorInfo class]] && [((REMBusinessErrorInfo *)response).code isEqualToString:@"1"]))){
            NSString *message = self.messageMap[@(status)];
            [REMAlertHelper alert:message];
        }
        
        if(failure)
            failure(error,status,response);
    }];
}

#pragma mark - core-data access

+ (id)createManagedObject:(Class)objectType
{
    return [[REMDataPersistenceProcessor new] create:objectType];
}

+ (void)deleteManagedObject:(NSManagedObject *)object
{
    [[REMDataPersistenceProcessor new] remove:object];
}

+ (void)saveContext
{
    [[REMDataPersistenceProcessor new] save];
}

+ (id)fetchManagedObject:(Class)objectType
{
    return [[REMDataPersistenceProcessor new] fetch:objectType];
}

+ (id)fetchManagedObject:(Class)objectType withPredicate:(NSPredicate *)predicate
{
    return [[REMDataPersistenceProcessor new] fetch:objectType withPredicate:predicate];
}

+ (void)cleanData
{
//    NSPersistentStore *store = [REMAppContext.persistentStoreCoordinator.persistentStores lastObject];
//    NSError *error = nil;
//    NSURL *storeURL = store.URL;
//    [REMAppContext.persistentStoreCoordinator removePersistentStore:store error:&error];
//    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
//    
//    
//    NSLog(@"Data Reset");
//    
//    //Make new persistent store for future saves   (Taken From Above Answer)
//    if (![REMAppContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//        // do something with the error
//    }

    
    
    NSArray *entities = REMAppContext.managedObjectModel.entities;
    for (NSEntityDescription *entityDescription in entities) {
        if([entityDescription.name isEqualToString:NSStringFromClass([REMManagedUserModel class])] ||
           [entityDescription.name isEqualToString:NSStringFromClass([REMManagedCustomerModel class])] ||
           [entityDescription.name isEqualToString:NSStringFromClass([REMManagedAdministratorModel class])]){
            continue;
        }
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityDescription.name];
        fetchRequest.includesPropertyValues = NO;
        fetchRequest.includesSubentities = NO;
        
        NSError *error;
        NSArray *items = [REMAppContext.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        for (NSManagedObject *managedObject in items) {
            [REMAppContext.managedObjectContext deleteObject:managedObject];
        }
    }
}

@end
