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
    self = [super init];
    if (self) {
        _datas = seriesData;
        for (DCDataPoint* p in self.datas) {
            p.series = self;
        }
    }
    return self;
}
@end
