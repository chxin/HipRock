//
//  REMControllerBase.m
//  Blues
//
//  Created by 张 锋 on 10/10/13.
//
//

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
    CGRect frame = CGRectMake(0, 0, kDMScreenWidth, kDMCommon_TitleGradientLayerHeight);
    UIColor *gradientStartColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    UIColor *gradientStopColor = [UIColor clearColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = frame;
    gradient.colors = [NSArray arrayWithObjects: (id)gradientStartColor.CGColor, (id)gradientStopColor.CGColor, nil];
    
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    [gradient renderInContext:c];
    
    UIGraphicsEndImageContext();
    
    return gradient;
}

- (UIButton *)getCustomerLogoButton
{
    UIButton *customerLogoButton = [[UIButton alloc]initWithFrame:CGRectMake(kDMCommon_CustomerLogoLeft, kDMCommon_CustomerLogoTop, kDMCommon_CustomerLogoWidth, kDMCommon_CustomerLogoHeight)];
    
    [customerLogoButton setBackgroundImage:[REMApplicationContext instance].currentCustomerLogo forState:UIControlStateNormal];
    
    [customerLogoButton addTarget:self action:@selector(settingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return customerLogoButton;
}

static UINavigationController *settingNavigationController;

- (void)settingButtonPressed:(UIButton *)button{
    if(settingNavigationController == nil){
        settingNavigationController = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:kStoryboard_SettingsPage];
        
        REMSettingViewController *settingController = (REMSettingViewController *)[settingNavigationController.childViewControllers lastObject];
        settingController.mainNavigationController = (REMMainNavigationController *)self.navigationController;
    }
    
    [self presentViewController:settingNavigationController animated:YES completion:nil];
}

@end
