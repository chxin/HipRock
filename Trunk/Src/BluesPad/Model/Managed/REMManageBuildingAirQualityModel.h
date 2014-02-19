//
//  REMManageBuildingAirQualityModel.h
//  Blues
//
//  Created by tantan on 2/18/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "REMManagedModel.h"

@class REMBuildingEnergyUsageModel, REMManagedCommodityModel;

@interface REMManageBuildingAirQualityModel : REMManagedModel

@property (nonatomic, retain) REMManagedCommodityModel *commodity;
@property (nonatomic, retain) REMBuildingEnergyUsageModel *outdoor;
@property (nonatomic, retain) REMBuildingEnergyUsageModel *honeywell;
@property (nonatomic, retain) REMBuildingEnergyUsageModel *mayair;

@end
