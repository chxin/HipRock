//
//  REMTargetEnergyData.h
//  Blues
//
//  Created by 谭 坦 on 7/16/13.
//
//

#import <Foundation/Foundation.h>
#import "REMEnergyTargetModel.h"
#import "REMEnergyData.h"

@interface REMTargetEnergyData : REMJSONObject

@property (nonatomic,strong) REMEnergyTargetModel *target;

@property (nonatomic,strong) NSArray *energyData;

@end
