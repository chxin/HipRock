//
//  REMChartConfig.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 10/9/13.
//
//

#import "REMChartHeader.h"

@implementation REMChartConfig
+(REMChartConfig*)getMinimunWidgetDefaultSetting {
    REMChartConfig* config = [[self alloc]init];
    config.userInteraction = NO;
    return config;
}
+(REMChartConfig*)getMaximunWidgetDefaultSetting {
    REMChartConfig* config = [[self alloc]init];
    config.userInteraction = YES;
    return config;
}
@end
