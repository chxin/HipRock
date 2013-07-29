//
//  REMColor.m
//  Blues
//
//  Created by TanTan on 7/1/13.
//
//

#import "REMColor.h"

static NSArray *chartColor;

@implementation REMColor

+ (NSArray *) sharedChartColor{
    chartColor=@[
                        @"#30a0d4",
                        @"#9ac350",
                        @"#9d6ba4",
                        @"#aa9465",
                        @"#74939b",
                        @"#b9686e",
                        @"#6887c5",
                        @"#8aa386",
                        @"#b93d95",
                        @"#c2c712",
                        @"#c8693f",
                        @"#718b80",
                        @"#908d52",
                        @"#3187b7",
                        @"#4098a7"];
    
    return chartColor;
}

+ (UIColor *)colorByHexString:(NSString *)hexString
{
    unsigned rgbValue=0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:
            ((rgbValue & 0xFF0000)>>16)/255.00
                                     green:((rgbValue & 0xFF00) >> 8)/255.00
                                      blue:((rgbValue & 0xFF)/255.00) alpha:1.0];
    
    
}

+ (CPTColor *)colorByIndex:(uint)index
{
    NSString *color= [REMColor sharedChartColor][index];

    UIColor *uiColor= [REMColor colorByHexString:color];
    
   return [CPTColor colorWithCGColor:uiColor.CGColor];
    
    
}


@end
