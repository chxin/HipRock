//
//  REMEnergyError.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 谭 坦 on 7/16/13.
//
//

#import "REMEnergyError.h"

@implementation REMEnergyError

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.errorCode = dictionary[@"ErrorCode"];
    
    self.params = dictionary[@"Params"];
}

@end
