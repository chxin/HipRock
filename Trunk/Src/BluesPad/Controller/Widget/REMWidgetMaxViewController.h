/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetMaxViewController.h
 * Created      : TanTan on 7/1/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMWidgetCollectionViewController.h"
//#import "REMEnergyViewData.h"
//#import "REMWidgetObject.h"
//#import "REMWidgetMaxView.h"
//#import "REMColor.h"
//#import "REMWidgetMaxDiagramViewController.h"
//#import "REMWidgetMaxPieViewController.h"
//#import "REMWidgetRelativeDateTableViewController.h"
//#import "REMWidgetMaxLineViewController.h"
//#import "REMWidgetMaxColumnViewController.h"
//#import "REMWidgetTimePickerViewController.h"
//#import "REMWidgetStepToolbarView.h"

@interface REMWidgetMaxViewController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic,weak) REMDashboardObj *dashboardInfo;

@property (nonatomic,weak) REMWidgetCollectionViewController *widgetCollectionController;

@property (nonatomic) NSUInteger currentWidgetIndex;



- (void)popToBuildingCover;

@end
