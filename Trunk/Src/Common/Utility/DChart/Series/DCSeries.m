//
//  DCSeries.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/8/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "DCSeries.h"

@implementation DCSeries

-(DCSeries*)initWithData:(NSArray*)seriesData {
    self = [super init];
    if (self) {
        _datas = seriesData;
    }
    return self;
}

-(void)drawToLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    // Nothing to do since it is a template.
    return;
}
@end
