//
//  ChartStyle.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/11/13.
//
//

#import "REMChartStyle.h"

@implementation REMChartStyle

+(REMChartStyle*)getMaximizedStyle {
    CPTMutableLineStyle* gridlineStyle = [[CPTMutableLineStyle alloc]init];
    CPTMutableLineStyle* xlineStyle = [[CPTMutableLineStyle alloc]init];
    CPTMutableTextStyle* textStyle = [[CPTMutableTextStyle alloc]init];
    gridlineStyle.lineColor = [CPTColor colorWithCGColor:[REMColor colorByHexString:@"#eaeaea"].CGColor];
    gridlineStyle.lineWidth = 1.0;
    xlineStyle.lineColor = [CPTColor colorWithCGColor:[REMColor colorByHexString:@"#9d9d9d"].CGColor];
    xlineStyle.lineWidth = 4.0;
    textStyle.fontName = @kBuildingFontSCRegular;
    textStyle.fontSize = 15.0;
    textStyle.color = [CPTColor colorWithCGColor:[REMColor colorByHexString:@"#969696"].CGColor];
    textStyle.textAlignment = CPTTextAlignmentCenter;
    
    REMChartStyle* style = [[REMChartStyle alloc]init];
    style.userInteraction = YES;
    style.animationDuration = 0.05;
    style.xLineStyle = xlineStyle;
    style.yGridlineStyle = gridlineStyle;
    style.xTextStyle = textStyle;
    style.yTextStyle = textStyle;
    style.horizentalGridLineAmount = 6;
    style.symbolSize = 12;
    style.xLabelToLine = 12;
    style.yLabelToLine = 12;
    return style;
}
+(REMChartStyle*)getMinimunStyle {
    CPTMutableLineStyle* gridlineStyle = [[CPTMutableLineStyle alloc]init];
    CPTMutableLineStyle* xlineStyle = [[CPTMutableLineStyle alloc]init];
    CPTMutableTextStyle* textStyle = [[CPTMutableTextStyle alloc]init];
    gridlineStyle.lineColor = [CPTColor colorWithCGColor:[REMColor colorByHexString:@"#eaeaea"].CGColor];
    gridlineStyle.lineWidth = 1.0;
    xlineStyle.lineColor = [CPTColor colorWithCGColor:[REMColor colorByHexString:@"#9d9d9d"].CGColor];
    xlineStyle.lineWidth = 2.0;
    textStyle.fontName = @kBuildingFontSCRegular;
    textStyle.fontSize = 10.0;
    textStyle.color = [CPTColor colorWithCGColor:[REMColor colorByHexString:@"#6a6a6a"].CGColor];
    textStyle.textAlignment = CPTTextAlignmentCenter;
    
    REMChartStyle* style = [[REMChartStyle alloc]init];
    style.userInteraction = NO;
    style.animationDuration = 0.05;
    style.xLineStyle = xlineStyle;
    style.yGridlineStyle = gridlineStyle;
    style.xTextStyle = textStyle;
    style.yTextStyle = textStyle;
    style.horizentalGridLineAmount = 4;
    style.symbolSize = 4;
    style.xLabelToLine = 4;
    style.yLabelToLine = 4;
    return style;
}

@end
