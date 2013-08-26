//
//  REMBuildingModel.m
//  Blues
//
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
}

@end
