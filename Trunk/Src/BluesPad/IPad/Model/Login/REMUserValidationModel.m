/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMUserValidationModel.m
 * Created      : 张 锋 on 8/2/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMUserValidationModel.h"
#import "REMCommonHeaders.h"

@implementation REMUserValidationModel

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.user = [[REMUserModel alloc] initWithDictionary:dictionary[@"User"]];
    self.status = [dictionary[@"ValidationStatus"] intValue];
}

@end
