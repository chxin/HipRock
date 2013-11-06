/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetAxisHelper.h
 * Created      : 徐 子龙 on 13-7-16.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "CPTBarPlot.h"
#import "CPTPlotSpace.h"
#import "CorePlot-CocoaTouch.h"
#import "REMColor.h"
#import "REMTimeRange.h"

@interface REMWidgetAxisHelper : NSObject

+(void)decorateAxisSet:(CPTXYGraph*)graph dataSource:(NSMutableArray*)dataSource startPointIndex:(double)startPointIndex endPointIndex:(double)endPointIndex;

+(void)decorateAxisSet:(CPTXYGraph*)graph dataSource:(NSMutableArray*)dataSource startPointIndex:(double)startPointIndex endPointIndex:(double)endPointIndex yStartZero:(BOOL)isYStartFromZero;

+(void)decorateAxisSet:(CPTXYGraph*)graph dataSource:(NSMutableArray*)dataSource xStart:(double)xAxisStart xLength:(double)xAxisLength globalStart:(double)globalXAxisStart globalRange:(double)globalXAxisLength yStartZero:(BOOL)isYStartFromZero;

@end

