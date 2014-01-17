/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBlurredMapView.m
 * Date Created : 张 锋 on 1/10/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMBlurredMapView.h"

@interface REMBlurredMapView()

@property (nonatomic,weak) UIImageView *background;
@property (nonatomic,weak) UIImageView *logo;
@property (nonatomic,weak) UILabel *label;

@end

@implementation REMBlurredMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self){
        [self renderBackground];
        [self renderLogo];
        [self renderText];
    }
    
    return self;
}


-(void)hide:(void (^)(void))complete
{
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if(complete!=nil)
            complete();
    }];
}

-(void)renderBackground
{
    UIImageView *backgroud = [[UIImageView alloc] initWithImage:REMIMG_MapBlur];
    backgroud.frame = self.bounds;
    
    [self addSubview:backgroud];
    self.background = backgroud;
}

-(void)renderLogo
{
    UIImageView *logo = [[UIImageView alloc] initWithImage:REMIMG_SplashScreenLogo_Common];
    logo.frame = CGRectMake((kDMScreenWidth-logo.frame.size.width)/2, kDMSplash_LogoViewTopOffset, logo.frame.size.width, logo.frame.size.height);
    
    [self addSubview:logo];
    self.logo = logo;
}

-(void)renderText
{
    NSString *text = @"正在加载...";
    UIFont *font = [UIFont systemFontOfSize:24];
    CGSize labelSize = [text sizeWithFont:font];
    CGRect logoFrame = self.logo.frame;
    CGRect labelFrame = CGRectMake((kDMScreenWidth-labelSize.width)/2, logoFrame.origin.y+logoFrame.size.height+43, labelSize.width, labelSize.height);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.text = text;
    label.font = font;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    
    [self addSubview:label];
    self.label = label;
}

@end
