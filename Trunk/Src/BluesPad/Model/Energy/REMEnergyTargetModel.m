//
//  REMEnergyTargetObj.m
//  Blues
//
//  Created by TanTan on 7/11/13.
//
//

#import "REMEnergyTargetModel.h"
#import "REMTimeRange.h"

@implementation REMEnergyTargetModel

-(void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.targetId = [dictionary[@"TargetId"] longLongValue];
    self.name = dictionary[@"Name"];
    self.code = dictionary[@"Code"];
    self.commodityId = [dictionary[@"CommodityId"] longLongValue];
    self.uomName = dictionary[@"Uom"];
    self.type = (REMEnergyTargetType)[dictionary[@"Type"] intValue];
    
    if((NSNull *)dictionary[@"VisiableTimeRange"] != [NSNull null] && dictionary[@"VisiableTimeRange"]!= nil)
    {
        self.visiableTimeRange = [[REMTimeRange alloc] initWithDictionary:(NSDictionary *)dictionary[@"VisiableTimeRange"]];
    }
    
    if((NSNull *)dictionary[@"GlobalTimeSpan"] != [NSNull null] && dictionary[@"GlobalTimeSpan"]!= nil)
    {
        self.globalTimeRange = [[REMTimeRange alloc] initWithDictionary:(NSDictionary *)dictionary[@"GlobalTimeSpan"]];
    }
}


@end
