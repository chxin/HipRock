/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTooltipView.h
 * Date Created : 张 锋 on 11/7/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "REMTooltipViewBase.h"


@interface REMTrendChartTooltipView : REMTooltipViewBase


- (id)initWithFrame:(CGRect)frame andData:(NSArray *)data;

@end
