/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMUserValidationModel.h
 * Created      : 张 锋 on 8/2/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMJSONObject.h"
#import "REMCommonHeaders.h"

typedef enum _REMUserValidationStatus : NSInteger{
    REMUserValidationSuccess = 1,
    REMUserValidationWrongName = 2,
    REMUserValidationWrongPassword = 3,
    REMUserValidationInvalidSp = 4,
} REMUserValidationStatus;

@interface REMUserValidationModel : REMJSONObject

@property (nonatomic,strong) REMUserModel *user;
@property (nonatomic) REMUserValidationStatus status;

@end
