//
//  CommodityUsageModel.m
//  Blues
//
//  Created by 张 锋 on 8/1/13.
//
//

#import "REMCommodityUsageModel.h"
#import "REMCommodityModel.h"
#import "REMEnergyUsageDataModel.h"
#import "REMRankingDataModel.h"
#import "REMAverageUsageDataModel.h"

@implementation REMCommodityUsageModel

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.commodity = [[REMCommodityModel alloc] initWithDictionary:dictionary[@"Commodity"]];
    self.commodityUsage = [[REMEnergyUsageDataModel alloc] initWithDictionary:dictionary[@"EnergyUsage"]];
    self.carbonEquivalent = [[REMEnergyUsageDataModel alloc] initWithDictionary:dictionary[@"CarbonEmission"]];
    self.rankingData = [[REMRankingDataModel alloc] initWithDictionary:dictionary[@"RankingData"]];
    self.targetValue = [[REMEnergyUsageDataModel alloc] initWithDictionary:dictionary[@"TargetValue"]];
    self.isTargetAchieved = [dictionary[@"IsTargetAchieved"] boolValue];
    self.averageUsageData = [[REMAverageUsageDataModel alloc] initWithDictionary:dictionary[@"AverageUsageData"]];
}

@end
