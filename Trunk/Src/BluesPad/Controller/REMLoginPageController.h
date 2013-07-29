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

@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *errorImage;

@property (nonatomic,strong) REMLoginCarouselController *loginCarouselController;


- (IBAction)loginButtonPressed:(id)sender;


@end
