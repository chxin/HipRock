//
//  REMControllerBase.h
//  Blues
//
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
