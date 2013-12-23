//
//  ChartStyle.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/11/13.
//
//

#import <Foundation/Foundation.h>
#import "REMColor.h"
#import "REMBuildingConstants.h"
#import "DCContext.h"

@interface REMChartStyle : NSObject

@property (nonatomic, assign) BOOL userInteraction;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) BOOL playBeginAnimation;

/****** XYChart Style Start *******/
// x轴格式
@property (nonatomic, strong) UIColor* xLineColor;
@property (nonatomic, assign) CGFloat xLineWidth;
@property (nonatomic, strong) UIColor* xGridlineColor;
@property (nonatomic, assign) CGFloat xGridlineWidth;
@property (nonatomic, strong) UIColor* xTextColor;
@property (nonatomic, strong) UIFont* xTextFont;
@property (nonatomic, assign) CGFloat xLabelToLine;
// y轴格式
@property (nonatomic, strong) UIColor* yLineColor;
@property (nonatomic, assign) CGFloat yLineWidth;
@property (nonatomic, strong) UIColor* yGridlineColor;
@property (nonatomic, assign) CGFloat yGridlineWidth;
@property (nonatomic, strong) UIColor* yTextColor;
@property (nonatomic, strong) UIFont* yTextFont;
@property (nonatomic, assign) CGFloat yLabelToLine;
// UOM文本格式
@property (nonatomic, strong) UIColor* yAxisTitleColor;
@property (nonatomic, assign) CGFloat yAxisTitleToTopLabel; // UOM到最后一节YLabel的距离
@property (nonatomic, assign) CGFloat yAxisTitleFontSize;

@property (nonatomic, assign) NSUInteger horizentalGridLineAmount;
@property (nonatomic, assign) NSUInteger symbolSize;

@property (nonatomic, assign) CGFloat plotPaddingTop;
@property (nonatomic, assign) CGFloat plotPaddingLeft;
@property (nonatomic, assign) CGFloat plotPaddingRight;
@property (nonatomic, assign) CGFloat plotPaddingBottom;

@property (nonatomic, strong) UIColor* benchmarkColor;
// 背景色文本格式
@property (nonatomic, strong) UIFont* backgroundBandFont;
@property (nonatomic, strong) UIColor* backgroundBandFontColor;
/****** XYChart Style End *******/


/****** PieChart Style Start *******/
@property (nonatomic, assign) CGFloat focusSymbolLineWidth;
@property (nonatomic, assign) DCLineType focusSymbolLineStyle;
@property (nonatomic, strong) UIColor* focusSymbolLineColor;
@property (nonatomic, assign) CGFloat focusSymbolIndicatorSize;

@property (nonatomic, assign) CGFloat pieRadius;
@property (nonatomic, assign) CGFloat pieShadowRadius;
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
@property (nonatomic,assign) CGFloat labelingStageHeightFor3Levels;
@property (nonatomic,assign) CGFloat labelingStageHeightFor4Levels;
@property (nonatomic,assign) CGFloat labelingStageHeightFor5Levels;
@property (nonatomic,assign) CGFloat labelingStageHeightFor6Levels;
@property (nonatomic,assign) CGFloat labelingStageHeightFor7Levels;
@property (nonatomic,assign) CGFloat labelingStageHeightFor8Levels;
@property (nonatomic,assign) CGFloat labelingRadius;
@property (nonatomic,assign) CGFloat labelingTooltipViewFontSize;
@property (nonatomic,strong) UIColor* labelingTooltipViewFontColor;
@property (nonatomic,assign) CGFloat labelingTooltipViewHeight;
@property (nonatomic,assign) CGFloat labelingTooltipViewHPadding;
@property (nonatomic,assign) CGFloat labelingTooltipViewVPadding;
@property (nonatomic,assign) CGFloat labelingTooltipViewCornerRadius;
@property (nonatomic,assign) CGFloat labelingTooltipViewTriangleWidth;
@property (nonatomic,assign) CGFloat labelingTooltipViewTriangleHeight;
@property (nonatomic,assign) CGFloat labelingTooltipViewTriangleMinPaddingToEdge;
//@property (nonatomic,assign) 

/****** Labeling Style End *******/

+(REMChartStyle*)getMaximizedStyle;
+(REMChartStyle*)getMinimunStyle;
@end
