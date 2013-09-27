//
//  REMDashboardRootViewController.h
//  Blues
//
//  Created by TanTan on 7/12/13.
//
//

#import <UIKit/UIKit.h>
#import "REMDashboardObj.h"
#import "REMDashboardViewController.h"
@class REMMainDashboardViewController;

@class  REMMainViewController;

@interface REMDashboardRootViewController : UIViewController

@property (nonatomic,weak) REMMainDashboardViewController *mainController;

- (void) goDashboard:(REMDashboardObj *)dashboard;

- (void) backThenGoDashboard:(REMDashboardObj *)dashboard;

@end
