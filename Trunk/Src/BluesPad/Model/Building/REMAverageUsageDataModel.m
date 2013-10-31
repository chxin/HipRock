//
//  REMAverageUsageDataModel.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 8/9/13.
//
//

#import "REMAverageUsageDataModel.h"
#import "REMEnergyViewData.h"

@implementation REMAverageUsageDataModel

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.unitData = [[REMEnergyViewData alloc] initWithDictionary:dictionary[@"UnitData"]];
    self.benchmarkData = [[REMEnergyViewData alloc] initWithDictionary:dictionary[@"BenchmarkData"]];
}

@end
