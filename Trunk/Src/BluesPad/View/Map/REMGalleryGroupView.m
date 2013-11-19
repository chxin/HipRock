/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMGalleryGroupCell.m
 * Created      : 张 锋 on 10/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMGalleryGroupView.h"
#import "REMDimensions.h"
#import <QuartzCore/QuartzCore.h>

@implementation REMGalleryGroupView


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
//        self.layer.borderColor = [UIColor purpleColor].CGColor;
//        self.layer.borderWidth = 1.0;
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        
        //background view
//        self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
//        self.backgroundView.backgroundColor = [UIColor clearColor];
//        self.backgroundView.layer.borderWidth = 1;
//        self.backgroundView.layer.borderColor = [UIColor redColor].CGColor;
        
        //accessory view
        self.accessoryView = nil;
        
        //content view
        //self.contentMode = UIViewContentModeScaleToFill;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.clipsToBounds = NO;
    }
    
    return self;
}


-(void)setGroupTitle:(NSString *)title
{
    if(title==nil || [title isEqual:[NSNull null]]){
        title = @"其他";
    }
    
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:kDMGallery_GalleryGroupTitleFontSize]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)];
    label.text = title;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:kDMGallery_GalleryGroupTitleFontSize];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = kDMGallery_GalleryGroupTitleFontColor;
    
    [self.contentView addSubview:label];
    
}


-(void)setCollectionView:(UICollectionView *)collectionView
{
    [self.contentView addSubview:collectionView];
}

@end
