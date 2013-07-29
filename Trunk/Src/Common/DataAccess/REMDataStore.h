//
//  REMDataAccessOption.h
//  Blues
//
//  Created by zhangfeng on 7/12/13.
//
//

#import <Foundation/Foundation.h>

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
    //...
    
    /*
     * Other
     */
    REMDSLogSend,
    
} REMDataStoreType;

@interface REMDataStore : NSObject

@property (nonatomic) REMDataStoreType name;
@property (nonatomic,strong) NSString* service;
@property (nonatomic,strong) id parameter;
@property (nonatomic,strong) UIView* maskContainer;
@property (nonatomic) BOOL isStoreLocal;
@property (nonatomic) BOOL isAccessLocal;
@property (nonatomic,strong) NSString * groupName;

- (REMDataStore *)initWithName:(REMDataStoreType)name parameter:(id)parameter;

- (REMDataStore *)initWithEnergyStore:(NSString *)energyStore parameter:(id) parameter;

@end
