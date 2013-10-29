//
//  REMGalleryCollectionCell.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 9/30/13.
//
//

#import <UIKit/UIKit.h>
#import "REMBuildingModel.h"
#import "REMGalleryViewController.h"

@interface REMGalleryCollectionCell : UICollectionViewCell

@property (nonatomic,weak) REMGalleryViewController *controller;
@property (nonatomic,weak, setter = setBuildingModel:, getter = getBuildingModel) REMBuildingModel *building;
@property (nonatomic,strong, setter = setBackgroundImage:) UIImage *backgroundImage;

@property (nonatomic,weak) UIImageView *snapshot;
@property (nonatomic,weak) UIView *blackCover;

-(void)setBuildingModel:(REMBuildingModel *)model;
-(REMBuildingModel *)getBuildingModel;

-(void)setBackgroundImage:(UIImage *)image;

@end
