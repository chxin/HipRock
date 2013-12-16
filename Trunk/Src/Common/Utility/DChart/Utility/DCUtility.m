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

+(DCYAxisIntervalCalculation)calculatorYAxisByMin:(double)yMin yMax:(double)yMax parts:(NSUInteger)parts {
    DCYAxisIntervalCalculation cal;
    if (yMax <= 0 || yMax < yMin) {
        cal.yInterval = 1;
        cal.yMax = cal.yInterval * parts * kDCReservedSpace;
    } else if(parts == 0) {
        cal.yInterval = yMax;
        cal.yMax = cal.yInterval * kDCReservedSpace;
    } else {
        double avg = (yMin + yMax ) / 2;
        double possibleMax = MAX(yMax, avg / 0.75 / kDCReservedSpace);
        // 计算Interval的位数
        double yIntervalMag = possibleMax / parts;
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
        cal.yInterval = [self roundYInterval:(possibleMax / parts / mag)] * mag;
        cal.yMax = cal.yInterval * parts * kDCReservedSpace;
    }
    return cal;
}
+(double)roundYInterval:(float)yInterval {
    for (double i = 1.0; i <= 10; i=i+0.5) {
        if (yInterval <= i) {
            return i;
        }
    }
    return 10;
}

+(void)setLineStyle:(CGContextRef)context style:(DCLineType)style lineWidth:(CGFloat)lineWidth {
    if (style == DCLineTypeDotted) {
        CGFloat dash[] = {lineWidth, lineWidth};
        CGContextSetLineDash(context, 0, dash, 2);
    } else if (style == DCLineTypeDashed) {
        CGFloat dash[] = {lineWidth*4, lineWidth};
        CGContextSetLineDash(context, 0, dash, 2);
    }
}

//+(BOOL)isMinorChangeForYRange:(DCRange*)oldRange new:(DCRange*)newRange {
//    YES;
//}



+(BOOL)isFrame:(CGRect)rect visableIn:(CGRect)outter {
    if (rect.origin.x >= outter.size.width || rect.origin.y >= outter.size.height
        || rect.origin.x+rect.size.width <= 0 || rect.origin.y+rect.size.height<=0) return NO;
    return YES;
}

+(double)getScreenXIn:(CGRect)plotRect xVal:(double)xValue hRange:(DCRange*)hRange {
    return plotRect.origin.x + plotRect.size.width * (xValue-hRange.location) / hRange.length;
}
@end
