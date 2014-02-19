/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMDataAccessOption.h
 * Created      : zhangfeng on 7/12/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMDataStoreType.h"
#import <CoreData/CoreData.h>
#import "REMDataPersistenceProcessor.h"
@class REMDataPersistenceProcessor;
@interface REMDataStore : NSObject<UIAlertViewDelegate>

@property (nonatomic) REMDataStoreType name;
@property (nonatomic,strong) REMServiceMeta* serviceMeta;
@property (nonatomic,strong) id parameter;
@property (nonatomic,strong) UIView* maskContainer;
@property (nonatomic,strong) NSString *groupName;
@property (nonatomic,strong) NSDictionary *messageMap;
@property (nonatomic) BOOL accessCache;
@property (nonatomic) BOOL disableAlert;
@property (nonatomic,weak) REMDataStore *parentStore;
@property (nonatomic,strong) REMDataPersistenceProcessor *persistenceProcessor;

//数据模型对象
@property(nonatomic,strong) NSManagedObjectModel *managedObjectModel;
//上下文对象
@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;
//持久性存储区
@property(nonatomic,strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;



- (REMDataStore *)initWithName:(REMDataStoreType)name parameter:(id)parameter accessCache:(BOOL)accessCache andMessageMap:(NSDictionary *)messageMap;

- (void)access:(REMDataAccessSuccessBlock)succcess;
- (void)access:(REMDataAccessSuccessBlock)succcess error:(REMDataAccessErrorBlock)error;
- (void)access:(REMDataAccessSuccessBlock)succcess error:(REMDataAccessErrorBlock)error progress:(REMDataAccessProgressBlock)progress;

+ (void) cancelAccess;
+ (void) cancelAccess: (NSString *) groupName;

@end

