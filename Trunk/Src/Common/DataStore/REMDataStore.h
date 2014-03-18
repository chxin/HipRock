//
//  REMDataStore.h
//  Blues
//
//  Created by 张 锋 on 3/14/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class REMDataPersistenceProcessor;
@class REMRemoteServiceRequest;

typedef enum _REMDataAccessStatus : NSUInteger{
    REMDataAccessSucceed = 0,
    REMDataAccessErrorMessage = 1,
    REMDataAccessNoConnection = 2,
    REMDataAccessFailed = 3,
    REMDataAccessCanceled = 4,
} REMDataAccessStatus;

typedef enum _REMDataStoreType
{
    /*
     * AccessControl        01
     */
    REMDSUserValidate                   = 01001,
    REMDSDemoUserValidate               = 01002,
    REMDSUserCustomerValidate           = 01003,
    
    /**
     * User                 02
     */
    REMDSUserGetCurrent                 = 02001,
    
    /**
     * Customer             03
     */
    REMDSCustomerLogo                   = 03001,
    REMDSCustomerSwitch                 = 03002,
    
    /**
     *	Building            04
     */
    
    REMDSBuildingInfo                   = 04001,
    REMDSBuildingCommodityTotalUsage    = 04002,
    REMDSBuildingOverallData            = 04003,
    REMDSBuildingAverageData            = 04004,
    REMDSBuildingTimeRangeData          = 04005,
    REMDSBuildingPicture                = 04006,
    REMDSBuildingAirQualityTotalUsage   = 04007,
    REMDSBuildingAirQuality             = 4008,
    REMDSBuildingPinningToCover         = 4009,
    REMDSBuildingInfoUpdate             = 04010,
    
    /*
     * Dashboard stores     05
     */
    REMDSDashboardFavorite              = 05001,
    
    /*
     * Energy stores        06
     */
    REMDSEnergyTagsTrend                = 06001,
    REMDSEnergyTagsTrendUnit            = 06002,
    REMDSEnergyTagsDistribute           = 06003,
    REMDSEnergyMultiTimeTrend           = 06004,
    REMDSEnergyMultiTimeDistribute      = 06005,
    REMDSEnergyCarbon                   = 06006,
    REMDSEnergyCarbonUnit               = 06007,
    REMDSEnergyCarbonDistribute         = 6008,
    REMDSEnergyCost                     = 6009,
    REMDSEnergyCostUnit                 = 06010,
    REMDSEnergyCostDistribute           = 06011,
    REMDSEnergyCostElectricity          = 06012,
    REMDSEnergyRatio                    = 06013,
    REMDSEnergyRankingEnergy            = 06014,
    REMDSEnergyRankingCost              = 06015,
    REMDSEnergyRankingCarbon            = 06016,
    REMDSEnergyLabeling                 = 06017,
    /*
     * Other                07
     */
    REMDSLogSend                        = 07001,
    
} REMDataStoreType;


typedef enum _REMServiceResponseType
{
    REMServiceResponseJson  = 1,
    REMServiceResponseImage = 2,
} REMServiceResponseType;


typedef void(^REMDataAccessSuccessBlock)(id data);
typedef void(^REMDataAccessFailureBlock)(NSError *error, REMDataAccessStatus status, id response);
typedef void(^REMDataAccessProgressBlock)(NSUInteger bytes, long long read, long long expected);


#pragma mark -


@interface REMDataStore : NSObject

@property (nonatomic) REMDataStoreType name;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) id parameter;
@property (nonatomic) REMServiceResponseType responseType;
@property (nonatomic,strong) NSString *groupName;
@property (nonatomic,strong) NSDictionary *messageMap;
@property (nonatomic) BOOL isAccessCache;
@property (nonatomic) BOOL isDisableAlert;
@property (nonatomic,weak) REMDataStore *parentStore;
@property (nonatomic) BOOL persistManually;

@property (nonatomic,strong) REMRemoteServiceRequest *remoteServiceRequest;
@property (nonatomic,strong) REMDataPersistenceProcessor *persistenceProcessor;



- (REMDataStore *)initWithName:(REMDataStoreType)name parameter:(id)parameter accessCache:(BOOL)accessCache andMessageMap:(NSDictionary *)messageMap;

- (void)access:(REMDataAccessSuccessBlock)succcess;
- (void)access:(REMDataAccessSuccessBlock)succcess failure:(REMDataAccessFailureBlock)error;

+ (void) cancel;
+ (void) cancel: (NSString *) groupName;


- (id)newManagedObject:(NSString *)objectType;
- (id)fetchMangedObject:(NSString *)objectType;
- (id)fetchMangedObject:(NSString *)objectType withPredicate:(NSPredicate *)predicate;
- (void)deleteManageObject:(NSManagedObject *)object;
- (void)persistManageObject;

@end
