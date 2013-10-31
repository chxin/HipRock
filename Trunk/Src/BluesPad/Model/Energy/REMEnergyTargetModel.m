//
//  REMEnergyTargetObj.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by TanTan on 7/11/13.
//
//

#import "REMEnergyTargetModel.h"
#import "REMTimeRange.h"

@implementation REMEnergyTargetModel

-(void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.targetId = dictionary[@"TargetId"];
    self.name = dictionary[@"Name"];
    self.code = dictionary[@"Code"];
    self.commodityId = [dictionary[@"CommodityId"] longLongValue];
    self.uomName = dictionary[@"Uom"];
    self.type = (REMEnergyTargetType)[dictionary[@"Type"] intValue];
    self.uomId = [dictionary[@"UomId"] longLongValue];

    if((NSNull *)dictionary[@"VisiableTimeSpan"] != [NSNull null] && dictionary[@"VisiableTimeSpan"]!= nil)
    {
        self.visiableTimeRange = [[REMTimeRange alloc] initWithDictionary:(NSDictionary *)dictionary[@"VisiableTimeSpan"]];
    }
    
    if((NSNull *)dictionary[@"GlobalTimeSpan"] != [NSNull null] && dictionary[@"GlobalTimeSpan"]!= nil)
    {
        self.globalTimeRange = [[REMTimeRange alloc] initWithDictionary:(NSDictionary *)dictionary[@"GlobalTimeSpan"]];
    }
}


@end
