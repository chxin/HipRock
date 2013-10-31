//
//  REMWidgetCollectionViewController.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 9/27/13.
//
//

#import <UIKit/UIKit.h>
#import "REMDashboardCollectionView.h"
#import "REMDashboardCollectionCellView.h"
#import "REMBuildingViewController.h"

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
