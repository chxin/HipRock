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
        
        UIButton *button = [[UIButton alloc] initWithFrame:self.bounds];
        [button setImage:REMIMG_DefaultBuilding_Small forState:UIControlStateNormal];
        button.imageView.contentMode = UIViewContentModeScaleToFill;
        button.contentMode = UIViewContentModeScaleToFill;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.exclusiveTouch = YES;
        [button addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        self.backgroundButton = button;
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:kDMGallery_GalleryCellTitleFrame];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:kDMGallery_GalleryCellTitleFontSize];
        
        [self.backgroundButton addSubview:label];
        self.titleLabel = label;
        
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinching:)];
        [self addGestureRecognizer:pinchRecognizer];
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


@end
