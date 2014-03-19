/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMApplicationContext.h
 * Created      : 张 锋 on 7/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMUserModel.h"
#import "REMCustomerModel.h"
#import "REMAppConfiguration.h"
#import "REMUpdateAllManager.h"
#import "REMManagedUserModel.h"
#import "REMManagedCustomerModel.h"
#import "REMHTTPRequestOperationManager.h"
@class REMUpdateAllManager;

#define REMAppContext [REMApplicationContext instance]
//#define REMAppCurrentUser REMAppContext.currentUser
//#define REMAppCurrentCustomer REMAppContext.currentCustomer
#define REMAppCurrentManagedUser REMAppContext.currentManagedUser
#define REMAppCurrentManagedCustomer REMAppContext.currentManagedCustomer
#define REMAppCurrentLogo REMAppContext.currentCustomerLogo
#define REMAppConfig REMAppContext.appConfig

@interface REMApplicationContext : NSObject

//@property (nonatomic,strong) REMUserModel *currentUser;
//@property (nonatomic,strong) REMCustomerModel *currentCustomer;

@property (nonatomic,strong) REMManagedUserModel *currentManagedUser;
@property (nonatomic,strong) REMManagedCustomerModel *currentManagedCustomer;

@property (nonatomic,strong) UIImage *currentCustomerLogo;

@property (nonatomic,strong) REMAppConfiguration *appConfig;

@property (nonatomic,strong) NSArray *buildingInfoArray;

@property (nonatomic,strong) REMUpdateAllManager *updateManager;

@property (nonatomic,strong) NSString *buildingInfoArrayStorageKey;
@property (nonatomic,getter = getCacheMode, setter = setCacheMode:) BOOL cacheMode;

@property (nonatomic,strong) REMHTTPRequestOperationManager *sharedRequestOperationManager;

+ (void)updateBuildingInfoArrayToStorage;

+ (REMApplicationContext *)instance;
+ (void)recover;
+ (void)destroy;
+ (void)cleanImage;
-(BOOL)getCacheMode;
-(void)setCacheMode:(BOOL)value;


@end