/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMError.m
 * Created      : 张 锋 on 9/5/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMError.h"

@implementation REMError


-(REMError *)initWithErrorInfo:(REMBusinessErrorInfo *)errorInfo
{
    self = [super initWithDomain:@"REMBusinessError" code:1 userInfo:nil];
    if(self!=nil){
        self.errorInfo = errorInfo;
    }
    return self;
}


@end
