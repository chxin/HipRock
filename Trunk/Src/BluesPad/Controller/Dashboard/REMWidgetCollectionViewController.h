//
//  REMWidgetCollectionViewController.h
//  Blues
//
//  Created by tantan on 9/27/13.
//
//

#import <UIKit/UIKit.h>
#import "REMDashboardCollectionView.h"
#import "REMDashboardCollectionCellView.h"
#import "REMBuildingViewController.h"

@class REMDashboardCollectionCellView;
@class REMBuildingViewController;

@interface REMWidgetCollectionViewController : UICollectionViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (nonatomic) CGRect viewFrame;

@property (nonatomic,weak) NSArray *widgetArray;

@property (nonatomic,strong) NSString *groupName;

- (void)maxWidget:(REMDashboardCollectionCellView *)cell;

@property (nonatomic,weak) REMDashboardCollectionCellView *readyToMaxCell;

@property (nonatomic,weak) REMBuildingViewController *buildingController;

@end
