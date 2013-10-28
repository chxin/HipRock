//
//  REMTrendChartConfig.m
//  Blues
//
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
