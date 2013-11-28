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


+(REMChartStyle*)getMaximizedStyle;
+(REMChartStyle*)getMinimunStyle;
@end
