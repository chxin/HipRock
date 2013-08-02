//
//  REMDashboardViewController.h
//  Blues
//
//  Created by TanTan on 7/1/13.
//
//

#import <UIKit/UIKit.h>
#import "REMWidgetCell.h"
#import "REMAppDelegate.h"
#import "REMDataAccessor.h"
#import "REMFavoriteDashboardObj.h"
#import "REMEnergyViewData.h"
#import "REMMainViewController.h"

@class REMWidgetCell;
@class REMMainViewController;


@interface REMDashboardViewController : UICollectionViewController<UICollectionViewDataSource>

@property (nonatomic,strong) REMDashboardObj *dashboard;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

- (void) showMaxWidgetByCell:(REMWidgetObject *)widget WithData:(REMEnergyViewData *)data;

@property (nonatomic,weak) REMMainViewController *mainController;

@end
