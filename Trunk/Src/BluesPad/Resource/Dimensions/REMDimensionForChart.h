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

//chart view
#define kDMChart_BackgroundColor @"#f4f4f4"

#define kDMChart_ToolbarTop 62
#define kDMChart_ToolbarHeight 56
#define kDMChart_ToolbarWidth kDMScreenWidth

#define kDMChart_ToolbarFrame CGRectMake(0,REMDMCOMPATIOS7(kDMChart_ToolbarTop),kDMChart_ToolbarWidth,kDMChart_ToolbarHeight)
#define kDMChart_ToolbarHiddenFrame CGRectMake(kDMChart_ToolbarWidth,REMDMCOMPATIOS7(kDMChart_ToolbarTop),kDMChart_ToolbarWidth,kDMChart_ToolbarHeight)

//indicator
#define kDMChart_IndicatorSize 18
#define kDMChart_IndicatorLineWidth 2
//#define kDMChart_IndicatorBorderWidth 3
//#define kDMChart_IndicatorBorderContentSpace 3

//legend
#define kDMChart_LegendItemWidth 239
#define kDMChart_LegendItemHeight 39
#define kDMChart_LegendItemLeftOffset 10
#define kDMChart_LegendItemTopOffset (kDMChart_ToolbarHeight - kDMChart_LegendItemHeight) / 2
#define kDMChart_LegendItemCornerRadius 2
#define kDMChart_LegendItemBackgroundColor @"#ffffff"
#define kDMChart_LegendItemHiddenBackgroundColor @"#e9e9e9"

#define kDMChart_LegendIndicatorTopOffset (kDMChart_LegendItemHeight - kDMChart_IndicatorSize) / 2
#define kDMChart_LegendIndicatorLeftOffset 12

#define kDMChart_LegendLabelLeftOffset 7
#define kDMChart_LegendLabelFontSize 14
#define kDMChart_LegendLabelTopOffset (kDMChart_LegendItemHeight - kDMChart_LegendLabelFontSize) / 2
#define kDMChart_LegendLabelFontColor @"#212121"
#define kDMChart_LegendLabelHiddenFontColor @"#bababa"

//tooltip
#define kDMChart_TooltipViewHeight REMDMCOMPATIOS7(84)

#define kDMChart_TooltipContentTopOffset REMDMCOMPATIOS7(0)
#define kDMChart_TooltipContentLeftOffset kDMCommon_ContentLeftMargin
#define kDMChart_TooltipContentWidth kDMCommon_ContentWidth
#define kDMChart_TooltipContentHeight kDMChart_TooltipViewHeight - kDMChart_TooltipContentTopOffset

#define kDMChart_TooltipViewBackgroundColor @"#f8f8f8"

#define kDMChart_TooltipCloseViewWidth 100
#define kDMChart_TooltipCloseViewInnerLeftOffset 50

#define kMDChart_TooltipItemLeftOffset 20
#define kDMChart_TooltipItemWidth 211
#define kDMChart_TooltipItemTitleLeftOffset 11
#define kDMChart_TooltipItemTitleFontSize 14
#define kDMChart_TooltipItemTitleColor @"#212121"
#define kDMChart_TooltipItemDataValueFontSize 17
#define kDMChart_TooltipItemDataValueColor @"#9c9c9c"
#define kDMChart_TooltipItemDataValueTopOffset 13

#define kDMChart_TooltipHiddenFrame CGRectMake(0, -kDMChart_TooltipViewHeight, kDMScreenWidth, kDMChart_TooltipViewHeight)
#define kDMChart_TooltipFrame CGRectMake(0, 0, kDMScreenWidth, kDMChart_TooltipViewHeight)
#define kDMChart_TooltipContentViewFrame CGRectMake(kDMCommon_ContentLeftMargin, 0, kDMChart_TooltipContentWidth, kDMChart_TooltipViewHeight)

#endif
