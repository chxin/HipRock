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

/**
 *  Data access status list
 */
typedef enum _REMDataAccessStatus : NSUInteger{
    REMDataAccessSucceed = 0,
    REMDataAccessErrorMessage = 1,
    REMDataAccessNoConnection = 2,
    REMDataAccessFailed = 3,
    REMDataAccessCanceled = 4,
} REMDataAccessStatus;

/**
 *  Data store list
 *  WARNING: Every time you add a data store into this list,
 *           please add the conresponding configuration in 
 *           Resource/Configuration.plist's Services section
 */
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

/**
 *  Service response type, this is used to decide how response content will be parsed
 */
typedef enum _REMServiceResponseType
{
    REMServiceResponseJson  = 1,
    REMServiceResponseImage = 2,
} REMServiceResponseType;


typedef void(^REMDataAccessSuccessBlock)(id parsedObject, id rawData);
typedef void(^REMDataAccessFailureBlock)(NSError *error, REMDataAccessStatus status, id response);
//typedef void(^REMDataAccessProgressBlock)(NSUInteger bytes, long long read, long long expected);


#pragma mark - DataStore

@interface REMDataStore : NSObject

@property (nonatomic) REMDataStoreType name;
@property (nonatomic,strong, readonly) NSString *url;
@property (nonatomic,strong, readonly) id parameter;
@property (nonatomic, readonly) REMServiceResponseType responseType;
@property (nonatomic,strong) NSString *groupName;
@property (nonatomic,strong) NSDictionary *messageMap;
@property (nonatomic) BOOL isAccessCache;
@property (nonatomic) BOOL isDisableAlert;
@property (nonatomic,weak) REMDataStore *parentStore;
@property (nonatomic) BOOL persistManually;

@property (nonatomic,strong) REMRemoteServiceRequest *remoteServiceRequest;
@property (nonatomic,strong) REMDataPersistenceProcessor *persistenceProcessor;

#pragma mark - Class methods

/**
 *  Create a new instance of core-data managed object of type
 *
 *  @param objectType The type to be created
 *
 *  @return The managed object instance of the desired type
 */
+ (id)createManagedObject:(Class)objectType;

/**
 *  Delete a core-data managed object from current database context
 *
 *  @param object The managed object to be deleted
 */
+ (void)deleteManagedObject:(NSManagedObject *)object;

/**
 *  Save the current core-data database context
 */
+ (void)saveContext;

/**
 *  Fetch a collection of core-data managed object from current core-data database
 *
 *  @param objectType The desired object type
 *
 *  @return A collection of managed objects of the desired type
 */
+ (id)fetchManagedObject:(Class)objectType;

/**
 *  Fetch a collection of core-data managed object of desired type and satisfies provided condition from current core-data database
 *
 *  @param objectType The desired object type
 *  @param predicate  Filter condition
 *
 *  @return A collection of managed objects of the desired type and satisfies the filter condition
 */
+ (id)fetchManagedObject:(Class)objectType withPredicate:(NSPredicate *)predicate;


#pragma mark - Instance methods

/**
 *  Constructor
 *
 *  @param name        Data store type, one of REMDataStoreType item
 *  @param parameter   The parameter to post to server
 *  @param accessCache Is access cache when network is not reachable
 *  @param messageMap  A dict that contains l10n keys for get message to prompt if network got error
 *
 *  @return Data store instance
 */
- (instancetype)initWithName:(REMDataStoreType)name parameter:(id)parameter accessCache:(BOOL)accessCache andMessageMap:(NSDictionary *)messageMap;

/**
 *  Access the store, call success block on data access success
 *
 *  @param succcess The success block to be called on data access success
 */
- (void)access:(REMDataAccessSuccessBlock)success;

/**
 *  Access the store, call success block on data access success, call failure block on any failure
 *
 *  @param succcess The success block to be called on data access success
 *  @param failure  The failure block to be called on any failure
 */
- (void)access:(REMDataAccessSuccessBlock)succcess failure:(REMDataAccessFailureBlock)failure;

/**
 *  Cancel all data access requests in current queue
 */
+ (void) cancel;

/**
 *  Cancel data access requests with a specific group name
 *
 *  @param groupName The group name to be canceled
 */
+ (void) cancel: (NSString *) groupName;


@end
