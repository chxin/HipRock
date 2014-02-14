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
-(DCSeries*)initWithEnergyData:(NSArray*)seriesData {
    self = [super initWithEnergyData:seriesData];
    if (self) {
        self.type = DCSeriesTypeColumn;
    }
    return self;
}

-(void)setHidden:(BOOL)hidden {
    if (self.hidden != hidden) {
        [super setHidden:hidden];
        [(_DCColumnsLayer*)self.layer redraw];
    }
}
@end
