//
//  REMShareInfo.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 9/24/13.
//
//

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
