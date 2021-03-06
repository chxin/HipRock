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
@property (nonatomic,weak) REMBreathLogoView *logo;
@property (nonatomic,weak) UIImageView *loadingView;

@end

@implementation REMBlurredMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self){
        [self renderBackground];
        [self renderLogo];
        [self renderLoading];
    }
    
    return self;
}


-(void)hide:(void (^)(void))complete
{
    [UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.logo stop];
        [self removeFromSuperview];
        
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
//    UIImageView *logo = [[UIImageView alloc] initWithImage:REMIMG_SplashScreenLogo_Common];
//    logo.frame = CGRectMake((kDMScreenWidth-logo.frame.size.width)/2, kDMSplash_LogoViewTopOffset, logo.frame.size.width, logo.frame.size.height);
    REMBreathLogoView *logo = [[REMBreathLogoView alloc] init];
    //logo.frame = CGRectMake((kDMScreenWidth-logo.frame.size.width)/2, kDMSplash_LogoViewTopOffset, logo.frame.size.width, logo.frame.size.height);
    logo.frame = CGRectMake((kDMScreenWidth-logo.frame.size.width)/2, 238, logo.frame.size.width, logo.frame.size.height);
    
    [self addSubview:logo];
    self.logo = logo;
}

-(void)renderLoading
{
    UIImage *loadingImage = REMLoadImageNamed(@"Loading");
    UIImageView *loadingView = [[UIImageView alloc] initWithImage:loadingImage];
    loadingView.frame = CGRectMake((kDMScreenWidth-loadingImage.size.width)/2, self.logo.frame.origin.y + self.logo.frame.size.height, loadingImage.size.width, loadingImage.size.height);
    
    [self addSubview:loadingView];
    self.loadingView = loadingView;
}

@end


@implementation REMBreathLogoView

CGFloat animationTime = 1.5;

CGFloat flashOriginalAlpha = 0;
CGFloat flashFinalAlpha = 1.0;
CGFloat normalOriginalAlpha = 1;
CGFloat normalFinalAlpha = 1;

-(id)init
{
    UIImageView *normalLogo = [[UIImageView alloc] initWithImage:REMIMG_SplashScreenLogo_Common];
    UIImageView *flashLogo = [[UIImageView alloc] initWithImage:REMIMG_SplashScreenLogo_Flash];
    
    self = [super initWithFrame:normalLogo.frame];
    
    if(self){
        //init normal & flash logo
        
        normalLogo.alpha = 1;
        flashLogo.alpha = 0;
        
        [self addSubview:flashLogo];
        [self addSubview:normalLogo];
        
        self.normalLogo = normalLogo;
        self.flashLogo = flashLogo;
        
        [self start];
    }
    
    return self;
}

-(void)start
{
    SEL selector = @selector(animate);
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[self class] instanceMethodSignatureForSelector:selector]];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    
    [invocation invoke];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:animationTime invocation:invocation repeats:YES];
}

-(void)animate
{
    if(self.flashLogo.alpha == 0){
        [UIView animateWithDuration:animationTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseIn animations:^{
            self.flashLogo.alpha = flashFinalAlpha;
        } completion:nil];
    }
    else{
        [UIView animateWithDuration:animationTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
            self.flashLogo.alpha = flashOriginalAlpha;
        } completion:nil];
    }
}

-(void)stop
{
    [self.timer invalidate];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

@end
