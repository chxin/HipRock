//
//  BuildingOverallModel.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 8/1/13.
//
//

#import <Foundation/Foundation.h>
#import "REMBuildingModel.h"
#import "REMCommonHeaders.h"
#import "REMAirQualityModel.h"

@interface REMBuildingOverallModel : REMJSONObject

@property (nonatomic,strong) REMBuildingModel *building;
@property (nonatomic,strong) NSArray *commodityUsage;
@property (nonatomic,strong) REMAirQualityModel *airQuality;
@property (nonatomic,strong) NSArray *dashboardArray;
@property (nonatomic,strong) NSArray *commodityArray;
@property (nonatomic,strong) NSNumber *isQualified;

@end
