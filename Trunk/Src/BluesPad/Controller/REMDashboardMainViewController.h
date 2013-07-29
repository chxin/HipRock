//
//  REMDashboardMainViewController.h
//  Blues
//
//  Created by TanTan on 7/8/13.
//
//

#import <UIKit/UIKit.h>
#import "REMMainViewController.h"
#import "REMDashboardObj.h"
#import "REMFavoriteTableViewController.h"
#import "REMDashboardRootViewController.h"
#import "REMDashboardLeftNavigationController.h"

@class REMMainViewController;

@interface REMDashboardMainViewController : UIViewController

-(void)showDashboard:(REMDashboardObj *)dashboard;
@property (weak, nonatomic) IBOutlet UIView *widgetsContainer;
@property (weak, nonatomic) IBOutlet UIView *dashboardListContainer;
@property  (weak,nonatomic) NSArray *favoriteDashboard;
@property   (weak,nonatomic) REMMainViewController  *mainController;
@end
