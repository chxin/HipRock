//
//  REMSettingCustomerSelectionViewController.h
//  Blues
//
//  Created by tantan on 9/29/13.
//
//

#import <UIKit/UIKit.h>
#import "REMSplashScreenController.h"
#import "REMBuildingSettingViewController.h"
@interface REMSettingCustomerSelectionViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

- (IBAction)switchCustomer:(UIBarButtonItem *)sender;

@property (nonatomic,weak) REMSplashScreenController *splashController;
@property (nonatomic,weak) UINavigationController *parentNavigationController;
@property (nonatomic,weak) REMBuildingSettingViewController *settingController;

@end
