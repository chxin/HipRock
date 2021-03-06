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
#import "DCChartEnum.h"

typedef struct _DCYAxisIntervalCalculation {
    double yMax;
    double yInterval;
}DCYAxisIntervalCalculation;

@interface DCUtility : NSObject
+(CGSize)getSizeOfText:(NSString*)text forFont:(UIFont*)font;

+(void)setLineStyle:(CGContextRef)context style:(DCLineType)style lineWidth:(CGFloat)lineWidth;
+(DCYAxisIntervalCalculation)calculatorYAxisByMin:(double)yMin yMax:(double)yMax parts:(NSUInteger)parts;
//+(BOOL)isMinorChangeForYRange:(DCRange*)oldRange new:(DCRange*)newRange;
+(BOOL)isFrame:(CGRect)rect visableIn:(CGRect)outter;

+(double)getScreenXIn:(CGRect)plotRect xVal:(double)xValue hRange:(DCRange*)hRange;
+(double)getScreenYIn:(CGRect)plotRect yVal:(double)yValue vRange:(DCRange*)vRange;
+(void)drawText:(NSString*)text inContext:(CGContextRef)ctx font:(UIFont*)font rect:(CGRect)rect alignment:(NSTextAlignment)alignment lineBreak:(NSLineBreakMode)lineBreak color:(UIColor*)color;
+(void)runFunction:(void (^)())fn withDelay:(double)delay;
@end
