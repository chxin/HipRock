//
//  ChartStyle.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/11/13.
//
//

#import <Foundation/Foundation.h>
#import "DCChartEnum.h"
#import "REMColor.h"
#import "REMBuildingConstants.h"

@interface DCChartStyle : NSObject

@property (nonatomic, assign) BOOL acceptPan;
@property (nonatomic, assign) BOOL acceptPinch;
@property (nonatomic, assign) BOOL acceptTap;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) BOOL playBeginAnimation;
@property (nonatomic, strong) UIColor* indicatorColor;

/****** XYChart Style Start *******/
@property (nonatomic, assign) BOOL useTextLayer;    // YES=文本使用CATextLayer绘制，NO=文本使用[NSString drawInRect]绘制
// x轴格式
@property (nonatomic, strong) UIColor* xLineColor;  // x轴轴线颜色
@property (nonatomic, assign) CGFloat xLineWidth;   // x轴轴线宽度
@property (nonatomic, strong) UIColor* xGridlineColor;  // x轴分割线颜色
@property (nonatomic, assign) CGFloat xGridlineWidth;   // x轴分割线宽度
@property (nonatomic, assign) DCLineType xGridlineStyle;    // x轴分割线类型
@property (nonatomic, strong) UIColor* xTextColor;  // x轴文本颜色
@property (nonatomic, strong) UIFont* xTextFont;    // x轴文本字体
@property (nonatomic, assign) CGFloat xLabelToLine; // x轴文本离x轴轴线的距离
// y轴格式
@property (nonatomic, strong) UIColor* yLineColor;  // y轴轴线颜色
@property (nonatomic, assign) CGFloat yLineWidth;   // y轴轴线宽度
@property (nonatomic, strong) UIColor* yGridlineColor;  // y轴分割线颜色
@property (nonatomic, assign) CGFloat yGridlineWidth;   // y轴分割线宽度
@property (nonatomic, assign) DCLineType yGridlineStyle;    // y轴分割线类型
@property (nonatomic, strong) UIColor* yTextColor;  // y轴文本颜色
@property (nonatomic, strong) UIFont* yTextFont;    // y轴文本字体
@property (nonatomic, assign) CGFloat yLabelToLine; // y轴文本离x轴轴线的距离
// y轴标题格式
@property (nonatomic, strong) UIColor* yAxisTitleColor; // y轴标题文本颜色
@property (nonatomic, assign) CGFloat yAxisTitleToTopLabel; // y轴标题文本到最后一节YLabel的距离
@property (nonatomic, assign) CGFloat yAxisTitleFontSize;   // y轴标题文本的字体大小

@property (nonatomic, assign) NSUInteger horizentalGridLineAmount;  // 横向分割线的数量（不包含轴线）
@property (nonatomic, assign) NSUInteger symbolSize;    // 线图的点的半径

/*
 ---------------------ChartView-----------------------------
 |padding                                                  |
 |   |------  -DrawArea(Axes, column/line, etc.)---  ---|  |
 |   |                                                  |  |
 |   |    ---------------PlotRect-------------          |  |
 |   |    |                                  |          |  |
 |   |    |{draw line/column inside PlotRect}|          |  |
 |   |    |                                  |          |  |
 |   |    ------------------------------------          |  |
 |   |                                                  |  |
 |   |--------------------------------------------------|  |
 |                                                         |
 -----------------------------------------------------------
 */
@property (nonatomic, assign) CGFloat plotPaddingTop;
@property (nonatomic, assign) CGFloat plotPaddingLeft;
@property (nonatomic, assign) CGFloat plotPaddingRight;
@property (nonatomic, assign) CGFloat plotPaddingBottom;

@property (nonatomic, strong) UIColor* benchmarkColor;  // benchmark的序列颜色
// 背景色文本格式
@property (nonatomic, strong) UIFont* backgroundBandFont;   // 背景文本的字体（用于绘制冷暖季、工休日）
@property (nonatomic, strong) UIColor* backgroundBandFontColor; // 背景文本的文本颜色（用于绘制冷暖季、工休日）

@property (nonatomic, assign) CGFloat focusSymbolLineWidth; // highlight某个x位置时，指示线的宽度
@property (nonatomic, assign) DCLineType focusSymbolLineStyle;// highlight某个x位置时，指示线的类型
@property (nonatomic, assign) CGFloat focusSymbolIndicatorSize; // highlight某个x位置时，Line图上被高亮的点的半径
/****** XYChart Style End *******/


/****** PieChart Style Start *******/

@property (nonatomic, strong) UIFont* piePercentageTextFont;    // 百分比文本的字体
@property (nonatomic, assign) BOOL piePercentageTextHidden;     // 是否隐藏百分比文本
@property (nonatomic, assign) CGFloat piePercentageTextRadius;  // 百分比文本距离Pie圆心的距离
@property (nonatomic, strong) UIColor* piePercentageTextColor;  // 百分比文本的颜色

@property (nonatomic, assign) CGFloat pieRadius;                // pie的半径
@property (nonatomic, assign) CGFloat pieShadowRadius;          // pie阴影的半径（大于pieRadius才能显示出）
/****** PieChart Style End *******/

