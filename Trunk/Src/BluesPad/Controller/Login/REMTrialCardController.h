/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTrialCardController.h
 * Date Created : 张 锋 on 11/24/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "REMLoginCarouselController.h"
#import "REMLoginButton.h"

@interface REMTrialCardController : UIViewController/*<UITextFieldDelegate>*/

@property (nonatomic,weak) REMLoginCarouselController *loginCarouselController;

@property (nonatomic,weak) REMLoginButton *trialButton;

@end
