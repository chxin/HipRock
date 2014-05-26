/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMUomModel.m
 * Created      : 张 锋 on 8/1/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
