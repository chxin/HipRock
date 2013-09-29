//
//  REMDashboardCellViewCell.h
//  Blues
//
//  Created by tantan on 9/25/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "REMDashboardObj.h"
#import "REMWidgetCollectionViewController.h"

@interface REMDashboardCellViewCell : UITableViewCell

- (void)initWidgetCollection:(REMDashboardObj *)dashboardInfo;

@end
