/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMControllerBase.h
 * Created      : 张 锋 on 10/10/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface REMControllerBase : UIViewController

@property (weak, nonatomic, getter = getTitleGradientLayer) CAGradientLayer *titleGradientLayer;
@property (weak, nonatomic, getter = getCustomerLogoButton) UIButton *customerLogoButton;


- (CAGradientLayer *)getTitleGradientLayer;
- (UIButton *)getCustomerLogoButton;
- (UIButton *)settingButton;
@end
