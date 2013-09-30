//
//  REMAdministratorModel.m
//  Blues
//
//  Created by tantan on 9/30/13.
//
//

#import "REMAdministratorModel.h"

@implementation REMAdministratorModel

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.userId=dictionary[@"UserId"];
    self.realName=dictionary[@"RealName"];
}

@end
