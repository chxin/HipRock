//
//  REMAverageUsageDataModel.h
//  Blues
//
//  Created by 张 锋 on 8/9/13.
//
//

#import <Foundation/Foundation.h>
#import "REMEnergyViewData.h"

@interface REMAverageUsageDataModel : REMJSONObject

@property (nonatomic,strong) REMEnergyViewData *unitData;
@property (nonatomic,strong) REMEnergyViewData *benchmarkData;


@end
