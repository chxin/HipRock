//
//  REMBuildingSettingViewController.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 8/22/13.
//
//

#import <UIKit/UIKit.h>

#import "REMSplashScreenController.h"
#import "REMUserModel.h"
#import "REMCustomerModel.h"
#import "REMCommonHeaders.h"

@interface REMBuildingSettingViewController : UITableViewController<UIAlertViewDelegate>

@property (nonatomic,strong) REMSplashScreenController *splashScreenController;

@property (nonatomic,strong) UINavigationController *navigationController;
@property (nonatomic,strong) UISwitch *weiboAccoutSwitcher;

@end
