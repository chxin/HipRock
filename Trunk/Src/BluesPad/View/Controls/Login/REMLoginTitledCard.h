/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMLoginTitledCard.h
 * Date Created : 张 锋 on 11/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "REMLoginCard.h"

@interface REMLoginTitledCard : REMLoginCard

- (id)initWithTitle:(NSString *)title andContentView:(UIView *)contentView;

@end
