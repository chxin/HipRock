//
//  REMControllerBase.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 10/10/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface REMControllerBase : UIViewController

@property (weak, nonatomic, getter = getTitleGradientLayer) CAGradientLayer *titleGradientLayer;
@property (weak, nonatomic, getter = getCustomerLogoButton) UIButton *customerLogoButton;


- (CAGradientLayer *)getTitleGradientLayer;
- (UIButton *)getCustomerLogoButton;

@end
