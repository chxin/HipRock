//
//  REMBuildingModel.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 8/1/13.
//
//

#import "REMBuildingModel.h"

@implementation REMBuildingModel

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.buildingId = dictionary[@"Id"];
    self.parentId = dictionary[@"ParentId"];
    self.timezoneId = dictionary[@"TimezoneId"];
    self.customerId = dictionary[@"CustomerId"];
    self.name = dictionary[@"Name"];
    self.code = dictionary[@"Code"];
    self.comment = dictionary[@"Comment"];
    self.path = dictionary[@"Path"];
    self.pathLevel = [dictionary[@"PathLevel"] intValue];
    self.hasDataPrivilege = [dictionary[@"HasDataPrivilege"] boolValue];
    self.pictureIds=dictionary[@"PictureIds"];
    self.latitude = [dictionary[@"Latitude"] doubleValue];
    self.longitude = [dictionary[@"Longitude"] doubleValue];
    self.province = dictionary[@"Province"];
}

@end
