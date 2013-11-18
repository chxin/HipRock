//
//  DCXYSeries.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/8/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "DCXYSeries.h"

@implementation DCXYSeries

-(void)didHRangeChanged:(DCRange*)oldRange newRange:(DCRange*)newRange {
    if ([DCRange isRange:oldRange equalTo:newRange]) return;
    if (newRange != nil && newRange.location < -0.5) return;
    int start = floor(newRange.location);
    int end = ceil(newRange.length+newRange.location);
    DCRange* newVisableRange = [[DCRange alloc]initWithLocation:start length:end-start+1];
    if ([DCRange isRange:self.visableRange equalTo:newVisableRange]) return;
    _visableRange = newVisableRange;
    
    start = start < 0 ? 0 : start;
    end = end >= self.datas.count ? (self.datas.count - 1) : end;
    
    NSNumber* y = @(0);
    for (int i = start; i <= end; i++) {
        DCDataPoint* p = self.datas[i];
        if (p.value == nil || [p.value isEqual:[NSNull null]]) continue;
        if ([y compare:p.value] == NSOrderedAscending) {
            y = p.value;
        }
    }
    _visableYMax = y;
}

@end