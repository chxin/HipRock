//
//  REMDataRange.m
//  Blues
//
//  Created by 张 锋 on 8/12/13.
//
//

#import "REMDataRange.h"

@implementation REMDataRange

- (REMDataRange *)initWithConstants
{
    self = [super init];
    
    if(self){
        self.start = INT64_MAX;
        self.end = INT64_MIN;
    }
    
    return self;
}

- (REMDataRange *)initWithStart:(double)start andEnd:(double)end
{
    self = [super init];
    
    if(self){
        self.start = start;
        self.end = end;
    }
    
    return self;
}

- (double)distance
{
    return self.end - self.start;
}

- (REMDataRange *)expandByFactor:(float)factor
{
    REMDataRange *newRange = [self copy];
    
    double distance = [self distance];
    
    newRange.start = newRange.start - (distance*factor);
    newRange.end = newRange.end + (distance*factor);
    
    return newRange;
}

@end
