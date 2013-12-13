//
//  DCAxis.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/8/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "DCAxis.h"

@implementation DCAxis
-(id)init {
    self = [super init];
    if (self) {
        _lineStyle = DCLineTypeDefault;
        _visableSeriesAmount = 0;
        _labelToLine = 0;
    }
    return self;
}
@end
