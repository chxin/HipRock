/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMCommodityUsageValuePersistenceProcessor.m
 * Date Created : tantan on 3/4/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMCommodityUsageValuePersistenceProcessor.h"

@implementation REMCommodityUsageValuePersistenceProcessor


- (id)persist:(NSDictionary *)dictionary{
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
    
    NSDictionary *annualUsageDic = dictionary[@"AnnualAverageUsage"];
    if(!REMIsNilOrNull(annualUsageDic)){
        self.commodityInfo.annualUsage = NULL_TO_NIL(annualUsageDic[@"DataValue"]);
        self.commodityInfo.annualUsageUom = NULL_TO_NIL(annualUsageDic[@"UomCode"]);
    }
    
    NSDictionary *annualBaselineDic = dictionary[@"AnnualAverageBaseline"];
    if(!REMIsNilOrNull(annualBaselineDic)){
        self.commodityInfo.annualBaseline = NULL_TO_NIL(annualBaselineDic[@"DataValue"]);
        self.commodityInfo.annualBaselineUom = NULL_TO_NIL(annualBaselineDic[@"UomCode"]);
    }
    
    self.commodityInfo.annualEfficiency = NULL_TO_NIL(dictionary[@"AnnualEnergyEfficiency"]);
    
    [self save];
    
    return self.commodityInfo;
    
}

- (id)fetch{
    return self.commodityInfo;
}

@end
