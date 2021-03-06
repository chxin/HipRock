/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBlurredMapView.h
 * Date Created : 张 锋 on 1/10/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface REMBlurredMapView : UIView

-(void)hide:(void (^)(void))complete;

@end


@interface REMBreathLogoView : UIView

@property (nonatomic,weak) UIImageView *normalLogo;
@property (nonatomic,weak) UIImageView *flashLogo;
@property (nonatomic,strong) NSTimer *timer;


-(void)start;
-(void)stop;

@end