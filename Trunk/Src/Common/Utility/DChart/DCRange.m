//
//  DCRange.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/11/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "DCRange.h"

@implementation DCRange
-(DCRange*)initWithLocation:(double)location length:(double)length {
    self = [super init];
    if (self) {
        _length = length;
        _location = location;
    }
    return self;
}
-(id)copy {
    return [[DCRange alloc]initWithLocation:self.location length:self.length];
}

+(BOOL)isRange:(DCRange*)aRange equalTo:(DCRange*)bRange {
    if (aRange == bRange) return YES;
    if (aRange == nil || bRange == nil) return NO;
    
    return aRange.location == bRange.location && aRange.length == bRange.length;
}
-(BOOL)isVisableIn:(DCRange*)bRange {
    return (self.location <= bRange.length+bRange.location && self.location >= bRange.location) ||
    (self.location+self.length <= bRange.length+bRange.location && self.location+self.length >= bRange.location);
}
@end
