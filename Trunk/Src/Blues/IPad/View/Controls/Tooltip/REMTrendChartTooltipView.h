/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTooltipView.h
 * Date Created : 张 锋 on 11/7/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "REMTooltipViewBase.h"

#define REMSeriesIsMultiTime ([self.parameters isKindOfClass:[REMWidgetMultiTimespanSearchModel class]])

@interface REMTrendChartTooltipView : REMTooltipViewBase

- (void)updateHighlightedData:(NSArray *)points atX:(id)x;

@end
