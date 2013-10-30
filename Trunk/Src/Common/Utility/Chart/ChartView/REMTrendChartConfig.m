//
//  REMTrendChartConfig.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by Zilong-Oscar.Xu on 9/13/13.
//
//

#import "REMChartHeader.h"

@implementation REMTrendChartConfig
-(REMTrendChartConfig*)initWithDictionary:(NSDictionary*)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self) {
        self.xAxisConfig = [[REMTrendChartAxisConfig alloc]initWithLineStyle:dictionary[@"xLineStyle"] gridlineStyle:dictionary[@"xGridlineStyle"] textStyle:dictionary[@"xTextStyle"]];
        self.horizentalGridLineAmount = ((NSNumber*)dictionary[@"horizentalGridLineAmount"]).intValue;
    }
    return self;
}
@end
