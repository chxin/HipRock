/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingAirQualityChartHandler.h
 * Created      : tantan on 8/22/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMBuildingChartHandler.h"
#import "REMChartHorizonalScrollDelegator.h"

@interface REMBuildingAirQualityChartHandler : REMBuildingChartHandler<CPTScatterPlotDataSource,CPTScatterPlotDelegate,CPTPlotSpaceDelegate>

@end
