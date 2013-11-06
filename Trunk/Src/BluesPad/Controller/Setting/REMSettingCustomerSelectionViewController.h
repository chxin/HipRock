/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMSettingCustomerSelectionViewController.h
 * Created      : tantan on 9/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMSplashScreenController.h"
#import "REMSettingViewController.h"
@interface REMSettingCustomerSelectionViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

- (IBAction)switchCustomer:(UIBarButtonItem *)sender;

@property (nonatomic,weak) UINavigationController *parentNavigationController;
@property (nonatomic,weak) REMSettingViewController *settingController;

@end
