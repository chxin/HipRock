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

typedef enum _REMDataStoreType : NSUInteger
{
    /*
     * AccessControl        101
     */
    REMDSUserValidate                   = 101001,
    REMDSDemoUserValidate               = 101002,
    REMDSUserCustomerValidate           = 101003,
    
    /**
     * User                 102
     */
    REMDSUserGetCurrent                 = 102001,
    
    /**
     * Customer             103
     */
    REMDSCustomerLogo                   = 103001,
    REMDSCustomerSwitch                 = 103002,
    
    /**
     *	Building            104
     */
    
    REMDSBuildingInfo                   = 104001,
    REMDSBuildingCommodityTotalUsage    = 104002,
    REMDSBuildingOverallData            = 104003,
    REMDSBuildingAverageData            = 104004,
    REMDSBuildingTimeRangeData          = 104005,
    REMDSBuildingPicture                = 104006,
    REMDSBuildingAirQualityTotalUsage   = 104007,
    REMDSBuildingAirQuality             = 104008,
    REMDSBuildingPinningToCover         = 104009,
    REMDSBuildingInfoUpdate             = 104010,
    
    /*
     * Dashboard stores     105
     */
    REMDSDashboardFavorite              = 105001,
    
    /*
     * Energy stores        106
     */
    REMDSEnergyTagsTrend                = 106001,
    REMDSEnergyTagsTrendUnit            = 106002,
    REMDSEnergyTagsDistribute           = 106003,
    REMDSEnergyMultiTimeTrend           = 106004,
    REMDSEnergyMultiTimeDistribute      = 106005,
    REMDSEnergyCarbon                   = 106006,
    REMDSEnergyCarbonUnit               = 106007,
    REMDSEnergyCarbonDistribute         = 106008,
    REMDSEnergyCost                     = 106009,
    REMDSEnergyCostUnit                 = 106010,
    REMDSEnergyCostDistribute           = 106011,
    REMDSEnergyCostElectricity          = 106012,
    REMDSEnergyRatio                    = 106013,
    REMDSEnergyRankingEnergy            = 106014,
    REMDSEnergyRankingCost              = 106015,
    REMDSEnergyRankingCarbon            = 106016,
    REMDSEnergyLabeling                 = 106017,
    /*
     * Other                107
     */
    REMDSLogSend                        = 107001,
    
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
