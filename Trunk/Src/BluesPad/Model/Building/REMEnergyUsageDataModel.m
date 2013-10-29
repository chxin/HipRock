//
//  REMEnergyUsageDataModel.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 8/1/13.
//
//

#import "REMEnergyUsageDataModel.h"
#import "REMUomModel.h"

@implementation REMEnergyUsageDataModel

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.dataValue = dictionary[@"DataValue"];
    self.dataQuality = [dictionary[@"DataQuality"] intValue];
    self.uom = [[REMUomModel alloc] initWithDictionary:dictionary[@"Uom"]];
}

@end
