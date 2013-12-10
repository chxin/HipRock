//
//  ChartStyle.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/11/13.
//
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"
#import "REMColor.h"
#import "REMBuildingConstants.h"
#import "DCContext.h"

@interface REMChartStyle : NSObject
@property (nonatomic, assign) BOOL userInteraction;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, strong) CPTLineStyle* xLineStyle;
@property (nonatomic, strong) CPTTextStyle* xTextStyle;
@property (nonatomic, strong) CPTLineStyle* xGridlineStyle;
@property (nonatomic, strong) CPTLineStyle* yLineStyle;
@property (nonatomic, strong) CPTTextStyle* yTextStyle;
@property (nonatomic, strong) CPTLineStyle* yGridlineStyle;
@property (nonatomic, assign) NSUInteger horizentalGridLineAmount;
@property (nonatomic, assign) NSUInteger symbolSize;
@property (nonatomic, assign) CGFloat xLabelToLine;
@property (nonatomic, assign) CGFloat yLabelToLine;

@property (nonatomic, assign) CGFloat focusSymbolLineWidth;
@property (nonatomic, assign) DCLineType focusSymbolLineStyle;
@property (nonatomic, strong) UIColor* focusSymbolLineColor;
@property (nonatomic, assign) CGFloat focusSymbolIndicatorSize;

@property (nonatomic, assign) CGFloat pieRadius;
@property (nonatomic, assign) CGFloat pieShadowRadius;

@property (nonatomic, assign) CGFloat plotPaddingTop;
@property (nonatomic, assign) CGFloat plotPaddingLeft;
@property (nonatomic, assign) CGFloat plotPaddingRight;
@property (nonatomic, assign) CGFloat plotPaddingBottom;

@property (nonatomic, strong) UIColor* yAxisTitleColor;
@property (nonatomic, assign) CGFloat yAxisTitleToTopLabel; // UOM到最后一节YLabel的距离
@property (nonatomic, assign) CGFloat yAxisTitleFontSize;

@property (nonatomic, strong) UIColor* benchmarkColor;

@property (nonatomic, strong) UIFont* backgroundBandFont;
@property (nonatomic, strong) UIColor* backgroundBandFontColor;

+(REMChartStyle*)getMaximizedStyle;
+(REMChartStyle*)getMinimunStyle;
@end
