/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMDataAccessOption.h
 * Created      : zhangfeng on 25/12/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#ifndef Blues_REMDataStoreType_h
#define Blues_REMDataStoreType_h

#import "REMServiceMeta.h"

typedef enum _REMDataAccessErrorStatus : NSUInteger{
    REMDataAccessSucceed = 0,
    REMDataAccessErrorMessage = 1,
    REMDataAccessNoConnection = 2,
    REMDataAccessFailed = 3,
    REMDataAccessCanceled = 4,
} REMDataAccessErrorStatus;

typedef void(^REMDataAccessSuccessBlock)(id data);
typedef void(^REMDataAccessfailureBlock)(NSError *error, REMDataAccessErrorStatus status, id response);
typedef void(^REMDataAccessProgressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);


typedef enum _REMDataStoreType
{
    /*
     * AccessControl
     */
    REMDSUserValidate,
    REMDSDemoUserValidate,
    REMDSUserCustomerValidate,
    
    /**
     * User
     */
    REMDSUserGetCurrent,
    
    /**
     * Customer
     */
    REMDSCustomerLogo,
    REMDSCustomerSwitch,
    
    /**
     *	Building
     */
    
    REMDSBuildingInfo,
    REMDSBuildingCommodityTotalUsage,
    REMDSBuildingOverallData,
    REMDSBuildingAverageData,
    REMDSBuildingTimeRangeData,
    REMDSBuildingPicture,
    REMDSBuildingAirQualityTotalUsage,
    REMDSBuildingAirQuality,
    REMDSBuildingPinningToCover,
    REMDSBuildingInfoUpdate,
    
    /*
     * Dashboard stores
     */
    REMDSDashboardFavorite,
    
    /*
     * Energy stores
     */
    REMDSEnergyTagsTrend,
    REMDSEnergyTagsTrendUnit,
    REMDSEnergyTagsDistribute,
    REMDSEnergyMultiTimeTrend,
    REMDSEnergyMultiTimeDistribute,
    REMDSEnergyCarbon,
    REMDSEnergyCarbonUnit,
    REMDSEnergyCarbonDistribute,
    REMDSEnergyCost,
    REMDSEnergyCostUnit,
    REMDSEnergyCostDistribute,
    REMDSEnergyCostElectricity,
    REMDSEnergyRatio,
    REMDSEnergyRankingEnergy,
    REMDSEnergyRankingCost,
    REMDSEnergyRankingCarbon,
    REMDSEnergyLabeling,
    /*
     * Other
     */
    REMDSLogSend,
    
} REMDataStoreType;



#define REMJsonSvc(a) [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:(a)]
#define REMDataSvc(a) [[REMServiceMeta alloc] initWithDataResultRelativeUrl:(a)]
#define REMMobileServices  @{\
\
    /** AccessControl */\
    @(REMDSUserValidate) : REMJsonSvc(@"API/AccessControl.svc/ValidateUser"),\
    @(REMDSDemoUserValidate) : REMJsonSvc(@"API/AccessControl.svc/ValidateDemoUser"),\
    @(REMDSUserCustomerValidate) : REMJsonSvc(@"API/AccessControl.svc/ValidateUserCustomer"),\
