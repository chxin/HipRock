/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMDataAccessOption.h
 * Created      : zhangfeng on 7/12/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMServiceMeta.h"

typedef enum _REMDataStoreType
{
    /*
     * AccessControl
     */
    REMDSUserValidate,
    
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
    REMDSBuildingAirQuality,
    
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


@interface REMDataStore : NSObject

@property (nonatomic) REMDataStoreType name;
@property (nonatomic,strong) REMServiceMeta* serviceMeta;
@property (nonatomic,strong) id parameter;
@property (nonatomic,strong) UIView* maskContainer;
@property (nonatomic,strong) NSString * groupName;

- (REMDataStore *)initWithName:(REMDataStoreType)name parameter:(id)parameter;

- (REMDataStore *)initWithEnergyStore:(NSString *)energyStore parameter:(id) parameter;

@end

@interface REMMobileService : NSObject


@end
