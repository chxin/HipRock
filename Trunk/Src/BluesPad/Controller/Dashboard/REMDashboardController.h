/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMDashboardControllerViewController.h
 * Created      : tantan on 9/25/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
const static CGFloat kDashboardTitleBottomMargin=10;
const static CGFloat kDashboardWidgetWidth=233+3;
const static CGFloat kDashboardWidgetHeight=157+4;
const static CGFloat kDashboardWidgetInnerVerticalMargin=10;
const static CGFloat kDashboardWidgetInnerHorizonalMargin=10;
const static CGFloat kDashboardWidgetPadding=6;
const static CGFloat kDashboardInnerMargin=30;
const static CGFloat kDashboardTitleShareMargin=3;
const static CGFloat kDashboardShareSize=11;


const static CGFloat kDashboardWidgetTitleTopMargin=8;
const static CGFloat kDashboardWidgetTimeTopMargin=5;
const static CGFloat kDashboardWidgetTitleSize=14;
const static CGFloat kDashboardWidgetTimeSize=11;
const static CGFloat kDashboardWidgetShareSize=11;
const static CGFloat kDashboardWidgetChartTopMargin=9;
const static CGFloat kDashboardWidgetChartWidth=222;
const static CGFloat kDashboardWidgetChartHeight=108;

@interface REMDashboardController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic) CGRect viewFrame;
@property (nonatomic) CGRect upViewFrame;

@property (nonatomic,weak) REMBuildingOverallModel *buildingInfo;

@property (nonatomic) CGFloat currentOffsetY;

-(void)cancelAllRequest;

- (void) maxWidget;

@property (nonatomic) NSUInteger currentMaxDashboardIndex;
@property (nonatomic,copy) NSNumber *currentMaxDashboardId;


@property (nonatomic,weak) UIView *readyToMaxCell;



@end
