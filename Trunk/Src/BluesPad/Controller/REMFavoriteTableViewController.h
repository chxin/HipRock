//
//  REMFavoriteTableViewController.h
//  Blues
//
//  Created by TanTan on 7/8/13.
//
//

#import <UIKit/UIKit.h>
#import "REMDashboardMainViewController.h"
#import "REMDashboardObj.h"

@interface REMFavoriteTableViewController : UITableViewController<UITableViewDataSource>
@property (nonatomic,strong) NSArray *favoriteList;
@end
