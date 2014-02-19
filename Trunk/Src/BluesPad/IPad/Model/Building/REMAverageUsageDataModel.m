/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMAverageUsageDataModel.m
 * Created      : 张 锋 on 8/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMAverageUsageDataModel.h"
#import "REMEnergyViewData.h"

@implementation REMAverageUsageDataModel

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.unitData = [[REMEnergyViewData alloc] initWithDictionary:dictionary[@"UnitData"]];
    self.benchmarkData = [[REMEnergyViewData alloc] initWithDictionary:dictionary[@"BenchmarkData"]];
}

@end
