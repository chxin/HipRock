/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMGalleryViewController.h
 * Created      : 张 锋 on 9/30/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMMapViewController.h"
#import "REMControllerBase.h"
#import "REMGalleryCollectionCell.h"

@interface REMGalleryViewController : REMControllerBase<UITableViewDataSource, UITableViewDelegate>

#pragma mark - Properties
@property (nonatomic,weak) NSArray *buildingInfoArray;
@property (nonatomic) int currentBuildingIndex;

@property (nonatomic) CGRect initialZoomRect;
@property (nonatomic,strong) UIImageView *snapshot;
@property (nonatomic,weak) REMGalleryCollectionCell *focusedCell;

#pragma mark - Methods
-(void)presentBuildingViewFromCell:(REMGalleryCollectionCell *)cell animated:(BOOL)isNoAnimation;

-(CGRect)getDestinationZoomRect:(int)currentBuildingIndex;
-(void)takeSnapshot;
-(REMGalleryCollectionCell *)galleryCellForBuildingIndex:(int)buildingIndex;

@end