/****** Labeling Style Start *******/
@property (nonatomic, assign) CGFloat labelingLineWidth;            // 分割线宽度
@property (nonatomic, assign) CGFloat labelingStageMinWidth;        // 第一个Stage的宽度
@property (nonatomic, assign) CGFloat labelingStageMaxWidth;        // 最后一个Stage的宽度
@property (nonatomic, assign) CGFloat labelingStageToLineMargin;    // Stage到分割线的横向距离
@property (nonatomic, assign) CGFloat labelingLabelToLineMargin;    // Label到分割线的横向距离
@property (nonatomic, strong) UIColor* labelingLineColor;           // 分割线颜色
@property (nonatomic, strong) NSString* labelingFontName;           // 公用的字体名称
@property (nonatomic, assign) CGFloat labelingLabelWidth;           // Label的宽度
@property (nonatomic, assign) CGFloat labelingLabelHeight;          // Label的高度
@property (nonatomic, assign) CGFloat labelingTooltipArcLineWidth;  // (i)的圆边的宽度
@property (nonatomic, assign) CGFloat labelingEffectFontSize;        // 【高能效，低能效】文本字号
@property (nonatomic, assign) CGFloat labelingStageFontSize;        // Stage ABCD文本字号
@property (nonatomic, assign) CGFloat labelingStageToStageTextMargin;   // 最顶部和最底部的Stage距离【高能效，低能效】的距离
@property (nonatomic, assign) CGFloat labelingStageToBorderMargin;  // 最顶部和最底部的Stage距离PlotRect的距离
@property (nonatomic,strong) UIColor* labelingStageFontColor;   // 【高能效，低能效】的文本颜色
@property (nonatomic,assign) CGFloat labelingTooltipIconLeftMargin;   // (i)距离Stage的左边距
@property (nonatomic,assign) CGFloat labelingTooltipIconRadius; // TooltipIcon的半径
@property (nonatomic,assign) CGFloat labelingTooltipIconFontSize; // TooltipIcon的(i)字号
@property (nonatomic,assign) CGFloat labelingTooltipIconFontLeftMargin; // TooltipIcon的(i)距离Stage的左边距
@property (nonatomic,assign) CGFloat labelingTooltipIconFontTopMargin; // TooltipIcon的(i)距离Stage的上边距
@property (nonatomic,assign) CGFloat labelingStageFontTopMargin;    // Stage文本距离Stage上边距
@property (nonatomic,assign) CGFloat labelingStageFontRightMargin; // Stage文本距离Stage的右边距
@property (nonatomic,assign) CGFloat labelingLabelFontSize; // Label Stage文本字号
@property (nonatomic,assign) CGFloat labelingLabelFontRightMargin; // Label Stage文本距离Label的左边距
@property (nonatomic,assign) CGFloat labelingLabelFontTopMargin; // Label Stage文本距离Label的上边距
@property (nonatomic,assign) CGFloat labelingLabelValueFontSize; // Label Value文本的字号
@property (nonatomic,strong) UIColor* labelingLabelValueFontColor; // Label Value文本的颜色
@property (nonatomic,assign) CGFloat labelingLabelValueFontTopMarginToLabel; // Label Value文本的顶边距离Label顶边的距离
@property (nonatomic,assign) CGFloat labelingLabelTagNameTopMargin; // Label Tag名称顶边距
@property (nonatomic,assign) CGFloat labelingLabelTagNameFontSize;  // Tag名称文本字号
@property (nonatomic,assign) CGFloat labelingStageHeightFor3Levels; // 当Level分为3级时，每个Level的高度
@property (nonatomic,assign) CGFloat labelingStageHeightFor4Levels; // 当Level分为4级时，每个Level的高度
@property (nonatomic,assign) CGFloat labelingStageHeightFor5Levels; // 当Level分为5级时，每个Level的高度
@property (nonatomic,assign) CGFloat labelingStageHeightFor6Levels; // 当Level分为6级时，每个Level的高度
@property (nonatomic,assign) CGFloat labelingStageHeightFor7Levels; // 当Level分为7级时，每个Level的高度
@property (nonatomic,assign) CGFloat labelingStageHeightFor8Levels; // 当Level分为8级时，每个Level的高度
@property (nonatomic,assign) CGFloat labelingRadius;                // 绘制Label和Level时的圆角半径
@property (nonatomic,assign) CGFloat labelingTooltipViewFontSize;   // tooltip的文本尺寸
@property (nonatomic,strong) UIColor* labelingTooltipViewFontColor; // tooltip的文本颜色
@property (nonatomic,assign) CGFloat labelingTooltipViewHPadding;   // tooltip文本距离TooltipView浮层上沿和下沿的距离
@property (nonatomic,assign) CGFloat labelingTooltipViewVPadding;   // tooltip文本距离TooltipView浮层左沿和右沿的距离
@property (nonatomic,assign) CGFloat labelingTooltipViewCornerRadius;// TooltipView浮层的圆角半径
@property (nonatomic,assign) CGFloat labelingTooltipViewTriangleWidth;// TooltipView浮层的指示箭头的宽度
@property (nonatomic,assign) CGFloat labelingTooltipViewTriangleHeight;// TooltipView浮层的指示箭头的高度
@property (nonatomic,assign) CGFloat labelingTooltipViewTriangleMinPaddingToEdge;// TooltipView浮层距离ChartView边缘的最近的距离阀值。超过此值时

@property (nonatomic,assign) CGFloat labelingArrowVMargin;
@property (nonatomic,assign) CGFloat labelingArrowLineWidth;
@property (nonatomic,assign) CGFloat labelingArrowWidth;
@property (nonatomic,assign) CGFloat labelingArrowHeight;
@property (nonatomic,strong) UIColor* labelingArrowColor;
//@property (nonatomic,assign) 

/****** Labeling Style End *******/

+(DCChartStyle*)getMaximizedStyle;  // 获取Widget最大化时的Style设置
+(DCChartStyle*)getMinimunStyle;    // 获取Widget最小化时得Style设置
+(DCChartStyle*)getCoverStyle;      // 获取Widget被Pin在Cover上时，Style的设置
@end
