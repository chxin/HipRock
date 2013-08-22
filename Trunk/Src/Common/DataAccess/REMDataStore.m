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
          [NSNumber numberWithInt:REMDSEnergyTagsDistribute] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Energy.svc/AggregateTagsData"],
          
          /**
           *	Building
           */
          [NSNumber numberWithInt:REMDSEnergyBuildingOverall] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Building.svc/GetBuildingOverallData"],
          [NSNumber numberWithInt:REMDSEnergyBuildingTimeRange] : [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:@"API/Building.svc/GetBuildingTimeRangeData"],
          [NSNumber numberWithInt:REMDSBuildingImage] : [[REMServiceMeta alloc] initWithDataResultRelativeUrl:@"API/Building.svc/GetBuildingPicture"],
          
          
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
