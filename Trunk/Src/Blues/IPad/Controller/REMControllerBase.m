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
#import "REMButton.h"

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

- (UIButton *)settingButton{
    REMButton *button=[REMButton buttonWithType:UIButtonTypeCustom];
    if (REMISIOS7) {
        button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tintColor=[UIColor whiteColor];
    }
    else{
        button.showsTouchWhenHighlighted = YES;
    }
    
    CGRect frame = CGRectMake(967-kDMButtonExtending, REMDMCOMPATIOS7(kDMCommon_TopLeftButtonTop)-kDMButtonExtending, kDMCommon_TopLeftButtonWidth+2*kDMButtonExtending, kDMCommon_TopLeftButtonHeight+2*kDMButtonExtending);
    
    [button setImage:[UIImage imageNamed:@"Setting"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(settingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:frame];
    
    return button;
}


- (void)settingButtonPressed:(UIButton *)button{
    UINavigationController *settingNavigationController = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:kStoryboard_SettingsPage];
    
    [self presentViewController:settingNavigationController animated:YES completion:nil];
}

@end
