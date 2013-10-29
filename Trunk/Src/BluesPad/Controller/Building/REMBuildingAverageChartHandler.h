//
//  REMBuildingAverageChartHandler.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 8/9/13.
//
//

#import <UIKit/UIKit.h>
#import "REMBuildingChartHandler.h"
#import "REMBuildingAverageChart.h"
#import "REMChartHorizonalScrollDelegator.h"

@interface REMBuildingAverageChartHandler : REMBuildingChartHandler<CPTBarPlotDataSource,CPTBarPlotDelegate,CPTScatterPlotDataSource,CPTScatterPlotDelegate,CPTPlotSpaceDelegate,UIGestureRecognizerDelegate>


@end
