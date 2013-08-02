//
//  REMEnergyError.m
//  Blues
//
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
