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
#import "REMBuildingSettingViewController.h"

@interface REMControllerBase ()


@end

@implementation REMControllerBase

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static CAGradientLayer *gradient;
- (CAGradientLayer *)getTitleGradientLayer
{
    if(gradient == nil){
        CGRect frame = CGRectMake(0, 0, kDMScreenWidth, kDMCommon_TitleGradientLayerHeight);
        UIColor *gradientStartColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        UIColor *gradientStopColor = [UIColor clearColor];
        
        gradient = [CAGradientLayer layer];
        gradient.frame = frame;
        gradient.colors = [NSArray arrayWithObjects: (id)gradientStartColor.CGColor, (id)gradientStopColor.CGColor, nil];
        
        UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);
        CGContextRef c = UIGraphicsGetCurrentContext();
        
        [gradient renderInContext:c];
        
        UIGraphicsEndImageContext();
    }
    
    return gradient;
}

- (UIButton *)getCustomerLogoButton
{
    UIButton *customerLogoButton = [[UIButton alloc]initWithFrame:CGRectMake(kDMCommon_CustomerLogoLeft, kDMCommon_CustomerLogoTop, kDMCommon_CustomerLogoWidth, kDMCommon_CustomerLogoHeight)];
    
    [customerLogoButton setBackgroundImage:[REMApplicationContext instance].currentCustomerLogo forState:UIControlStateNormal];
    
    [customerLogoButton addTarget:self action:@selector(settingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return customerLogoButton;
}

static REMBuildingSettingViewController *settingsController;

- (void)settingButtonPressed:(UIButton *)button{
    if(settingsController == nil)
        settingsController = (REMBuildingSettingViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"settingController"];
    
    [self presentViewController:settingsController animated:YES completion:nil];
}

@end
