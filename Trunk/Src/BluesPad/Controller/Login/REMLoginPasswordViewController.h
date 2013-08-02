//
//  REMLoginPasswordViewController.h
//  Blues
//
//  Created by zhangfeng on 7/2/13.
//
//

#import <UIKit/UIKit.h>
#import "REMLoginViewController.h"

@interface REMLoginPasswordViewController : UIViewController

@property (nonatomic,strong) REMLoginViewController *loginViewController;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextBox;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextBox;
@property (weak, nonatomic) IBOutlet UIImageView *errorImage;

- (IBAction)viewTouchDown:(id)sender;
- (IBAction)forgotPasswordButtonTouchDown:(id)sender;
- (IBAction)loginButtonTouchDown:(id)sender;
@end
