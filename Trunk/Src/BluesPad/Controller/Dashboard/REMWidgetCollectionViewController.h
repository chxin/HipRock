/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetCollectionViewController.h
 * Created      : tantan on 9/27/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMDashboardCollectionView.h"
#import "REMDashboardCollectionCellView.h"
#import "REMBuildingViewController.h"
#import "REMDashboardController.h"

@class REMDashboardCollectionCellView;
@class REMBuildingViewController;
@class REMDashboardController;

@interface REMWidgetCollectionViewController : UICollectionViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (nonatomic) CGRect viewFrame;


@property (nonatomic,strong) NSString *groupName;

@property (nonatomic,weak) REMDashboardObj *dashboardInfo;

@property (nonatomic) NSUInteger currentMaxWidgetIndex;
@property (nonatomic,copy) NSNumber *currentMaxWidgetId;

@property (nonatomic) NSUInteger currentDashboardIndex;


- (void)maxWidget;

@end
