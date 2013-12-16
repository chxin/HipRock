/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartConfig.m
 * Created      : Zilong-Oscar.Xu on 10/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMChartHeader.h"

@implementation REMChartConfig
-(REMChartConfig*)initWithStyle:(REMChartStyle*)style {
    self = [self init];
    if (self) {
        self.userInteraction = style.userInteraction;
        self.animationDuration = style.animationDuration;
    }
    return self;
}
//+(REMChartConfig*)getMinimunWidgetDefaultSetting {
//    REMChartConfig* config = [[self alloc]init];
//    config.userInteraction = NO;
//    return config;
//}
//+(REMChartConfig*)getMaximunWidgetDefaultSetting {
//    REMChartConfig* config = [[self alloc]init];
//    config.userInteraction = YES;
//    return config;
//}
@end
