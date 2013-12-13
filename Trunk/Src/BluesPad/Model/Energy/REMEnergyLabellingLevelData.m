/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEnergyLabellingLevelData.m
 * Date Created : tantan on 12/13/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMEnergyLabellingLevelData.h"

@implementation REMEnergyLabellingLevelData

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.name = dictionary[@"Name"];
    self.maxValue=dictionary[@"MaxValue"];
    self.minValue=dictionary[@"MinValue"];
    self.uom=dictionary[@"Uom"];
    self.uomId=dictionary[@"UomId"];
}

@end
