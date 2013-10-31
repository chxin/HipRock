//
//  REMChartConfig.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by Zilong-Oscar.Xu on 10/9/13.
//
//

#import "REMChartHeader.h"

@implementation REMChartConfig
-(REMChartConfig*)initWithDictionary:(NSDictionary*)dictionary {
    self = [self init];
    if (self) {
        self.userInteraction = ([dictionary[@"userInteraction"] isEqualToString:@"YES"]) ? YES : NO;
        self.animationDuration = ((NSNumber*)dictionary[@"animationDuration"]).floatValue;
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
