/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBusinessError.m
 * Created      : 张 锋 on 9/5/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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

-(BOOL)matchesErrorCode:(NSString *)errorCode
{
    //@"0500 0021 6002"
    if(errorCode.length != 12)
        return NO;
    
    REMBusinessErrorInfo *temp = [[REMBusinessErrorInfo alloc] init];
    temp.code = errorCode;
    
    return temp.errorType == self.errorType && temp.layer == self.layer && temp.module == self.module && temp.detailCode == self.detailCode;
}

-(int) errorType
{
    return [[self.code substringToIndex:2] intValue];
}
-(int) serverId
{
    return [[self.code substringWithRange:NSMakeRange(2,4)] intValue];
}
-(int) layer
{
    return [[self.code substringWithRange:NSMakeRange(6,1)] intValue];
}
-(int) module
{
    return [[self.code substringWithRange:NSMakeRange(7,2)] intValue];
}
-(int) detailCode
{
    return [[self.code substringWithRange:NSMakeRange(9,3)] intValue];
}


@end
