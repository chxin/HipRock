//
//  REMGalleryCollectionCell.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 9/30/13.
//
//

#import "REMGalleryCollectionCell.h"
#import <QuartzCore/QuartzCore.h>
#import "REMDimensions.h"
#import "REMCommonHeaders.h"

@interface REMGalleryCollectionCell ()

@property (nonatomic,weak) UIView *cover;

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
    if(tapRecognizer.state == UIGestureRecognizerStateBegan){
        NSLog(@"tap begin");
    }
    if(tapRecognizer.state == UIGestureRecognizerStateEnded){
        NSLog(@"tap end");
    }
    
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
    [self coverMe];
}

-(void)endPinch
{
    [self uncoverMe];
    
    [self.snapshot removeFromSuperview];
    self.snapshot = nil;
}

-(void)coverMe
{
    UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
    coverView.backgroundColor = kDMGallery_BackgroundColor;
    
    self.cover = coverView;
    [self addSubview:self.cover];
}

-(void)uncoverMe
{
    [self.cover removeFromSuperview];
    self.cover = nil;
}

@end