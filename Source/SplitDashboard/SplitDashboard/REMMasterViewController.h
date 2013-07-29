//
//  REMMasterViewController.h
//  SplitDashboard
//
//  Created by TanTan on 6/19/13.
//  Copyright (c) 2013 TanTan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class REMDetailViewController;

@interface REMMasterViewController : UITableViewController<UISplitViewControllerDelegate>

@property (strong, nonatomic) REMDetailViewController *detailViewController;

- (void) hideMaster:(BOOL)state;

@end
