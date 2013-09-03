//
//  REMBuildingAverageChartHandler.h
//  Blues
//
//  Created by 张 锋 on 8/9/13.
//
//

#import <UIKit/UIKit.h>
#import "REMBuildingChartHandler.h"
#import "REMBuildingAverageChart.h"
#import "REMChartHorizonalScrollDelegator.h"

@interface REMBuildingAverageChartHandler : REMBuildingChartHandler<CPTBarPlotDataSource,CPTBarPlotDelegate,CPTScatterPlotDataSource,CPTScatterPlotDelegate,CPTPlotSpaceDelegate,UIGestureRecognizerDelegate>


@end
