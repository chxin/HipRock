/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMPieChartTooltipView.h
 * Date Created : 张 锋 on 11/8/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/

#import "REMTooltipViewBase.h"

@interface REMPieChartTooltipView : REMTooltipViewBase

- (id)initWithFrame:(CGRect)frame data:(NSArray *)data andHighlightIndex:(int)highlightIndex;

- (void)update:(id)highlightIndex;

@end
