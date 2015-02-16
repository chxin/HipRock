//
//  DCAxis.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/8/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "DCAxis.h"
#import "DCXYSeries.h"

@interface DCAxis()
@end

@implementation DCAxis

-(NSUInteger)getVisableSeriesAmount {
    NSUInteger count = 0;
    for (DCXYSeries* s in self.coordinateSystem.seriesList) {
        if (!s.hidden) count++;
    }
    return count;
}
@end
