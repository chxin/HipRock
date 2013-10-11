//
//  REMDashboardControllerViewController.h
//  Blues
//
//  Created by tantan on 9/25/13.
//
//

#import <UIKit/UIKit.h>
#import "REMDashboardCellViewCell.h"
#import "REMDashboardView.h"
#import "REMDashboardObj.h"
#import "REMImageView.h"

@class REMImageView;

@interface REMDashboardController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,weak) NSArray *dashboardArray;
@property (nonatomic) CGRect viewFrame;
@property (nonatomic,weak) REMImageView *imageView;

@property (nonatomic,weak) REMBuildingOverallModel *buildingInfo;


@end
