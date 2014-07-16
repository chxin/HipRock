/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMCustomerLogoView.m
 * Date Created : 张 锋 on 5/8/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMCustomerLogoView.h"
#import "REMCommonHeaders.h"

@implementation REMCustomerLogoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *logo = [UIImage imageWithData:REMAppContext.currentCustomer.logoImage];
        UIImageView *innerView = [[UIImageView alloc] initWithFrame:[self calculateInnerViewFrame:logo.size]];
        innerView.image = logo;
        innerView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:innerView];
        
        UITapGestureRecognizer *tapRecognizer =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

-(void)tapped:(UITapGestureRecognizer *)tapRecognizer
{
    if(tapRecognizer.state == UIGestureRecognizerStateEnded && self.delegate != nil){
        [self.delegate logoPressed];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(CGRect)calculateInnerViewFrame:(CGSize)imageSize
{
    CGFloat imageWidth = imageSize.width, imageHeight = imageSize.height;
    CGFloat frameWidth = self.frame.size.width, frameHeight = self.frame.size.height;
    
    if(imageWidth == frameWidth && imageHeight == frameHeight){
        return CGRectMake(0,0,imageSize.width,imageSize.height) ;
    }
    
    CGFloat width = 0.0, height = 0.0;
    
    CGFloat widthRatio = frameWidth / imageWidth;
    CGFloat heightRatio = frameHeight / imageHeight;
    
    CGFloat ratio = widthRatio < heightRatio ? widthRatio : heightRatio;
    
    width = imageWidth * ratio;
    height = imageHeight * ratio;
    
    return CGRectMake(0,0,width,height);
}

@end
