//
//  REMNumberExtension.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 1/7/14.
//
//

#import <Foundation/Foundation.h>

@interface NSNumber(REMNumberExtension)
-(BOOL)isLessThan:(NSNumber *)other;
-(BOOL)isLessThanOrEqualTo:(NSNumber *)other;
-(BOOL)isGreaterThan:(NSNumber *)other;
-(BOOL)isGreaterThanOrEqualTo:(NSNumber *)other;
@end
