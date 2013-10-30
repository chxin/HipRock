//
//  REMDashboardCellViewCell.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 9/25/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "REMDashboardObj.h"
#import "REMWidgetCollectionViewController.h"

@class REMBuildingViewController;

@interface REMDashboardCellViewCell : UITableViewCell

- (void)initWidgetCollection:(REMDashboardObj *)dashboardInfo withGroupName:(NSString *)groupName;

@property (nonatomic,weak) REMBuildingViewController *buildingController;

@end
