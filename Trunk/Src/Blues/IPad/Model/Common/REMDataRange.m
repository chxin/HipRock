/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMDataRange.m
 * Created      : 张 锋 on 8/12/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
    REMDataRange *newRange = [[REMDataRange alloc] init];
    
    
    double distance = [self distance];
    
    newRange.start = self.start - (distance*factor);
    newRange.end = self.end + (distance*factor);
    
    return newRange;
}

- (BOOL)isValueInside:(double)value
{
    return self.start <= value && self.end >= value;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"{%f,%f}", self.start, self.end];
}

@end
