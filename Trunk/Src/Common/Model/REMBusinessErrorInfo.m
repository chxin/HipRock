//
//  REMBusinessError.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 9/5/13.
//
//

#import "REMBusinessErrorInfo.h"

@implementation REMBusinessErrorInfo

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    if(dictionary[@"error"] == nil || [dictionary[@"error"] isEqual:[NSNull null]])
        return;
    
    dictionary = dictionary[@"error"];
    
    self.code = dictionary[@"Code"];
    
    if(dictionary[@"Messages"]!=nil && [dictionary[@"Messages"] isEqual:[NSNull null]] == NO){
        NSMutableArray *messages = [[NSMutableArray alloc] init];
        for (NSString *message in (NSArray *)dictionary[@"Messages"]) {
            [messages addObject:message];
        }
        self.messages = messages;
    }
}
@end
