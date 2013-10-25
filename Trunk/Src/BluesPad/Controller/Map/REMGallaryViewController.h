//
//  REMGallaryViewController.h
//  Blues
//
//  Created by 张 锋 on 9/30/13.
//
//

#import <UIKit/UIKit.h>
#import "REMGallaryView.h"
#import "REMMapViewController.h"
@class REMGallaryCell;

@interface REMGallaryViewController : UICollectionViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

@property (nonatomic,strong) NSArray *buildingInfoArray;
@property (nonatomic,weak) REMMapViewController *mapViewController;
@property (nonatomic,weak) REMSplashScreenController *splashScreenController;

@property (nonatomic,strong) UIImageView *snapshot;
@property (nonatomic) CGRect initialZoomRect;

@property (nonatomic,strong) REMBuildingModel *selectedBuilding;

- (void)gallaryCellTapped:(REMGallaryCell *)cell;
-(void)gallaryCellPinched:(REMGallaryCell *)cell :(UIPinchGestureRecognizer *)pinch;

@end
