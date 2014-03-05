/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: CommodityUsageModel.h
 * Created      : 张 锋 on 8/1/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
