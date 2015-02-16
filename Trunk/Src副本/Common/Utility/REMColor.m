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
                        @"#3399cc", //#1
                        @"#99cc66",
                        @"#996699",
                        @"#cccc33",
                        @"#663366",
                        @"#cc6666", //#6
                        @"#6699cc",
                        @"#cc9999",
                        @"#cc3399",
                        @"#cccc00",
                        @"#cc6633", //#11
                        @"#336666",
                        @"#669933",
                        @"#6699ff",
                        @"#66cccc",
                        @"#3399ff", //#16
                        @"#66cc66",
                        @"#996699",
                        @"#999966",
                        @"#669999",
                        @"#996666", //#21
                        @"#666699",
                        @"#669966",
                        @"#cc3366",
                        @"#99cc00",
                        @"#cc9933", //#26
                        @"#666666",
                        @"#99cc99",
                        @"#ffcc66",
                        @"#336699"];
    
    return chartColor;
}

+ (NSArray*)labelingColors {
    return @[
             @"#33963f",
             @"#40d12c",
             @"#95eb40",
             @"#fffc2a",
             @"#ffd92a",
             @"#fcaf35",
             @"#fc7b35",
             @"#eb4040"
             ];
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

+(UIColor*)getLabelingColor:(uint)index stageCount:(uint)stageCount {
    NSArray* hexes;
    NSArray* labelingColors = [self labelingColors];
    switch (stageCount) {
        case 0:
        case 1:
        case 2:
        case 3:
            hexes = @[labelingColors[0], labelingColors[3], labelingColors[7]];
            break;
        case 4:
            hexes = @[labelingColors[0], labelingColors[2], labelingColors[3], labelingColors[7]];
            break;
        case 5:
            hexes = @[labelingColors[0], labelingColors[1], labelingColors[3], labelingColors[6], labelingColors[7]];
            break;
        case 6:
            hexes = @[labelingColors[0], labelingColors[1], labelingColors[2], labelingColors[4], labelingColors[6], labelingColors[7]];
            break;
        case 7:
            hexes = @[labelingColors[0], labelingColors[1], labelingColors[2], labelingColors[3], labelingColors[4], labelingColors[6], labelingColors[7]];
            break;
        default:
            hexes = labelingColors;
            break;
    }
    return [self colorByHexString:hexes[index]];
}


+ (UIColor *)colorByIndex:(uint)index
{
    uint colorIndex = index % [REMColor sharedChartColor].count;
    uint colorDarken = floor(index / [REMColor sharedChartColor].count);

    NSString *color= [REMColor sharedChartColor][colorIndex];
    UIColor *uiColor= [REMColor colorByHexString:color];
    
    for (uint i = 0; i < colorDarken; i++) {
        uiColor = [self darkerColorForColor:uiColor];
    }
    
    return uiColor;
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
