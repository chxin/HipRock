/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMDataAccessOption.m
 * Created      : zhangfeng on 7/12/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMDataStore.h"
#import "REMServiceMeta.h"


@implementation REMDataStore

#define REMJsonSvc(a) [[REMServiceMeta alloc] initWithJsonResultRelativeUrl:(a)]
#define REMDataSvc(a) [[REMServiceMeta alloc] initWithDataResultRelativeUrl:(a)]

static NSDictionary *serviceMap = nil;

- (REMDataStore *)initWithName:(REMDataStoreType)name parameter:(id)parameter
{
    REMDataStore *store = [self init]; 
    
    store.name = name;
    store.parameter = parameter;
    
    store.serviceMeta = [[REMDataStore serviceMap] objectForKey:[NSNumber numberWithInt:name]];
    
    return store;
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
          @(REMDSUserValidate) :
              REMJsonSvc(@"API/AccessControl.svc/ValidateUser"),
          @(REMDSDemoUserValidate) :
              REMJsonSvc(@"API/AccessControl.svc/ValidateDemoUser"),
          @(REMDSUserCustomerValidate) :
              REMJsonSvc(@"API/AccessControl.svc/ValidateUserCustomer"),
          
          /**
           *	Energy
           */
          @(REMDSEnergyTagsTrend) :
              REMJsonSvc(@"API/Energy.svc/GetTagsData"),
          @(REMDSEnergyTagsTrendUnit) :
              REMJsonSvc(@"API/Energy.svc/GetEnergyUsageUnitData"),
          @(REMDSEnergyTagsDistribute) :
              REMJsonSvc(@"API/Energy.svc/AggregateTagsData"),
          @(REMDSEnergyMultiTimeTrend) :
              REMJsonSvc(@"API/Energy.svc/GetTagsData"),
          @(REMDSEnergyMultiTimeDistribute) :
              REMJsonSvc(@"API/Energy.svc/AggregateTimeSpansData"),
          @(REMDSEnergyCarbon) :
              REMJsonSvc(@"API/Energy.svc/GetCarbonUsageData"),
          @(REMDSEnergyCarbonUnit) :
              REMJsonSvc(@"API/Energy.svc/GetCarbonUsageUnitData"),
          @(REMDSEnergyCarbonDistribute) :
              REMJsonSvc(@"API/Energy.svc/AggregateCarbonUsageData"),
          @(REMDSEnergyCost) :
              REMJsonSvc(@"API/Energy.svc/GetCostData"),
          @(REMDSEnergyCostUnit) :
              REMJsonSvc(@"API/Energy.svc/GetCostUnitData"),
          @(REMDSEnergyCostDistribute) :
              REMJsonSvc(@"API/Energy.svc/AggregateCostData"),
          @(REMDSEnergyCostElectricity) :
              REMJsonSvc(@"API/Energy.svc/GetElectricityCostData"),
          @(REMDSEnergyRatio) :
              REMJsonSvc(@"API/Energy.svc/RatioGetTagsData"),
          @(REMDSEnergyRankingEnergy) :
              REMJsonSvc(@"API/Energy.svc/RankingEnergyUsageData"),
          @(REMDSEnergyRankingCost) :
              REMJsonSvc(@"API/Energy.svc/RankingCostData"),
          @(REMDSEnergyRankingCarbon) :
              REMJsonSvc(@"API/Energy.svc/RankingCarbonData"),
          @(REMDSEnergyLabeling) :
              REMJsonSvc(@"API/Energy.svc/LabellingGetTagsData"),
          
          /**
           * User
           */
          @(REMDSUserGetCurrent) :
              REMJsonSvc(@"API/User.svc/GetCurrentUser"),
          
          /**
           * Customer
           */
          @(REMDSCustomerLogo) :
              REMDataSvc(@"API/Hierarchy.svc/GetCustomerLogo"),
          @(REMDSCustomerSwitch) :
              REMJsonSvc(@"API/Customer.svc/SwitchCustomer"),
          
          /**
           *	Building
           */
          @(REMDSBuildingOverallData) :
              REMJsonSvc(@"API/Building.svc/GetBuildingOverallData"),
          @(REMDSBuildingCommodityTotalUsage) :
              REMJsonSvc(@"API/Building.svc/GetBuildingCommodityUsage"),
          @(REMDSBuildingInfo) :
              REMJsonSvc(@"API/Building.svc/GetBuildingInfo"),
          @(REMDSBuildingAverageData) :
              REMJsonSvc(@"API/Building.svc/GetBuildingAverageUsageData"),
          @(REMDSBuildingTimeRangeData) :
              REMJsonSvc(@"API/Building.svc/GetBuildingTimeRangeData"),
          @(REMDSBuildingAirQuality) :
              REMJsonSvc(@"API/Building.svc/GetBuildingAirQualityData"),
          @(REMDSBuildingAirQualityTotalUsage) :
              REMJsonSvc(@"API/Building.svc/GetBuildingAirQualityUsage"),
          @(REMDSBuildingPicture) :
              REMDataSvc(@"API/Building.svc/GetBuildingPicture"),
          
          
          /**
           *	Dashboard
           */
          @(REMDSDashboardFavorite) :
              REMJsonSvc(@"API/Dashboard.svc/GetFavoriteDashboards"),
          
          /**
           *	Other
           */
          @(REMDSLogSend) :
              REMJsonSvc(@"API/Log.svc/SendLog"),
        };
    }
    
    return serviceMap;
}



@end
