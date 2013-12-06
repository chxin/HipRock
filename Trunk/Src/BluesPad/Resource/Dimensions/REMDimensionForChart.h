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

#define kDMChart_ToolbarTop 0
#define kDMChart_ToolbarHeight 56
#define kDMChart_ToolbarWidth (kDMScreenWidth - 2*kDMCommon_ContentLeftMargin)

#define kDMChart_ToolbarFrame CGRectMake(kDMCommon_ContentLeftMargin,kDMChart_ToolbarTop,kDMChart_ToolbarWidth,kDMChart_ToolbarHeight)
#define kDMChart_ToolbarHiddenFrame CGRectMake(kDMScreenWidth,kDMChart_ToolbarTop,kDMChart_ToolbarWidth,kDMChart_ToolbarHeight)

//indicator
#define kDMChart_IndicatorSize 18
#define kDMChart_IndicatorLineWidth 2
//#define kDMChart_IndicatorBorderWidth 3
//#define kDMChart_IndicatorBorderContentSpace 3

//legend
#define kDMChart_LegendItemWidth 265//239
#define kDMChart_LegendItemHeight 39
#define kDMChart_LegendItemLeftOffset 10
#define kDMChart_LegendItemTopOffset ((kDMChart_ToolbarHeight - kDMChart_LegendItemHeight) / 2)
#define kDMChart_LegendItemCornerRadius 2
#define kDMChart_LegendItemBackgroundColor @"#ffffff"
#define kDMChart_LegendItemHiddenBackgroundColor @"#e9e9e9"

#define kDMChart_LegendIndicatorTopOffset ((kDMChart_LegendItemHeight - kDMChart_IndicatorSize) / 2)
#define kDMChart_LegendIndicatorLeftOffset 12

#define kDMChart_LegendLabelLeftOffset 7
#define kDMChart_LegendLabelFontSize 14
#define kDMChart_LegendLabelTopOffset ((kDMChart_LegendItemHeight - kDMChart_LegendLabelFontSize) / 2)
#define kDMChart_LegendLabelFontColor @"#212121"
#define kDMChart_LegendLabelHiddenFontColor @"#bababa"

//tooltip
#define kDMChart_TooltipViewHeight REMDMCOMPATIOS7(118)
#define kDMChart_TooltipViewWidth kDMScreenWidth
#define kDMChart_TooltipViewBackgroundColor @"#f4f4f4"
#define kDMChart_TooltipFrame CGRectMake(0, 0, kDMChart_TooltipViewWidth, kDMChart_TooltipViewHeight)
#define kDMChart_TooltipHiddenFrame CGRectMake(0, -kDMChart_TooltipViewHeight, kDMChart_TooltipViewWidth, kDMChart_TooltipViewHeight)

#define kDMChart_TooltipContentTopOffset REMDMCOMPATIOS7(0)
#define kDMChart_TooltipContentLeftOffset kDMCommon_ContentLeftMargin
#define kDMChart_TooltipContentWidth kDMCommon_ContentWidth
#define kDMChart_TooltipContentHeight (kDMChart_TooltipViewHeight - kDMChart_TooltipContentTopOffset)
#define kDMChart_TooltipContentViewFrame CGRectMake(kDMChart_TooltipContentLeftOffset, kDMChart_TooltipContentTopOffset, kDMChart_TooltipContentWidth, kDMChart_TooltipContentHeight)

#define kDMChart_TooltipTimeViewTopOffset 22
#define kDMChart_TooltipTimeViewFontSize 14
#define kDMChart_TooltipTimeViewFontColor @"#212121"
#define kDMChart_TooltipTimeViewFrame CGRectMake(0,kDMChart_TooltipTimeViewTopOffset,kDMCommon_ContentWidth,kDMChart_TooltipTimeViewFontSize)

#define kDMChart_TooltipCloseIconSize 32
#define kDMChart_TooltipCloseIconTopOffset 51
#define kDMChart_TooltipCloseIconLeftOffset 46
#define kDMChart_TooltipCloseViewWidth (kDMChart_TooltipCloseIconLeftOffset + kDMChart_TooltipCloseIconSize)
#define kDMChart_TooltipCloseViewHeight kDMChart_TooltipContentHeight
#define kDMChart_TooltipCloseViewFrame CGRectMake(kDMChart_TooltipContentWidth-kDMChart_TooltipCloseViewWidth, 0, kDMChart_TooltipCloseViewWidth, kDMChart_TooltipCloseViewHeight)

#define kDMChart_TooltipScrollViewTopOffset (kDMChart_TooltipTimeViewTopOffset + kDMChart_TooltipTimeViewFontSize)
#define kDMChart_TooltipScrollViewWidth (kDMChart_TooltipContentWidth - kDMChart_TooltipCloseViewWidth)
#define kDMChart_TooltipScrollViewHeight (kDMChart_TooltipContentHeight - kDMChart_TooltipTimeViewTopOffset - kDMChart_TooltipTimeViewTopOffset)
#define kDMChart_TooltipScrollViewFrame CGRectMake(0,kDMChart_TooltipScrollViewTopOffset,kDMChart_TooltipScrollViewWidth,kDMChart_TooltipScrollViewHeight)

#define kMDChart_TooltipItemLeftOffset 20
#define kDMChart_TooltipItemOffset 60
#define kDMChart_TooltipItemWidth 211
#define kDMChart_TooltipItemHeight kDMChart_TooltipScrollViewHeight

#define kDMChart_TooltipItemTitleWidth kDMChart_TooltipItemWidth
#define kDMChart_TooltipItemTitleTopOffset 18
#define kDMChart_TooltipItemTitleLeftOffset 0
#define kDMChart_TooltipItemTitleFontSize 14
#define kDMChart_TooltipItemTitleColor @"#212121"

#define kDMChart_TooltipItemDataValueLeftOffset kDMChart_TooltipItemTitleLeftOffset
#define kDMChart_TooltipItemDataValueTopOffset (kDMChart_TooltipItemTitleTopOffset + kDMChart_TooltipItemTitleFontSize + 7)
#define kDMChart_TooltipItemDataValueFontSize 24//17
#define kDMChart_TooltipItemDataValueColor @"#686868"
#define kDMChart_TooltipItemDataValueUomFontSize 14//17
#define kDMChart_TooltipItemDataValueUomColor @"#686868"

#define kDMChart_RankingTooltipNumeratorFontSize 39
#define kDMChart_RankingTooltipNumeratorFontColor @"#212121"
#define kDMChart_RankingTooltipDenominatorFontSize 18
#define kDMChart_RankingTooltipDenominatorFontColor @"#212121"

#define kDMChart_RankingTooltipTitleLeftOffset 18
#define kDMChart_RankingTooltipTitleFontSize kDMChart_TooltipItemTitleFontSize
#define kDMChart_RankingTooltipTitleFontColor kDMChart_TooltipItemTitleColor



#define kDMChart_RankingTooltipDataValueFontSize kDMChart_TooltipItemDataValueFontSize
#define kDMChart_RankingTooltipDataValueFontColor kDMChart_TooltipItemDataValueColor




#endif
