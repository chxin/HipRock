/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingAverageChartHandler.h
 * Created      : 张 锋 on 8/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMBuildingChartBaseViewController.h"
#import "REMBuildingAverageChart.h"
#import "REMChartHorizonalScrollDelegator.h"

@interface REMBuildingAverageViewController : REMBuildingChartBaseViewController<CPTBarPlotDataSource,CPTBarPlotDelegate,CPTScatterPlotDataSource,CPTScatterPlotDelegate,CPTPlotSpaceDelegate,UIGestureRecognizerDelegate>


@end
