//
//  BuildingOverallModel.h
//  Blues
//
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

@end
