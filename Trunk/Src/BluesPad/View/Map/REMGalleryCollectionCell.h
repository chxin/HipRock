//
//  REMGalleryCollectionCell.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 9/30/13.
//
//

#import <UIKit/UIKit.h>
#import "REMBuildingModel.h"
#import "REMGalleryCollectionViewController.h"

@interface REMGalleryCollectionCell : UICollectionViewCell

@property (nonatomic,weak) REMGalleryCollectionViewController *controller;
@property (nonatomic,weak) REMBuildingModel *building;

@property (nonatomic,weak) UILabel *titleLabel;

@property (nonatomic,weak) UIImageView *snapshot;
@property (nonatomic,weak) UIView *blackCover;


@end
