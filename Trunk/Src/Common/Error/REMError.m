//
//  REMError.m
//  Blues
//
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
