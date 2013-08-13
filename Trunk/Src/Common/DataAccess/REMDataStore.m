//
//  REMDataAccessOption.m
//  Blues
//
//  Created by zhangfeng on 7/12/13.
//
//

#import "REMDataStore.h"
#import "REMServiceUrl.h"
#import "REMServiceMeta.h"


@implementation REMDataStore

static NSDictionary *energyStoreMap = nil;
static NSDictionary *serviceMap = nil;

- (REMDataStore *)initWithName:(REMDataStoreType)name parameter:(id)parameter
{
    REMDataStore *store = [self init]; 
    
    store.name = name;
    store.parameter = parameter;
    
    store.serviceMeta = [[REMDataStore serviceMap] objectForKey:[REMDataStore numberFromInt:name]];
    
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
          [REMDataStore numberFromInt:REMDSUserValidate] : [[REMServiceMeta alloc] initWithRelativeUrl:@"API/AccessControl.svc/ValidateUser" andResponseType:REMServiceResponseJson],
          
          [REMDataStore numberFromInt:REMDSDashboardFavorite] : [[REMServiceMeta alloc] initWithRelativeUrl:@"API/Dashboard.svc/GetFavoriteDashboards" andResponseType:REMServiceResponseJson],
          
          [REMDataStore numberFromInt:REMDSEnergyTagsTrend] : [[REMServiceMeta alloc] initWithRelativeUrl:@"API/Energy.svc/GetTagsData" andResponseType:REMServiceResponseJson],
          
          [REMDataStore numberFromInt:REMDSEnergyTagsDistribute] : [[REMServiceMeta alloc] initWithRelativeUrl:@"API/Energy.svc/AggregateTagsData" andResponseType:REMServiceResponseJson],
          
          [REMDataStore numberFromInt:REMDSEnergyBuildingOverall] : [[REMServiceMeta alloc] initWithRelativeUrl:@"API/Energy.svc/GetBuildingOverallData" andResponseType:REMServiceResponseJson],
          
          [REMDataStore numberFromInt:REMDSEnergyBuildingTimeRange] : [[REMServiceMeta alloc] initWithRelativeUrl:@"API/Energy.svc/GetBuildingTimeRangeData" andResponseType:REMServiceResponseJson],
          
          [REMDataStore numberFromInt:REMDSLogSend] : [[REMServiceMeta alloc] initWithRelativeUrl:@"API/Log.svc/SendLog" andResponseType:REMServiceResponseJson],
          
          [REMDataStore numberFromInt:REMDSBuildingImage] : [[REMServiceMeta alloc] initWithRelativeUrl:@"API/Hierarchy.svc/GetBuildingPicture" andResponseType:REMServiceResponseImage],
        };
    }
    
    return serviceMap;
}


+ (NSNumber *) numberFromInt: (int) intValue
{
    return [[NSNumber alloc] initWithInt:intValue];
}



@end
