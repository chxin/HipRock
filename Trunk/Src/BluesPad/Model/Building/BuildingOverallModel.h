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

@interface BuildingOverallModel : REMJSONObject

@property (nonatomic,strong) REMBuildingModel *building;
@property (nonatomic,strong) NSArray *commodityUsage;

@end
