//
//  REMEnergyUsageDataModel.m
//  Blues
//
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
