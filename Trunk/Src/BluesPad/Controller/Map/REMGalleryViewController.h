//
//  REMGalleryViewController.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 9/30/13.
//
//

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

#pragma mark - Methods
-(CGRect)getDestinationZoomRect:(int)currentBuildingIndex;
-(void)presentBuildingViewForBuilding:(REMBuildingModel *)building fromCell:(UICollectionViewCell *)cell;

@end
