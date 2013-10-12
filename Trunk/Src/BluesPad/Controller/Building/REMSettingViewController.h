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
#import "REMMainNavigationController.h"

@interface REMSettingViewController : UITableViewController<UIAlertViewDelegate>

@property (nonatomic,strong) REMMainNavigationController *mainNavigationController;
@property (nonatomic,strong) UISwitch *weiboAccoutSwitcher;

-(void)logoutAndClearCache;

- (void) needReload;

@end
