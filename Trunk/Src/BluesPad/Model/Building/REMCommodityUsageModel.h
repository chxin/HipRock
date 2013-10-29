//
//  CommodityUsageModel.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 8/1/13.
//
//

#import <Foundation/Foundation.h>
#import "REMCommodityModel.h"
#import "REMEnergyUsageDataModel.h"
#import "REMRankingDataModel.h"
#import "REMCommonHeaders.h"
#import "REMAverageUsageDataModel.h"

@interface REMCommodityUsageModel : REMJSONObject

@property (nonatomic,strong) REMCommodityModel *commodity;

@property (nonatomic,strong) REMEnergyUsageDataModel *commodityUsage;

@property (nonatomic,strong) REMEnergyUsageDataModel *carbonEquivalent;

@property (nonatomic,strong) REMRankingDataModel *rankingData;

@property (nonatomic,strong) REMEnergyUsageDataModel *targetValue;

@property (nonatomic) BOOL isTargetAchieved;

@property (nonatomic,strong) REMAverageUsageDataModel *averageUsageData;

@end
