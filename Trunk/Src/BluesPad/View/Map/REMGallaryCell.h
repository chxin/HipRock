//
//  REMGallaryCell.h
//  Blues
//
//  Created by 张 锋 on 9/30/13.
//
//

#import <UIKit/UIKit.h>
#import "REMBuildingModel.h"
#import "REMGallaryViewController.h"

@interface REMGallaryCell : UICollectionViewCell

@property (nonatomic,weak) REMGallaryViewController *controller;
@property (nonatomic,weak, setter = setBuildingModel:, getter = getBuildingModel) REMBuildingModel *building;
@property (nonatomic,strong, setter = setBackgroundImage:) UIImage *backgroundImage;

@property (nonatomic,weak) UIImageView *snapshot;
@property (nonatomic,weak) UIView *blackCover;

-(void)setBuildingModel:(REMBuildingModel *)model;
-(REMBuildingModel *)getBuildingModel;

-(void)setBackgroundImage:(UIImage *)image;

@end
