//
//  REMWidgetAxisHelper.h
//  Blues
//
//  Created by 徐 子龙 on 13-7-16.
//
//

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

+(void)decorateBuildingTrendAxisSet:(CPTXYGraph*)graph dataSource:(NSMutableArray*)dataSource interval:(REMRelativeTimeRangeType)t seriesIndex:(int)seriesIndex;
@end

