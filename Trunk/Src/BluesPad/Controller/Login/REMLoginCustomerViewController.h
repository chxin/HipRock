//
//  REMLoginCustomerViewController.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 9/25/13.
//
//

#import <UIKit/UIKit.h>
#import "REMLoginPageController.h"

@interface REMLoginCustomerViewController : UITableViewController

@property (nonatomic,strong) REMLoginPageController *loginPageController;
- (IBAction)cancelButtonPressed:(id)sender;

@end
