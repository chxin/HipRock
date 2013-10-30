//
//  REMBuildingAirQualityChartHandler.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 8/22/13.
//
//

#import "REMBuildingChartHandler.h"
#import "REMChartHorizonalScrollDelegator.h"

@interface REMBuildingAirQualityChartHandler : REMBuildingChartHandler<CPTScatterPlotDataSource,CPTScatterPlotDelegate,CPTPlotSpaceDelegate>

@end
