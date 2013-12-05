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
        self.backgroundView = [[UIImageView alloc] initWithFrame:kDMGallery_GalleryCellFrame];
        
        if(self.titleLabel == nil){
            UILabel *label = [[UILabel alloc] initWithFrame:kDMGallery_GalleryCellTitleFrame];
            self.titleLabel = label;
            self.titleLabel.textColor = [UIColor whiteColor];
            self.titleLabel.backgroundColor = [UIColor clearColor];
            self.titleLabel.font = [UIFont systemFontOfSize:kDMGallery_GalleryCellTitleFontSize];
            
            [self addSubview:self.titleLabel];
        }
        
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinching:)];
        [self addGestureRecognizer:pinchRecognizer];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:tapRecognizer];
    }
    
    return self;
}


-(void)tapped:(UITapGestureRecognizer *)tapRecognizer
{
//    if(tapRecognizer.state == UIGestureRecognizerStateBegan){
//        NSLog(@"tap begin");
//    }
//    if(tapRecognizer.state == UIGestureRecognizerStateEnded){
//        NSLog(@"tap end");
//    }
    
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
