//
//  REMDashboardControllerViewController.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 9/25/13.
//
//

#import <UIKit/UIKit.h>
#import "REMDashboardCellViewCell.h"
#import "REMDashboardView.h"
#import "REMDashboardObj.h"
#import "REMImageView.h"

@class REMImageView;
@class REMBuildingViewController;
@class REMDashboardController;


@interface REMDashboardController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,weak) NSArray *dashboardArray;
@property (nonatomic) CGRect viewFrame;
@property (nonatomic,weak) REMImageView *imageView;

@property (nonatomic,weak) REMBuildingOverallModel *buildingInfo;

-(void)cancelAllRequest;

- (void) maxWidget;

@property (nonatomic) NSUInteger currentMaxDashboardIndex;
@property (nonatomic,copy) NSNumber *currentMaxDashboardId;


@property (nonatomic,weak) UIView *readyToMaxCell;

@property (nonatomic,weak) REMBuildingViewController *buildingController;


@end
