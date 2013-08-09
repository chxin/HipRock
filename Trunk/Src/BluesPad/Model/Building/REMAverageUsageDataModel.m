//
//  REMAverageUsageDataModel.m
//  Blues
//
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
