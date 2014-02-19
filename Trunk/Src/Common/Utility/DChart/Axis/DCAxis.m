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
@property (nonatomic, strong) NSMutableArray* seriesList;
@end

@implementation DCAxis
-(id)init {
    self = [super init];
    if (self) {
        _seriesList = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)attachSeries:(DCSeries *)series {
    [self.seriesList addObject:series];
}

-(void)detachSeries:(DCSeries *)series {
    [self.seriesList removeObject:series];
}

-(NSUInteger)getVisableSeriesAmount {
    NSUInteger count = 0;
    for (DCXYSeries* s in self.seriesList) {
        if (!s.hidden) count++;
    }
    return count;
}
@end
