/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMApplicationContext.h
 * Created      : 张 锋 on 7/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMAppConfiguration.h"
#import "REMUpdateAllManager.h"
#import "REMManagedUserModel.h"
#import "REMManagedCustomerModel.h"
#import "REMHTTPRequestOperationManager.h"
@class REMUpdateAllManager;

#define REMAppContext [REMApplicationContext instance]
#define REMAppConfig REMAppContext.appConfig

@interface REMApplicationContext : NSObject{
    @private
    REMManagedCustomerModel *_currentCustomer;
}

@property (nonatomic,strong) REMManagedUserModel *currentUser;
@property (nonatomic,strong) REMManagedCustomerModel *currentCustomer;

@property (nonatomic,strong) REMAppConfiguration *appConfig;

@property (nonatomic,strong) NSArray *buildingInfoArray;

@property (nonatomic) BOOL cacheMode;
@property (nonatomic) AFNetworkReachabilityStatus networkStatus;


@property (nonatomic,strong) REMUpdateAllManager *sharedUpdateManager;
@property (nonatomic,strong) REMHTTPRequestOperationManager *sharedRequestOperationManager;

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic,strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+ (REMApplicationContext *)instance;
+ (void)recover;
+ (void)destroy;


@end
