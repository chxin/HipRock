//
//  REMTrendChartConfig.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/13/13.
//
//

#import "REMChartHeader.h"

@implementation REMTrendChartConfig
+(REMTrendChartConfig*) getMinimunWidgetDefaultSetting {
    REMTrendChartConfig* config = [[REMTrendChartConfig alloc]init];
    config.xAxisConfig = [REMTrendChartAxisConfig getWidgetXConfig];
    config.yAxisConfig = [NSArray arrayWithObjects:[REMTrendChartAxisConfig getWidgetYConfig],nil];
    config.horizentalGridLineAmount = 4;
    return config;
}
@end
