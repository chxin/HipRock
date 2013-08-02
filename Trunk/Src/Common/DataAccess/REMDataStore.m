//
//  REMDataAccessOption.m
//  Blues
//
//  Created by zhangfeng on 7/12/13.
//
//

#import "REMDataStore.h"
#import "REMServiceUrl.h"

@implementation REMDataStore

static NSDictionary *energyStoreMap = nil;
static NSDictionary *serviceMap = nil;

- (REMDataStore *)initWithName:(REMDataStoreType)name parameter:(id)parameter
{
    REMDataStore *store = [self init]; 
    
    store.name = name;
    store.parameter = parameter;
    
    store.service = [REMServiceUrl absoluteUrl:[[REMDataStore serviceMap] objectForKey:[REMDataStore numberFromInt:name]]];
    
    return store;
}

- (REMDataStore *)initWithEnergyStore:(NSString *)energyStore parameter:(id) parameter
{
    REMDataStore *store = [self init];
    
    //NSAssert(energyStore != nil, @"Oh shit, energy store does not exist");
    
    store.name = (REMDataStoreType)[[REMDataStore energyStoreMap] objectForKey:energyStore];
    store.parameter = parameter;
    
    store.service = [REMServiceUrl absoluteUrl:[[REMDataStore serviceMap] objectForKey:[[REMDataStore energyStoreMap] objectForKey:energyStore]]];
    
    return store;
}


+ (NSDictionary *) energyStoreMap
{
    if(energyStoreMap == nil)
    {
        energyStoreMap =
        @{
          @"energy.Energy": [[NSNumber alloc] initWithInt:REMDSEnergyTagsTrend],
          @"energy.Distribution": [[NSNumber alloc] initWithInt:REMDSEnergyTagsDistribute],
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
          [REMDataStore numberFromInt:REMDSUserValidate] : @"API/AccessControl.svc/ValidateUser",
          [REMDataStore numberFromInt:REMDSDashboardFavorite] : @"API/Dashboard.svc/GetFavoriteDashboards",
          [REMDataStore numberFromInt:REMDSEnergyTagsTrend] : @"API/Energy.svc/GetTagsData",
          [REMDataStore numberFromInt:REMDSEnergyTagsDistribute] : @"API/Energy.svc/AggregateTagsData",
          [REMDataStore numberFromInt:REMDSEnergyTimeSpansTrend] : @"",
          [REMDataStore numberFromInt:REMDSEnergyTimeSpansDistribute] : @"",
          [REMDataStore numberFromInt:REMDSEnergyCarbonTrend] : @"",
          [REMDataStore numberFromInt:REMDSEnergyCarbonDistribute] : @"",
          [REMDataStore numberFromInt:REMDSEnergyCostTrend] : @"",
          [REMDataStore numberFromInt:REMDSEnergyCostDistribute] : @"",
          [REMDataStore numberFromInt:REMDSLogSend] : @"API/Log.svc/SendLog",
        };
    }
    
    return serviceMap;
}

+ (NSNumber *) numberFromInt: (int) intValue
{
    return [[NSNumber alloc] initWithInt:intValue];
}

@end
