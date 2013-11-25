//
//  DCUtility.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/13/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "DCUtility.h"

@implementation DCUtility
+(CGSize)getSizeOfText:(NSString*)text forFont:(UIFont*)font {
    return [text sizeWithFont:font];
}

+(double)getYInterval:(double)yRangeLength parts:(NSUInteger)parts {
    if (yRangeLength <= 0) return parts;
    
    double yIntervalMag = yRangeLength / parts;
    double mag = 1;
    if (yIntervalMag > 10) {
        int yIntervalFLOOR = floor(yIntervalMag);
        NSUInteger digitalOfYInterval = ((NSString*)[NSString stringWithFormat:@"%i", yIntervalFLOOR]).length;
        mag = pow(10, digitalOfYInterval-1);
    } else if (yIntervalMag < 1) {
        while (yIntervalMag < 1) {
            mag /= 10;
            yIntervalMag*=10;
        }
    }
    return [self roundYInterval:(yRangeLength / parts / mag)] * mag;
}
+(double)roundYInterval:(float)yInterval {
    for (double i = 1.0; i <= 10; i=i+0.1) {
        if (yInterval <= i) {
            return i;
        }
    }
    return 10;
}

+(void)setLineStyle:(CGContextRef)context style:(DCLineType)style {
    if (style == DCLineTypeDotted) {
        CGFloat dash[] = {1, 1};
        CGContextSetLineDash(context, 0, dash, 2);
    }
}

+(BOOL)isMinorChangeForYRange:(DCRange*)oldRange new:(DCRange*)newRange {
    if (oldRange.length > newRange.length) {
        return oldRange.length/newRange.length <= kDCYRangeChangeDetection;
    } else {
        return newRange.length/oldRange.length <= kDCYRangeChangeDetection;
    }
}



+(BOOL)isFrame:(CGRect)rect visableIn:(CGRect)outter {
    if (rect.origin.x >= outter.size.width || rect.origin.y >= outter.size.height
        || rect.origin.x+rect.size.width <= 0 || rect.origin.y+rect.size.height<=0) return NO;
    return YES;
}

+(double)getScreenXIn:(CGRect)plotRect xVal:(double)xValue hRange:(DCRange*)hRange {
    return plotRect.origin.x + plotRect.size.width * (xValue-hRange.location) / hRange.length;
}
@end
