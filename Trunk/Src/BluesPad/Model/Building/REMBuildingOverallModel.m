//
//  BuildingOverallModel.m
//  Blues
//
//  Created by 张 锋 on 8/1/13.
//
//

#import "REMBuildingOverallModel.h"
#import "REMBuildingModel.h"
#import "REMCommodityUsageModel.h"

@implementation REMBuildingOverallModel

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.building = [[REMBuildingModel alloc] initWithDictionary:dictionary[@"Building"]];
    
    NSArray *usageArray = dictionary[@"CommodityUsage"];
    NSMutableArray *commodities = [[NSMutableArray alloc] initWithCapacity:usageArray.count];
    for(NSDictionary *usage in usageArray)
    {
        [commodities addObject:[[REMCommodityUsageModel alloc] initWithDictionary:usage]];
    }
    
    self.commodityUsage = commodities;
}

@end
