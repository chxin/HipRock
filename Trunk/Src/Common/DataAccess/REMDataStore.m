//
//  REMDataAccessOption.m
//  Blues
//
//  Created by zhangfeng on 7/12/13.
//
//

#import "REMDataStore.h"
#import "REMServiceMeta.h"


@implementation REMDataStore

static NSDictionary *energyStoreMap = nil;
static NSDictionary *serviceMap = nil;

- (REMDataStore *)initWithName:(REMDataStoreType)name parameter:(id)parameter
{
    REMDataStore *store = [self init]; 
    
    store.name = name;
    store.parameter = parameter;
    
    store.serviceMeta = [[REMDataStore serviceMap] objectForKey:[NSNumber numberWithInt:name]];
    
    return store;
}

- (REMDataStore *)initWithEnergyStore:(NSString *)energyStore parameter:(id) parameter
{
    REMDataStore *store = [self init];
    
    //NSAssert(energyStore != nil, @"Oh shit, energy store does not exist");
    
    store.name = (REMDataStoreType)[[REMDataStore energyStoreMap] objectForKey:energyStore];
    store.parameter = parameter;
    
    store.serviceMeta = [[REMDataStore serviceMap] objectForKey:[[REMDataStore energyStoreMap] objectForKey:energyStore]];
    
    return store;
}


+ (NSDictionary *) energyStoreMap
{
    if(energyStoreMap == nil)
    {
        energyStoreMap =
        @{
          @"energy.Energy": [NSNumber numberWithInt:REMDSEnergyTagsTrend],
          @"energy.Distribution": [NSNumber numberWithInt:REMDSEnergyTagsDistribute],
        };
    }
    
    return energyStoreMap;
}

+ (NSDictionary *) serviceMap
{
    if(serviceMap == nil)
    {
        serviceMap =
        @{
          /**
           *	AccessControl
           */
          [NSNumber numberWithInt:REMDSUserValidate] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl :@"API/AccessControl.svc/ValidateUser"],
          
          /**
           *	Energy
           */
          [NSNumber numberWithInt:REMDSEnergyTagsTrend] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Energy.svc/GetTagsData"],
          [NSNumber numberWithInt:REMDSEnergyTagsTrendUnit] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Energy.svc/GetEnergyUsageUnitData"],
          [NSNumber numberWithInt:REMDSEnergyTagsDistribute] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Energy.svc/AggregateTagsData"],
          [NSNumber numberWithInt:REMDSEnergyMultiTimeTrend] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Energy.svc/GetTagsData"],
          [NSNumber numberWithInt:REMDSEnergyMultiTimeDistribute] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Energy.svc/AggregateTimeSpanData"],
          [NSNumber numberWithInt:REMDSEnergyCarbon] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Energy.svc/GetCarbonUsageData"],
          [NSNumber numberWithInt:REMDSEnergyCarbonUnit] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Energy.svc/GetCarbonUsageUnitData"],
          [NSNumber numberWithInt:REMDSEnergyCarbonDistribute] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Energy.svc/AggregateCarbonUsageData"],
          [NSNumber numberWithInt:REMDSEnergyCost] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Energy.svc/GetCostData"],
          [NSNumber numberWithInt:REMDSEnergyCostUnit] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Energy.svc/GetCostUnitData"],
          [NSNumber numberWithInt:REMDSEnergyCostDistribute] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Energy.svc/AggregateCostData"],
          [NSNumber numberWithInt:REMDSEnergyCostElectricity] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Energy.svc/GetElectricityCostData"],
          [NSNumber numberWithInt:REMDSEnergyRatio] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Energy.svc/RatioGetTagsData"],
          [NSNumber numberWithInt:REMDSEnergyRankingEnergy] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Energy.svc/RankingEnergyUsageData"],
          [NSNumber numberWithInt:REMDSEnergyRankingCost] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Energy.svc/RankingCostData"],
          [NSNumber numberWithInt:REMDSEnergyRankingCarbon] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Energy.svc/RankingCarbonData"],
          
          /**
           * Customer
           */
          [NSNumber numberWithInt:REMDSCustomerLogo] : [[REMServiceMeta alloc] initWithDataResultRelativeUrl:@"API/Hierarchy.svc/GetCustomerLogo"],
          [NSNumber numberWithInt:REMDSCustomerSwitch] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Customer.svc/SwitchCustomer"],
          /**
           *	Building
           */
          [NSNumber numberWithInt:REMDSBuildingOverallData] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Building.svc/GetBuildingOverallData"],
          [NSNumber numberWithInt:REMDSBuildingCommodityTotalUsage] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Building.svc/GetBuildingCommodityUsage"],
          [NSNumber numberWithInt:REMDSBuildingInfo] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Building.svc/GetBuildingInfo"],
          [NSNumber numberWithInt:REMDSBuildingAverageData] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Building.svc/GetBuildingAverageUsageData"],
          [NSNumber numberWithInt:REMDSBuildingTimeRangeData] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Building.svc/GetBuildingTimeRangeData"],
          [NSNumber numberWithInt:REMDSBuildingAirQuality] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Building.svc/GetBuildingAirQualityData"],
          [NSNumber numberWithInt:REMDSBuildingPicture] : [[REMServiceMeta alloc] initWithDataResultRelativeUrl:@"API/Building.svc/GetBuildingPicture"],
          
          
          /**
           *	Dashboard
           */
          [NSNumber numberWithInt:REMDSDashboardFavorite] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Dashboard.svc/GetFavoriteDashboards"],
          
          /**
           *	Other
           */
          [NSNumber numberWithInt:REMDSLogSend] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Log.svc/SendLog"],
        };
    }
    
    return serviceMap;
}



@end
