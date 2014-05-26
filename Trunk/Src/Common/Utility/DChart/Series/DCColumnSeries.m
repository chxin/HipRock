//
//  DCColumnSeries.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/13/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "DCColumnSeries.h"
#import "_DCColumnsLayer.h"

@implementation DCColumnSeries
-(DCSeries*)init {
    self = [super init];
    if (self) {
        self.type = DCSeriesTypeColumn;
    }
    return self;
}
@end
