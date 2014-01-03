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

@interface REMGalleryGroupView()

@property (nonatomic,weak) UILabel *titleLabel;

@end

@implementation REMGalleryGroupView


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.layer.borderColor = [UIColor purpleColor].CGColor;
        self.layer.borderWidth = 1.0;
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
//        self.layer.borderColor = [UIColor orangeColor].CGColor;
//        self.layer.borderWidth = 1.0;
    }
    
    return self;
}


-(void)setGroupTitle:(NSString *)title
{
//    if(title==nil || [title isEqual:[NSNull null]]){
//        title = @"其他";
//    }
    
    if(self.titleLabel == nil){
        UIFont *font = [UIFont systemFontOfSize:kDMGallery_GalleryGroupTitleFontSize];
        CGSize titleSize = [title sizeWithFont:font];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDMGallery_GalleryGroupViewWidth, titleSize.height)];
        label.backgroundColor = [UIColor clearColor];
        label.font = font;
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = kDMGallery_GalleryGroupTitleFontColor;
        
        [self.contentView addSubview:label];
        self.titleLabel = label;
    }
    
    self.titleLabel.text = title;
}


-(void)setCollectionView:(UIView *)collectionView
{
    for(id view in self.contentView.subviews){
        if ([view isEqual:self.titleLabel] == NO)
            [view removeFromSuperview];
    }
    
    [self.contentView addSubview:collectionView];
}

@end
