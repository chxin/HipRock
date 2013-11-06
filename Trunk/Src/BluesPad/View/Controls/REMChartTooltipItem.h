/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartToolTip.h
 * Created      : 张 锋 on 11/5/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>

@interface REMChartTooltipItem : UIControl

- (id)initWithFrame:(CGRect)frame withName:(NSString *)name color:(UIColor *)color andValue:(NSNumber *)dataValue;

@end
