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
    config.xAxisConfig = [REMTrendChartAxisConfig getMinWidgetXConfig];
    config.yAxisConfig = [NSArray arrayWithObjects:[REMTrendChartAxisConfig getMinWidgetYConfig],nil];
    config.horizentalGridLineAmount = 4;
    return config;
}
+(REMTrendChartConfig*) getMaximunWidgetDefaultSetting {
    REMTrendChartConfig* config = [[REMTrendChartConfig alloc]init];
    config.xAxisConfig = [REMTrendChartAxisConfig getMaxWidgetXConfig];
    config.yAxisConfig = [NSArray arrayWithObjects:[REMTrendChartAxisConfig getMaxWidgetYConfig],nil];
    config.horizentalGridLineAmount = 6;
    return config;
}
@end
