//
//  DCUtility.h
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/13/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCRange.h"
#import "DCContext.h"

@interface DCUtility : NSObject
+(CGSize)getSizeOfText:(NSString*)text forFont:(UIFont*)font;

+(void)setLineStyle:(CGContextRef)context style:(DCLineType)style;
+(double)getYInterval:(double)yRangeLength parts:(NSUInteger)parts;
@end
