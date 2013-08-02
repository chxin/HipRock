//
//  REMLoginPageController.h
//  Blues
//
//  Created by 张 锋 on 7/26/13.
//
//

#import <UIKit/UIKit.h>
#import "REMLoginCarouselController.h"

@interface REMLoginPageController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *userNameErrorLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordErrorLabel;

@property (nonatomic,strong) REMLoginCarouselController *loginCarouselController;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


- (IBAction)loginButtonPressed:(id)sender;

- (IBAction)textFieldChanged:(id)sender;
//- (IBAction)passwordTextChanged:(id)sender;

@end
