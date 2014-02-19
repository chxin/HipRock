/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingSettingViewController.h
 * Created      : Zilong-Oscar.Xu on 8/22/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>

#import "REMSplashScreenController.h"
#import "REMUserModel.h"
#import "REMCustomerModel.h"
#import "REMCommonHeaders.h"
#import "REMMainNavigationController.h"

@interface REMSettingViewController : UITableViewController<UIAlertViewDelegate>

//@property (nonatomic,strong) REMMainNavigationController *mainNavigationController;
@property (nonatomic,weak) UISwitch *weiboAccoutSwitcher;

-(void)logoutAndClearCache;

- (void) needReload;

@end
