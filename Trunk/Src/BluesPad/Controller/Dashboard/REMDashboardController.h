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
@class REMBuildingViewController;

@interface REMDashboardController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,weak) NSArray *dashboardArray;
@property (nonatomic) CGRect viewFrame;
@property (nonatomic,weak) REMImageView *imageView;

@property (nonatomic,weak) REMBuildingOverallModel *buildingInfo;

-(void)cancelAllRequest;

@property (nonatomic,weak) REMBuildingViewController *buildingController;


@end
