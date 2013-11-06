/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMLoginPageController.h
 * Created      : 张 锋 on 7/26/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMLoginCarouselController.h"
#import "REMIndicatorButton.h"

@interface REMLoginPageController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *userNameErrorLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordErrorLabel;
@property (weak, nonatomic) IBOutlet REMIndicatorButton *loginButton;

@property (nonatomic,strong) REMLoginCarouselController *loginCarouselController;


- (IBAction)loginButtonPressed:(id)sender;

- (IBAction)textFieldChanged:(id)sender;
//- (IBAction)passwordTextChanged:(id)sender;

-(void)loginSuccess;

@end
