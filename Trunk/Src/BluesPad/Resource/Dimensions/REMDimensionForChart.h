/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMDimensionForChart.h
 * Created      : 张 锋 on 10/8/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#ifndef Blues_REMDimensionForChart_h
#define Blues_REMDimensionForChart_h

#import "REMDimensions.h"

//prefix: kDMChart

#define kDMChart_ToolbarTop 70
#define kDMChart_ToolbarHeight 60
#define kDMChart_ToolbarWidth kDMScreenWidth

#define kDMChart_ToolbarFrame CGRectMake(0,kDMChart_ToolbarTop,kDMChart_ToolbarWidth,kDMChart_ToolbarHeight)
#define kDMChart_ToolbarHiddenFrame CGRectMake(kDMChart_ToolbarWidth,kDMChart_ToolbarTop,kDMChart_ToolbarWidth,kDMChart_ToolbarHeight)


//legend
#define kDMChart_LegendItemWidth 260
#define kDMChart_LegendItemHeight 36
#define kDMChart_LegendItemLeftOffset 15
#define kDMChart_LegendItemTopOffset (kDMChart_ToolbarHeight - kDMChart_LegendItemHeight) / 2

#define kDMChart_LegendIndicatorLeftOffset 5
#define kDMChart_LegendIndicatorSize 16
#define kDMChart_LegendIndicatorTopOffset (kDMChart_LegendItemHeight - kDMChart_LegendIndicatorSize) / 2

#define kDMChart_LegendLabelLeftOffset 5
#define kDMChart_LegendLabelFontSize 12
#define kDMChart_LegendLabelTopOffset (kDMChart_LegendItemHeight - kDMChart_LegendLabelFontSize) / 2

//tooltip
#define kDMChart_TooltipHeight 120
#define kDMChart_TooptipWidth kDMScreenWidth
#define kDMChart_TooltipItemHeight 90
#define kDMChart_TooltipTopOffset (kDMChart_TooltipHeight - kDMChart_TooltipItemHeight) / 2


#endif
