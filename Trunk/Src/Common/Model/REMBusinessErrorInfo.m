//
//  REMBusinessError.m
//  Blues
//
//  Created by 张 锋 on 9/5/13.
//
//

#import "REMBusinessErrorInfo.h"

@implementation REMBusinessErrorInfo

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    dictionary = dictionary[@"error"];
    
    self.code = dictionary[@"Code"];
    
    NSMutableArray *messages = [[NSMutableArray alloc] init];
    for (NSString *message in (NSArray *)dictionary[@"Messages"]) {
        [messages addObject:message];
    }
    self.messages = messages;
}
@end
