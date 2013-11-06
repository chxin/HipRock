/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMShareInfo.m
 * Created      : tantan on 9/24/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMShareInfo.h"
#import "REMTimeHelper.h"

@implementation REMShareInfo

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary{
    self.userRealName=dictionary[@"UserRealName"];
    
    self.userTelephone=dictionary[@"UserTelephone"];
    NSString *time = dictionary[@"ShareTime"];
    long long longTime=[REMTimeHelper longLongFromJSONString:time];
    if (longTime==0) {
        self.shareTime=nil;
    }
    else{
        self.shareTime=[NSDate dateWithTimeIntervalSince1970:longTime];
    }
    NSNumber *userTitle=dictionary[@"UserTitle"];
    self.userTitle = (REMUserTitleType)[userTitle integerValue];
}

@end
