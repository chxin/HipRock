//
//  REMWidgetRelativeDateTableViewController.h
//  Blues
//
//  Created by 谭 坦 on 7/17/13.
//
//

#import <UIKit/UIKit.h>
#import "REMWidgetMaxViewController.h"
#import "REMEnergyConstants.h"

@class REMWidgetMaxViewController;


@interface REMWidgetRelativeDateTableViewController : UITableViewController<UITableViewDataSource>
@property (nonatomic,weak) UIPopoverController *popController;
@property (nonatomic,weak) REMWidgetMaxViewController *maxController;
@property (nonatomic,weak) NSString *relativeDataString;
@end
