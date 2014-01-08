/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetDetailViewController.h
 * Created      : tantan on 10/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMWidgetObject.h"
#import "REMEnergyViewData.h"
#import "REMEnum.h"
#import "REMBuildingOverallModel.h"
#import "REMDashboardObj.h"


@interface REMWidgetDetailViewController : UIViewController<UIPopoverControllerDelegate>

@property (nonatomic,weak) REMWidgetObject *widgetInfo;
@property (nonatomic,weak) REMEnergyViewData *energyData;
@property (nonatomic,weak) UIView *titleContainer;
@property (nonatomic,weak) REMBuildingOverallModel *buildingInfo;
@property (nonatomic,weak) REMDashboardObj *dashboardInfo;

- (void)showChart;
-(void)releaseChart;
-(void)updateBuildingCover;
@end
