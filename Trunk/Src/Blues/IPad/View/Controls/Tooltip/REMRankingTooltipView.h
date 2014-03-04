/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMRankingTooltipView.h
 * Date Created : 张 锋 on 11/26/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMTrendChartTooltipView.h"

@interface REMRankingTooltipView : REMTrendChartTooltipView

-(REMTooltipViewBase *)initWithHighlightedPoints:(NSArray *)points inSerieses:(NSArray *)serieses widget:(REMWidgetObject *)widget andParameters:(REMWidgetSearchModelBase *)parameters;

@end
