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
     * User stores
     */
    REMDSUserValidate,
    
    /*
     * Dashboard stores
     */
    REMDSDashboardFavorite,
    
    /*
     * Energy stores
     */
    REMDSEnergyTagsTrend,
    REMDSEnergyTagsDistribute,
    REMDSEnergyTimeSpansTrend,
    REMDSEnergyTimeSpansDistribute,
    REMDSEnergyCarbonTrend,
    REMDSEnergyCarbonDistribute,
    REMDSEnergyCostTrend,
    REMDSEnergyCostDistribute,
    REMDSEnergyBuildingOverall,
    REMDSEnergyBuildingTimeRange,
    
    //Hierarchy
    REMDSBuildingImage,
    //...
    
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
@property (nonatomic) BOOL isStoreLocal;
@property (nonatomic) BOOL isAccessLocal;
@property (nonatomic,strong) NSString * groupName;

- (REMDataStore *)initWithName:(REMDataStoreType)name parameter:(id)parameter;

- (REMDataStore *)initWithEnergyStore:(NSString *)energyStore parameter:(id) parameter;

@end

@interface REMMobileService : NSObject


@end
