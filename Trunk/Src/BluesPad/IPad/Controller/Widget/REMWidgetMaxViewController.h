/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetMaxViewController.h
 * Created      : TanTan on 7/1/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMWidgetCollectionViewController.h"
#import "REMManagedBuildingModel.h"
#import "REMManagedDashboardModel.h"

@interface REMWidgetMaxViewController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic,weak) REMDashboardObj *dashboardInfo;

@property (nonatomic,weak) REMManagedBuildingModel *buildingInfo;

@property (nonatomic,weak) REMWidgetCollectionViewController *widgetCollectionController;

@property (nonatomic) NSUInteger currentWidgetIndex;

@property (nonatomic) CGFloat lastPageXPosition;


- (void)popToBuildingCover;

@end
