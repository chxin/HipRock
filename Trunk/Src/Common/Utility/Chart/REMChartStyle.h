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

@property (nonatomic, strong) UIColor* xLineColor;
@property (nonatomic, assign) CGFloat xLineWidth;
@property (nonatomic, strong) UIColor* xGridlineColor;
@property (nonatomic, assign) CGFloat xGridlineWidth;
@property (nonatomic, strong) UIColor* xTextColor;
@property (nonatomic, strong) UIFont* xTextFont;

@property (nonatomic, strong) UIColor* yLineColor;
@property (nonatomic, assign) CGFloat yLineWidth;
@property (nonatomic, strong) UIColor* yGridlineColor;
@property (nonatomic, assign) CGFloat yGridlineWidth;
@property (nonatomic, strong) UIColor* yTextColor;
@property (nonatomic, strong) UIFont* yTextFont;

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

@property (nonatomic, assign) BOOL playBeginAnimation;

@property (nonatomic, assign) CGFloat labelingLineWidth;
@property (nonatomic, strong) UIColor* labelingLineColor;
@property (nonatomic, strong) NSString* labelingFontName;

+(REMChartStyle*)getMaximizedStyle;
+(REMChartStyle*)getMinimunStyle;
@end
