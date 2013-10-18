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
@property (nonatomic,strong, setter = setBuildingModel:, getter = getBuildingModel) REMBuildingModel *building;
@property (nonatomic,strong, setter = setBackgroundImage:) UIImage *backgroundImage;

-(void)setBuildingModel:(REMBuildingModel *)model;
-(REMBuildingModel *)getBuildingModel;

-(void)setBackgroundImage:(UIImage *)image;

@end
