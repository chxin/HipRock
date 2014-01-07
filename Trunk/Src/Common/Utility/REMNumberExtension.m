//
//  REMNumberExtension.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 1/7/14.
//
//

#import "REMNumberExtension.h"

@implementation NSNumber(REMNumberExtension)
-(BOOL)isLessThan:(NSNumber *)other {
    return [self compare:other] == NSOrderedAscending;
}
-(BOOL)isLessThanOrEqualTo:(NSNumber *)other {
    return ![self isGreaterThan:other];
    
}
-(BOOL)isGreaterThan:(NSNumber *)other {
    return [self compare:other] == NSOrderedDescending;
}
-(BOOL)isGreaterThanOrEqualTo:(NSNumber *)other {
    return ![self isLessThan:other];
}
@end
