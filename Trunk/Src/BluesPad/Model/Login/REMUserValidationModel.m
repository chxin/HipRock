//
//  REMUserValidationModel.m
//  Blues
//
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
