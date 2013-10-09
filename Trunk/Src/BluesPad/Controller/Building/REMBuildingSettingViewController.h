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

@property (nonatomic,weak) REMSplashScreenController *splashScreenController;

@property (nonatomic,weak) UINavigationController *parentNavigationController;
@property (nonatomic,strong) UISwitch *weiboAccoutSwitcher;

-(void)logoutAndClearCache;

@end
