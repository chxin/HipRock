/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMCustomerLogoView.h
 * Date Created : 张 锋 on 5/8/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "REMButton.h"



@interface REMCustomerLogoButton : REMButton

@property (nonatomic,weak) UIButton *logoView;

- (id)initWithIcon:(UIImage *)iconImage;
- (void)refresh;

@end
