//
//  REMSettingCustomerSelectionViewController.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 9/29/13.
//
//

#import <UIKit/UIKit.h>
#import "REMSplashScreenController.h"
#import "REMSettingViewController.h"
@interface REMSettingCustomerSelectionViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

- (IBAction)switchCustomer:(UIBarButtonItem *)sender;

@property (nonatomic,weak) UINavigationController *parentNavigationController;
@property (nonatomic,weak) REMSettingViewController *settingController;

@end
