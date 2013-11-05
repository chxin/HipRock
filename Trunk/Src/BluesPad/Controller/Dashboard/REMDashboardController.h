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


const static CGFloat kDashboardDragTitleSize=17;
const static CGFloat kDashboardDragTitleMargin=-29;

const static CGFloat kDashboardTitleSize=16;
const static CGFloat kDashboardTitleBottomMargin=14;
const static CGFloat kDashboardWidgetWidth=233;
const static CGFloat kDashboardWidgetHeight=157;
const static CGFloat kDashboardWidgetInnerVerticalMargin=15;
const static CGFloat kDashboardWidgetInnerHorizonalMargin=14;
const static CGFloat kDashboardWidgetPadding=6;
const static CGFloat kDashboardInnerMargin=43;
const static CGFloat kDashboardTitleShareMargin=7;
const static CGFloat kDashboardShareSize=11;


const static CGFloat kDashboardWidgetTitleTopMargin=9;
const static CGFloat kDashboardWidgetTimeTopMargin=9;
const static CGFloat kDashboardWidgetTitleSize=13;
const static CGFloat kDashboardWidgetTimeSize=11;
const static CGFloat kDashboardWidgetShareSize=11;
const static CGFloat kDashboardWidgetChartTopMargin=9;
const static CGFloat kDashboardWidgetChartWidth=222;
const static CGFloat kDashboardWidgetChartHeight=104-6;

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
