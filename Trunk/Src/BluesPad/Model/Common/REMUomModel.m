//
//  REMUomModel.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 8/1/13.
//
//

#import "REMUomModel.h"

@implementation REMUomModel

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.uomId = dictionary[@"Id"];
    self.name = dictionary[@"Name"];
    self.code = dictionary[@"Code"];
    self.comment = dictionary[@"Comment"];
}

@end
