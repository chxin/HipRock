/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingCoverWidgetViewController.h
 * Date Created : tantan on 12/27/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "REMBuildingOverallModel.h"
#import "REMBuildingCommodityViewController.h"  
#import "REMManagedBuildingCommodityUsageModel.h"
#import "REMManagedDashboardModel.h"
#import "REMManagedWidgetModel.h"
#import "REMBuildingCoverWidgetRelationModel.h"
@interface REMBuildingCoverWidgetViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UIPopoverController *popController;
@property (nonatomic,weak) REMManagedBuildingModel *buildingInfo;

@property (nonatomic,strong) NSArray *dashboardArray;

@property (nonatomic,strong) NSDictionary *widgetDic;


@property (nonatomic,weak) REMManagedBuildingCommodityUsageModel *commodityInfo;

@property (nonatomic) REMBuildingCoverWidgetPosition position;

@property (nonatomic,copy) NSNumber *selectedWidgetId;

@property (nonatomic,copy) NSNumber *selectedDashboardId;

@property (nonatomic,weak) REMBuildingCommodityViewController *commodityController;

@property (nonatomic) BOOL isRequesting;

@end
