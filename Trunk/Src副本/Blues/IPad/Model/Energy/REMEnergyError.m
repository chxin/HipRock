/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEnergyError.m
 * Created      : 谭 坦 on 7/16/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMEnergyError.h"

@implementation REMEnergyError

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.errorCode = dictionary[@"ErrorCode"];
    
    self.params = dictionary[@"Params"];
}

@end
