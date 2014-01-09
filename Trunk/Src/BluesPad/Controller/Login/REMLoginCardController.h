/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMLoginPageController.h
 * Created      : 张 锋 on 7/26/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
@class REMLoginCarouselController;
#import "REMLoginButton.h"

@interface REMLoginCardController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) REMLoginButton *loginButton;

@property (nonatomic,weak) REMLoginCarouselController *loginCarouselController;


-(void)loginSuccess;

@end
