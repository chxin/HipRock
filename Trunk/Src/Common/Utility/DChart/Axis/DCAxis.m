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
//        _axisCoordinate = DCAxisCoordinateX;
//        _axisType = DCAxisTypeMajor;
        _lineColor = [UIColor whiteColor];
        _lineWidth = 1.0f;
        _lineStyle = DCLineTypeDefault;
        _visableSeriesAmount = 0;
        _labelFont = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        _labelColor = [UIColor whiteColor];
//        _labelAlign = DCAxisLabelAlignBottomCenter;
    }
    return self;
}
@end
