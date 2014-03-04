/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMCommodityUsageValuePersistenceProcessor.m
 * Date Created : tantan on 3/4/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMCommodityUsageValuePersistenceProcessor.h"

@implementation REMCommodityUsageValuePersistenceProcessor

- (id)fetchData{
    return self.commodityInfo;
}

- (id)persistData:(NSDictionary *)dictionary{
    NSDictionary *totalDic = dictionary[@"EnergyUsage"];
    self.commodityInfo.totalValue = NULL_TO_NIL(totalDic[@"DataValue"]);
    self.commodityInfo.totalUom = NULL_TO_NIL(totalDic[@"Uom"][@"Code"]);
    
    NSDictionary *carbonDic = dictionary[@"CarbonEmission"];
    self.commodityInfo.carbonValue = NULL_TO_NIL(carbonDic[@"DataValue"]);
    self.commodityInfo.carbonUom = NULL_TO_NIL(carbonDic[@"Uom"][@"Code"]);
    
    self.commodityInfo.isTargetAchieved = NULL_TO_NIL(dictionary[@"IsTargetAchieved"]);
    
    NSDictionary *targetDic = dictionary[@"TargetValue"];
    self.commodityInfo.targetValue = NULL_TO_NIL(targetDic[@"DataValue"]);
    self.commodityInfo.targetUom = NULL_TO_NIL(targetDic[@"Uom"][@"Code"]);
    
    NSDictionary *rankingDic = dictionary[@"RankingData"];
    self.commodityInfo.rankingNumerator = NULL_TO_NIL(rankingDic[@"RankingNumerator"]);
    self.commodityInfo.rankingDenominator = NULL_TO_NIL(rankingDic[@"RankingDenominator"]);
    
    [self.dataStore persistManageObject];
    
    return self.commodityInfo;
    
}

@end
