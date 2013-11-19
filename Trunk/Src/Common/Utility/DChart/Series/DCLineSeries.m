//
//  DCLineSeries.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/8/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "DCLineSeries.h"

@implementation DCLineSeries

-(DCSeries*)initWithData:(NSArray*)seriesData {
    self = [super initWithData:seriesData];
    if (self) {
        _lineWidth = 2;
    }
    return self;
}
@end
