//
//  DCDataPoint.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/8/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "DCDataPoint.h"
@interface DCDataPoint()

@property (unsafe_unretained) NSUInteger hashForCopy;

@end

@implementation DCDataPoint

- (id)copyWithZone:(NSZone *)zone {
    DCDataPoint *result = [[DCDataPoint alloc] init];
    if (result) {
        result.value = [self.value copyWithZone:zone];
        result.hashForCopy = self.hashForCopy;
    }
    return result;
}
-(id)init
{
    if (self = [super init]) {
        _hashForCopy = (NSUInteger)self;
    }
    return self;
}
- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[DCDataPoint class]]) {
        return self.hashForCopy == ((DCDataPoint *)object).hashForCopy;
    } else {
        return NO;
    }
}
-(NSUInteger)hash {
    return self.hashForCopy;
}
@end
