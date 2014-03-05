/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMLoginButton.h
 * Date Created : 张 锋 on 11/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMIndicatorButton.h"

typedef enum _REMLoginButtonStatus : NSUInteger{
    REMLoginButtonNormalStatus = 1,
    REMLoginButtonDisableStatus = 2,
    REMLoginButtonWorkingStatus = 3,
} REMLoginButtonStatus;

@interface REMLoginButton : REMIndicatorButton

-(id)initWithFrame:(CGRect)frame andStatusTexts:(NSDictionary *)statusTexts;

-(void)setLoginButtonStatus:(REMLoginButtonStatus)status;

@end
