//
//  REMUserValidationModel.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 8/2/13.
//
//

#import "REMUserValidationModel.h"
#import "REMCommonHeaders.h"

@implementation REMUserValidationModel

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.user = [[REMUserModel alloc] initWithDictionary:dictionary[@"User"]];
    self.status = [dictionary[@"ValidationStatus"] intValue];
}

@end
