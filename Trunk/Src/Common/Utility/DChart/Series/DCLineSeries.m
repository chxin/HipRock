//
//  DCLineSeries.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/8/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "DCLineSeries.h"

@implementation DCLineSeries

-(DCSeries*)initWithEnergyData:(NSArray*)seriesData {
    self = [super initWithEnergyData:seriesData];
    if (self) {
        _lineWidth = 2;
        _symbolType = DCLineSymbolTypeNone;
        _symbolSize = 4;
        self.type = DCSeriesTypeLine;
    }
    return self;
}
@end
