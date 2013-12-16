/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMShareInfo.h
 * Created      : tantan on 9/24/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMJSONObject.h"
#import "REMUserModel.h"

@interface REMShareInfo : REMJSONObject

@property (nonatomic,strong) NSString *userRealName;
@property (nonatomic,strong) NSString *userTelephone;
@property (nonatomic,strong) NSDate *shareTime;
@property (nonatomic) REMUserTitleType userTitle;
@property  (nonatomic,strong) NSString *userTitleComponent;

@end
