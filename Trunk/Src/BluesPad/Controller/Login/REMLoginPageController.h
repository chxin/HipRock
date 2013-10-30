//
//  REMLoginPageController.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 7/26/13.
//
//

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
