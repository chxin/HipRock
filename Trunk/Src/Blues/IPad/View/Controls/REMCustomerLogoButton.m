/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMCustomerLogoView.m
 * Date Created : 张 锋 on 5/8/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMCustomerLogoButton.h"
#import "REMCommonHeaders.h"

@interface REMCustomerLogoButton ()

@property (nonatomic,weak) UIButton *logoView;
@property (nonatomic,strong) UIImage *iconImage;
@property (nonatomic) BOOL _highlightFlag;

@end

@implementation REMCustomerLogoButton

- (id)initWithIcon:(UIImage *)iconImage
{
    CGRect frame = CGRectMake(kDMCommon_ContentLeftMargin, kDMCommon_CustomerLogoTop + kDMStatusBarHeight,  kDMCommon_TopLeftButtonWidth + 8 + kDMCommon_CustomerLogoWidth, kDMCommon_CustomerLogoHeight);
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:iconImage forState:UIControlStateNormal];
        self.iconImage = iconImage;
        self.extendingInsets = UIEdgeInsetsMake(12, 5, 12, 5);
        
        [self renderCustomerLogo];
    }
    return self;
}

- (void)refresh
{
    if(self.logoView){
        [self.logoView removeFromSuperview];
    }
    
    [self renderCustomerLogo];
}

-(void)renderCustomerLogo
{
    UIImage *logoImage = [UIImage imageWithData:REMAppContext.currentCustomer.logoImage];
    CGSize iconSize = self.iconImage.size;
    
    if(logoImage){
        [self setImageEdgeInsets:UIEdgeInsetsMake(4, 0, 4, self.frame.size.width-iconSize.width)];
        
        CGSize logoViewSize = [self calculateInnerViewSize:logoImage.size];
        UIButton *logoView = [[UIButton alloc] initWithFrame:CGRectMake(iconSize.width+8, 0, logoViewSize.width, logoViewSize.height)];
        [logoView setImage:logoImage forState:UIControlStateNormal];
        logoView.contentMode = UIViewContentModeScaleAspectFit;
        logoView.userInteractionEnabled = NO;
        
        [self addSubview:logoView];
        self.logoView = logoView;
        
        self._highlightFlag = NO;
    }
}

-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    
    if(self._highlightFlag != highlighted){
        self._highlightFlag = highlighted;
        
        [self.logoView setHighlighted:highlighted];
    }
}

-(CGSize)calculateInnerViewSize:(CGSize)imageSize
{
    CGFloat imageWidth = imageSize.width, imageHeight = imageSize.height;
    CGFloat frameWidth = self.frame.size.width, frameHeight = self.frame.size.height;
    
    if(imageWidth == frameWidth && imageHeight == frameHeight){
        return imageSize;
    }
    
    CGFloat width = 0.0, height = 0.0;
    
    CGFloat widthRatio = frameWidth / imageWidth;
    CGFloat heightRatio = frameHeight / imageHeight;
    
    CGFloat ratio = widthRatio < heightRatio ? widthRatio : heightRatio;
    
    width = imageWidth * ratio;
    height = imageHeight * ratio;
    
    return CGSizeMake(width,height);
}

@end
