//
//  REMUserValidationModel.h
//  Blues
//
//  Created by 张 锋 on 8/2/13.
//
//

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
