/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTrendChartConfig.m
 * Created      : Zilong-Oscar.Xu on 9/13/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMChartHeader.h"

@implementation REMTrendChartConfig
-(REMChartConfig*)initWithStyle:(REMChartStyle *)style {
    self = [super initWithStyle:style];
    if (self) {
        self.xAxisConfig = [[REMTrendChartAxisConfig alloc]initWithLineStyle:style.xLineStyle gridlineStyle:style.xGridlineStyle textStyle:style.xTextStyle];
        self.horizentalGridLineAmount = style.horizentalGridLineAmount;
    }
    return self;
}
@end
