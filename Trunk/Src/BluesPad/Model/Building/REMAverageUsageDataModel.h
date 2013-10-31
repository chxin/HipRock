//
//  REMAverageUsageDataModel.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 8/9/13.
//
//

#import <Foundation/Foundation.h>
#import "REMEnergyViewData.h"

@interface REMAverageUsageDataModel : REMJSONObject

@property (nonatomic,strong) REMEnergyViewData *unitData;
@property (nonatomic,strong) REMEnergyViewData *benchmarkData;


@end
