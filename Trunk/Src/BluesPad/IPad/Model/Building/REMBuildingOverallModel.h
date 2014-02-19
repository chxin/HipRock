/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: BuildingOverallModel.h
 * Created      : 张 锋 on 8/1/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMBuildingModel.h"
#import "REMCommonHeaders.h"
#import "REMAirQualityModel.h"
#import "REMCommodityUsageModel.h"
#import "REMBuildingCoverWidgetRelationModel.h"

@interface REMBuildingOverallModel : REMJSONObject

@property (nonatomic,strong) REMBuildingModel *building;
@property (nonatomic,strong) NSArray *commodityUsage;
@property (nonatomic,strong) REMAirQualityModel *airQuality;
@property (nonatomic,strong) NSArray *dashboardArray;
@property (nonatomic,strong) NSArray *commodityArray;
@property (nonatomic,strong) NSNumber *isQualified;
@property (nonatomic,strong) REMCommodityUsageModel *electricityUsageThisMonth;
@property (nonatomic,strong) NSArray *widgetRelationArray;


+(int)indexOfBuilding:(REMBuildingModel *)building inBuildingOverallArray:(NSArray *)array;
+(NSArray *)sortByProvince:(NSArray *)buildingInfoArray;

@end
