/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetDetailViewController.h
 * Created      : tantan on 10/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMEnergyViewData.h"
#import "REMEnum.h"
#import "REMManagedPinnedWidgetModel.h"
#import "REMManagedBuildingModel.h"
#import "REMManagedWidgetModel.h"
@interface REMWidgetDetailViewController : UIViewController<UIPopoverControllerDelegate>

@property (nonatomic,weak) REMManagedWidgetModel *widgetInfo;
@property (nonatomic,weak) REMEnergyViewData *energyData;
@property (nonatomic,weak) UIView *titleContainer;
@property (nonatomic,weak) REMManagedBuildingModel *buildingInfo;
@property (nonatomic,weak) REMManagedDashboardModel *dashboardInfo;
@property (nonatomic,strong) REMBusinessErrorInfo *serverError;
@property (nonatomic) BOOL isServerTimeout;
- (void)showChart;
-(void)releaseChart;
-(void)updateBuildingCover;
@end
