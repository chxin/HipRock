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
    style.symbolSize = 20;
    style.xLabelToLine = 12;
    style.yLabelToLine = 12;
    style.yAxisTitleColor = [REMColor colorByHexString:@"#3b3b3b"];
    style.yAxisTitleToTopLabel = 10;
    style.yAxisTitleFontSize = 13;
    
    style.focusSymbolLineColor = [REMColor colorByHexString:@"#f4f4f4"];
    style.focusSymbolLineStyle = DCLineTypeDefault;
    style.focusSymbolLineWidth = 2;
    style.focusSymbolIndicatorSize = 40;
    
    style.pieRadius = 180;
    style.pieShadowRadius = 190;
    
    style.plotPaddingBottom = 22;
    style.plotPaddingTop = 22;
    style.plotPaddingLeft = 22;
    style.plotPaddingRight = 22;
    
    style.benchmarkColor = [REMColor colorByHexString:@"#f15e31"];
    
    style.backgroundBandFontColor = [REMColor colorByHexString:@"#3b3b3b"];
    style.backgroundBandFont = [UIFont fontWithName:@(kBuildingFontSCRegular) size:12];
    
    style.playBeginAnimation = YES;
    
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
    style.yAxisTitleColor = [REMColor colorByHexString:@"#3b3b3b"];
    style.yAxisTitleToTopLabel = 0;
    style.yAxisTitleFontSize = 8;
    
    style.plotPaddingBottom = 0;
    style.plotPaddingTop = 0;
    style.plotPaddingLeft = 0;
    style.plotPaddingRight = 0;
    
    style.pieRadius = 30;
    style.pieShadowRadius = 33;
    
    style.plotPaddingTop = 12;
    
    style.benchmarkColor = [REMColor colorByHexString:@"#f15e31"];
    
    style.backgroundBandFontColor = [REMColor colorByHexString:@"#3b3b3b"];
    style.backgroundBandFont = [UIFont fontWithName:@(kBuildingFontSCRegular) size:8];
    
    style.playBeginAnimation = NO;
    
    return style;
}

@end
