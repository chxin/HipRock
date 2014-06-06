/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEnergyTargetObj.m
 * Created      : TanTan on 7/11/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMEnergyTargetModel.h"
#import "REMTimeRange.h"
#import "REMTargetAssociationModel.h"

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
    
    self.association = [[REMTargetAssociationModel alloc] init];
    //TODO: remove
#ifdef DEBUG
    self.association.hierarchyId = self.targetId;
#endif
}


@end
