//
//  REMLoginCustomerViewController.h
//  Blues
//
//  Created by 张 锋 on 9/25/13.
//
//

#import <UIKit/UIKit.h>
#import "REMLoginPageController.h"

@interface REMLoginCustomerViewController : UITableViewController

@property (nonatomic,strong) REMLoginPageController *loginPageController;
- (IBAction)cancelButtonPressed:(id)sender;

@end
