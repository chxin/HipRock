//
//  REMError.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 9/5/13.
//
//

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
