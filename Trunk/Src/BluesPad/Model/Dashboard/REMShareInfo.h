//
//  REMShareInfo.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 9/24/13.
//
//

#import "REMJSONObject.h"
#import "REMUserModel.h"

@interface REMShareInfo : REMJSONObject

@property (nonatomic,strong) NSString *userRealName;
@property (nonatomic,strong) NSString *userTelephone;
@property (nonatomic,strong) NSDate *shareTime;
@property (nonatomic) REMUserTitleType userTitle;

@end
