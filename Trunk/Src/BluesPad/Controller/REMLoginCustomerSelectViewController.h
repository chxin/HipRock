//
//  REMCustomerSelectViewController.h
//  Blues
//
//  Created by zhangfeng on 7/3/13.
//
//

#import <UIKit/UIKit.h>
#import "REMLoginCustomerViewController.h"

@interface REMLoginCustomerSelectViewController : UITableViewController

@property (nonatomic,weak) REMLoginCustomerViewController *customerViewController;
@property (nonatomic,weak) UIPopoverController *popoverViewController;

@property (nonatomic,retain) NSArray *customers;

@end
