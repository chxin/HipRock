/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMGalleryCollectionCell.h
 * Created      : 张 锋 on 9/30/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMBuildingModel.h"
#import "REMGalleryCollectionViewController.h"

@interface REMGalleryCollectionCell : UICollectionViewCell

@property (nonatomic,weak) REMGalleryCollectionViewController *controller;
@property (nonatomic,weak) REMBuildingModel *building;

@property (nonatomic,weak) UIButton *backgroundButton;
@property (nonatomic,weak) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *snapshot;

-(void)beginPinch;
-(void)endPinch;
-(UIImage *)resizeImageForCell:(UIImage *)image;




@end
