//
//  REMDataAccessOption.h
//  Blues
//
//  Created by zhangfeng on 7/12/13.
//
//

#import <Foundation/Foundation.h>
#import "REMServiceMeta.h"

typedef enum _REMDataStoreType
{
    /*
     * AccessControl
     */
    REMDSUserValidate,
    
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
    REMDSEnergyTagsDistribute,
    REMDSEnergyMultiTimeTrend,
    REMDSEnergyMultiTimeDistribute,
    REMDSEnergyCarbon,
    REMDSEnergyCarbonDistribute,
    REMDSEnergyCost,
    REMDSEnergyCostDistribute,
    REMDSEnergyCostElectricity,
    REMDSEnergyRanking,
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
