//
//  REMCommodityModel.m
//  Blues
//
//  Created by 张 锋 on 8/1/13.
//
//

#import "REMCommodityModel.h"

@implementation REMCommodityModel

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.uomId = dictionary[@"Id"];
    self.name = dictionary[@"Name"];
    self.code = dictionary[@"Code"];
    self.comment = dictionary[@"Comment"];
}

@end
