/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingAverageChartHandler.h
 * Created      : 张 锋 on 8/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMBuildingChartHandler.h"
#import "REMBuildingAverageChart.h"
#import "REMChartHorizonalScrollDelegator.h"

@interface REMBuildingAverageChartHandler : REMBuildingChartHandler<CPTBarPlotDataSource,CPTBarPlotDelegate,CPTScatterPlotDataSource,CPTScatterPlotDelegate,CPTPlotSpaceDelegate,UIGestureRecognizerDelegate>


@end
