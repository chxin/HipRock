//
//  DCSeries.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/8/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "DCSeries.h"
#import "DCDataPoint.h"

@implementation DCSeries

-(DCSeries*)initWithEnergyData:(NSArray*)seriesData {
    self = [self init];
    if (self) {
        _color = [UIColor blackColor];
        _datas = seriesData;
        for (DCDataPoint* p in self.datas) {
            p.series = self;
            if (REMIsNilOrNull(p.energyData)) {
                p.pointType = DCDataPointTypeEmpty;
            } else if (REMIsNilOrNull(p.value)) {
                p.pointType = DCDataPointTypeBreak;
            } else {
                p.pointType = DCDataPointTypeNormal;
            }
        }
    }
    return self;
}
@end
