//
//  REMLoginCustomerSelectViewController.h
//  Blues
//
//  Created by zhangfeng on 7/2/13.
//
//

#import <UIKit/UIKit.h>
#import "REMLoginViewController.h"

@interface REMLoginCustomerViewController : UIViewController

@property (nonatomic,weak) REMLoginViewController *loginViewController;
@property (nonatomic,weak) IBOutlet UIButton *customerListButton;
@property (nonatomic,weak) IBOutlet UILabel *userNameLabel;

- (IBAction)doneTouchDown:(id)sender;
- (void)setSelectedCustomerName:(NSString *)customerName;
@end
