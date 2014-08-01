/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMStepControl.h
 * Date Created : 张 锋 on 8/1/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface REMSegmentedControl : UISegmentedControl

- (id)initWithItems:(NSArray *)items andMargins:(CGPoint)margin;

@end
