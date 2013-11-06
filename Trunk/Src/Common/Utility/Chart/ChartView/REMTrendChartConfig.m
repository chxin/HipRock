/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTrendChartConfig.m
 * Created      : Zilong-Oscar.Xu on 9/13/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
