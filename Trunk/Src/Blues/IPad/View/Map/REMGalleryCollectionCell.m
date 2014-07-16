/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMGalleryCollectionCell.m
 * Created      : 张 锋 on 9/30/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMGalleryCollectionCell.h"
#import <QuartzCore/QuartzCore.h>
#import "REMDimensions.h"
#import "REMCommonHeaders.h"

@interface REMGalleryCollectionCell ()

//@property (nonatomic,weak) UIView *cover;

@end


@implementation REMGalleryCollectionCell{
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundView = [[UIImageView alloc] initWithFrame:kDMGallery_GalleryCellFrame];
//        self.layer.borderColor = [UIColor orangeColor].CGColor;
//        self.layer.borderWidth = 1.0;
        
        
        
        
        UIImage *image= REMIMG_DefaultBuilding_Small;
        
        
        UIButton *button = [[UIButton alloc] initWithFrame:self.bounds];
        [button setImage:image forState:UIControlStateNormal];
        button.imageView.contentMode = UIViewContentModeTop;
        button.contentMode = UIViewContentModeScaleToFill;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        button.contentVerticalAlignment = UIControlContentHorizontalAlignmentFill;
        button.exclusiveTouch = YES;
        [button addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        self.backgroundButton = button;
        
        UIFont *labelFont = [REMFont defaultFontOfSize:kDMGallery_GalleryCellTitleFontSize];
        CGSize labelSize = [@"a" sizeWithFont:labelFont];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kDMGallery_GalleryCellTitleLeftOffset, kDMGallery_GalleryCellTitleTopOffset, kDMGallery_GalleryCellWidth - kDMGallery_GalleryCellTitleLeftOffset - kDMGallery_GalleryCellTitleRightOffset, labelSize.height)];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = labelFont;
        
        [self.backgroundButton addSubview:label];
        self.titleLabel = label;
        
//        [self.backgroundButton addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundButton attribute:NSLayoutAttributeLeft multiplier:1.0 constant:kDMGallery_GalleryCellTitleLeftOffset]];
//        [self.backgroundButton addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundButton attribute:NSLayoutAttributeRight multiplier:1.0 constant:kDMGallery_GalleryCellTitleRightOffset]];
//        [self.backgroundButton addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundButton attribute:NSLayoutAttributeTop multiplier:1.0 constant:kDMGallery_GalleryCellTitleTopOffset]];
        
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinching:)];
        [self addGestureRecognizer:pinchRecognizer];
        
        //UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptest:)];
        //[self addGestureRecognizer:tapRecognizer];
    }
    
    return self;
}

-(void)pressed:(id)button
{
    [self.controller galleryCellTapped:self];
}

-(void)pinching:(UIPinchGestureRecognizer *)pinchRecognizer
{
    [self.controller galleryCellPinched:self :pinchRecognizer];
}


-(void)beginPinch
{
    //add and set snapshot
    self.snapshot = [[UIImageView alloc] initWithImage:[REMImageHelper imageWithView:self]];
    
    //add black cover
    [self setHidden:YES];
}

-(void)endPinch
{
    [self setHidden:NO];
    
    [self.snapshot removeFromSuperview];
    self.snapshot = nil;
}


-(UIImage *)resizeImageForCell:(UIImage *)image
{
    CGSize size = CGSizeMake(2*kDMGallery_GalleryCellWidth * kDMCommon_ImageScale, 2*kDMGallery_GalleryCellHeight * kDMCommon_ImageScale);
    
    //resize image to cell size * factor
    UIImage *resized = [REMImageHelper scaleImage:image toSize:size];
    
    //return resized;
    
    //crop image
    CGRect rect = CGRectMake((size.width - 2*kDMGallery_GalleryCellWidth)/2, 0, 2*kDMGallery_GalleryCellWidth, 2*kDMGallery_GalleryCellHeight);
    
    return [REMImageHelper cropImage:resized toRect:rect];
}


@end
