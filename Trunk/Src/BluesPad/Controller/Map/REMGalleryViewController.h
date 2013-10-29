//
//  REMGalleryViewController.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 9/30/13.
//
//

#import <UIKit/UIKit.h>
#import "REMGalleryCollectionView.h"
#import "REMMapViewController.h"
@class REMGalleryCollectionCell;

@interface REMGalleryViewController : UICollectionViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

@property (nonatomic,strong) NSArray *buildingInfoArray;
@property (nonatomic,weak) REMMapViewController *mapViewController;
@property (nonatomic,weak) REMSplashScreenController *splashScreenController;

@property (nonatomic,strong) UIImageView *snapshot;
@property (nonatomic) CGRect initialZoomRect;

@property (nonatomic,strong) REMBuildingModel *selectedBuilding;

- (void)galleryCellTapped:(REMGalleryCollectionCell *)cell;
-(void)galleryCellPinched:(REMGalleryCollectionCell *)cell :(UIPinchGestureRecognizer *)pinch;

@end
