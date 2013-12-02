/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: BuildingOverallModel.m
 * Created      : 张 锋 on 8/1/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMBuildingOverallModel.h"
#import "REMBuildingModel.h"
#import "REMCommodityUsageModel.h"
#import "REMDashboardObj.h"

@implementation REMBuildingOverallModel

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.building = [[REMBuildingModel alloc] initWithDictionary:dictionary[@"Building"]];
    
    NSArray *usageArray = dictionary[@"CommodityUsage"];
    if(usageArray!=nil && [usageArray isEqual:[NSNull null]]==NO){
        NSMutableArray *commodities = [[NSMutableArray alloc] initWithCapacity:usageArray.count];
        for(NSDictionary *usage in usageArray)
        {
            [commodities addObject:[[REMCommodityUsageModel alloc] initWithDictionary:usage]];
        }
        
        self.commodityUsage = commodities;
    }
    NSDictionary *air = dictionary[@"AirQualitySummary"];
    
    if(air != nil){
        self.airQuality=[[REMAirQualityModel alloc]initWithDictionary:air];
    }
    
    NSArray *dashboardArray = dictionary[@"DashboardList"];
    
    if (dashboardArray!=nil) {
        NSMutableArray *dashboardList=[[NSMutableArray alloc]initWithCapacity:dashboardArray.count];
        for (NSDictionary *dashboard in dashboardArray) {
            REMDashboardObj *obj = [[REMDashboardObj alloc]initWithDictionary:dashboard];
            if (obj.widgets.count!=0) {
                [dashboardList addObject:obj];
            }
            
        }
        self.dashboardArray=dashboardList;
    }
    
    NSArray *commodityArray=dictionary[@"CommodityArray"];
    
    if(commodityArray!=nil){
        NSMutableArray *commodityList=[[NSMutableArray alloc]initWithCapacity:commodityArray.count];
        for (NSDictionary *commodity in commodityArray) {
            REMCommodityModel *obj = [[REMCommodityModel alloc]initWithDictionary:commodity];
            [commodityList addObject:obj];
        }
        self.commodityArray=commodityList;
    }
    
    self.isQualified = dictionary[@"IsQualified"];
    
    self.electricityUsageThisMonth = [[REMCommodityUsageModel alloc] initWithDictionary:dictionary[@"ElectricUsageThisMonth"]];
}

@end
