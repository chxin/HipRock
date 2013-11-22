/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMColor.m
 * Created      : TanTan on 7/1/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
    return [self colorByHexString:hexString alpha:1.0];
}

+ (UIColor *)colorByHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    unsigned rgbValue=0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:
            ((rgbValue & 0xFF0000)>>16)/255.00
                           green:((rgbValue & 0xFF00) >> 8)/255.00
                            blue:((rgbValue & 0xFF)/255.00) alpha:alpha];
    
    
}

+(UIColor*)makeTransparent:(CGFloat)alpha withColor:(UIColor*)color {
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

+ (CPTColor *)colorByIndex:(uint)index
{
    uint colorIndex = index % [REMColor sharedChartColor].count;
    uint colorDarken = floor(index / [REMColor sharedChartColor].count);

    NSString *color= [REMColor sharedChartColor][colorIndex];
    UIColor *uiColor= [REMColor colorByHexString:color];
    
    for (uint i = 0; i < colorDarken; i++) {
        uiColor = [self darkerColorForColor:uiColor];
    }
    
    return [CPTColor colorWithCGColor:uiColor.CGColor];
}
+ (UIColor *)lighterColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + 0.2, 1.0)
                               green:MIN(g + 0.2, 1.0)
                                blue:MIN(b + 0.2, 1.0)
                               alpha:a];
    return nil;
}

+ (UIColor *)darkerColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.2, 0.0)
                               green:MAX(g - 0.2, 0.0)
                                blue:MAX(b - 0.2, 0.0)
                               alpha:a];
    return nil;
}

@end