\
    /** Energy */\
    @(REMDSEnergyTagsTrend) : REMJsonSvc(@"API/Energy.svc/GetTagsData"),\
    @(REMDSEnergyTagsTrendUnit) : REMJsonSvc(@"API/Energy.svc/GetEnergyUsageUnitData"),\
    @(REMDSEnergyTagsDistribute) : REMJsonSvc(@"API/Energy.svc/AggregateTagsData"),\
    @(REMDSEnergyMultiTimeTrend) : REMJsonSvc(@"API/Energy.svc/GetTagsData"),\
    @(REMDSEnergyMultiTimeDistribute) : REMJsonSvc(@"API/Energy.svc/AggregateTimeSpansData"),\
    @(REMDSEnergyCarbon) : REMJsonSvc(@"API/Energy.svc/GetCarbonUsageData"),\
    @(REMDSEnergyCarbonUnit) : REMJsonSvc(@"API/Energy.svc/GetCarbonUsageUnitData"),\
    @(REMDSEnergyCarbonDistribute) : REMJsonSvc(@"API/Energy.svc/AggregateCarbonUsageData"),\
    @(REMDSEnergyCost) : REMJsonSvc(@"API/Energy.svc/GetCostData"),\
    @(REMDSEnergyCostUnit) : REMJsonSvc(@"API/Energy.svc/GetCostUnitData"),\
    @(REMDSEnergyCostDistribute) : REMJsonSvc(@"API/Energy.svc/AggregateCostData"),\
    @(REMDSEnergyCostElectricity) : REMJsonSvc(@"API/Energy.svc/GetElectricityCostData"),\
    @(REMDSEnergyRatio) : REMJsonSvc(@"API/Energy.svc/RatioGetTagsData"),\
    @(REMDSEnergyRankingEnergy) : REMJsonSvc(@"API/Energy.svc/RankingEnergyUsageData"),\
    @(REMDSEnergyRankingCost) : REMJsonSvc(@"API/Energy.svc/RankingCostData"),\
    @(REMDSEnergyRankingCarbon) : REMJsonSvc(@"API/Energy.svc/RankingCarbonData"),\
    @(REMDSEnergyLabeling) : REMJsonSvc(@"API/Energy.svc/LabellingGetTagsData"),\
\
    /** User */\
    @(REMDSUserGetCurrent) : REMJsonSvc(@"API/User.svc/GetCurrentUser"),\
\
    /** Customer */\
    @(REMDSCustomerLogo) : REMDataSvc(@"API/Hierarchy.svc/GetCustomerLogo"),\
    @(REMDSCustomerSwitch) : REMJsonSvc(@"API/Customer.svc/SwitchCustomer"),\
\
    /** Building */\
    @(REMDSBuildingOverallData) : REMJsonSvc(@"API/Building.svc/GetBuildingOverallData"),\
    @(REMDSBuildingCommodityTotalUsage) : REMJsonSvc(@"API/Building.svc/GetBuildingCommodityUsage"),\
    @(REMDSBuildingInfo) : REMJsonSvc(@"API/Building.svc/GetBuildingInfo"),\
    @(REMDSBuildingAverageData) : REMJsonSvc(@"API/Building.svc/GetBuildingAverageUsageData"),\
    @(REMDSBuildingTimeRangeData) : REMJsonSvc(@"API/Building.svc/GetBuildingTimeRangeData"),\
    @(REMDSBuildingAirQuality) : REMJsonSvc(@"API/Building.svc/GetBuildingAirQualityData"),\
    @(REMDSBuildingAirQualityTotalUsage) : REMJsonSvc(@"API/Building.svc/GetBuildingAirQualityUsage"),\
    @(REMDSBuildingPicture) : REMDataSvc(@"API/Building.svc/GetBuildingPicture"),\
    @(REMDSBuildingInfoUpdate) : REMJsonSvc(@"API/Building.svc/GetBuildingInfoUpdate"),\
\
    @(REMDSBuildingPinningToCover) : REMJsonSvc(@"API/Building.svc/CreateBuildingCoverRelation"),\
\
    /** Dashboard */\
    @(REMDSDashboardFavorite) : REMJsonSvc(@"API/Dashboard.svc/GetFavoriteDashboards"),\
\
    /** Other */\
    @(REMDSLogSend) : REMJsonSvc(@"API/Log.svc/SendLog"),\
};

#define REMNetworkMessageMap @{@(REMDataAccessErrorMessage):REMIPadLocalizedString(@"Common_NetServerError"), @(REMDataAccessFailed):REMIPadLocalizedString(@"Common_NetConnectionFailed"), @(REMDataAccessNoConnection):REMIPadLocalizedString(@"Common_NetNoConnection")}

#endif
