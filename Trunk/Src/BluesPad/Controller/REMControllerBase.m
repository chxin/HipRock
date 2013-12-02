/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMControllerBase.m
 * Created      : 张 锋 on 10/10/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMControllerBase.h"
#import "REMDimensions.h"
#import "REMCommonHeaders.h"
#import "REMSettingViewController.h"
#import "REMStoryboardDefinitions.h"

@interface REMControllerBase ()


@end

@implementation REMControllerBase

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CAGradientLayer *)getTitleGradientLayer
{
    UIColor *gradientStartColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    UIColor *gradientStopColor = [UIColor clearColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = kDMCommon_TitleGradientLayerFrame;
    gradient.colors = [NSArray arrayWithObjects: (id)gradientStartColor.CGColor, (id)gradientStopColor.CGColor, nil];
    
    UIGraphicsBeginImageContextWithOptions(gradient.frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [gradient renderInContext:context];
    
    UIGraphicsEndImageContext();
    
    return gradient;
}

- (UIButton *)getCustomerLogoButton
{
    UIButton *customerLogoButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kDMCommon_CustomerLogoWidth, kDMCommon_CustomerLogoHeight)];
    
    [customerLogoButton setImage:REMAppCurrentLogo forState:UIControlStateNormal];
    customerLogoButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    customerLogoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [customerLogoButton addTarget:self action:@selector(settingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return customerLogoButton;
}


- (void)settingButtonPressed:(UIButton *)button{
    UINavigationController *settingNavigationController = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:kStoryboard_SettingsPage];
    
    [self presentViewController:settingNavigationController animated:YES completion:nil];
}

@end
