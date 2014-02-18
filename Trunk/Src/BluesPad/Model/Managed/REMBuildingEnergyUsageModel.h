//
//  REMBuildingEnergyUsageModel.h
//  Blues
//
//  Created by tantan on 2/18/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "REMManagedModel.h"

@class REMManagedCommodityModel, REMManagedUomModel;

@interface REMBuildingEnergyUsageModel : REMManagedModel

@property (nonatomic, retain) NSNumber * dataValue;
@property (nonatomic, retain) NSNumber * quality;
@property (nonatomic, retain) REMManagedCommodityModel *commodity;
@property (nonatomic, retain) REMManagedUomModel *uom;

@end
