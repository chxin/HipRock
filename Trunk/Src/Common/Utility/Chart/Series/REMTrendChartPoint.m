//
//  REMTrendChartPoint.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/12/13.
//
//

#import "REMChartHeader.h"

@implementation REMTrendChartPoint
-(REMTrendChartPoint*)initWithX:(float)x y:(NSNumber*)y point:(REMEnergyData*)p {
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
        _energyData = p;
    }
    return self;
}

@end
