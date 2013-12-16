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
    REMChartStyle* style = [[REMChartStyle alloc]init];
    style.userInteraction = YES;
    style.animationDuration = 0.05;
    style.xLineColor = [REMColor colorByHexString:@"#9d9d9d"];
    style.xLineWidth = 4.0;
    style.yGridlineColor = [REMColor colorByHexString:@"#eaeaea"];
    style.yGridlineWidth = 1.0;
    style.horizentalGridLineAmount = 6;
    style.symbolSize = 20;
    style.xLabelToLine = 12;
    style.yLabelToLine = 12;
    style.yAxisTitleColor = [REMColor colorByHexString:@"#3b3b3b"];
    style.yAxisTitleToTopLabel = 10;
    style.yAxisTitleFontSize = 13;
    style.yTextColor = style.xTextColor = [REMColor colorByHexString:@"#969696"];
    style.yTextFont = style.xTextFont = [UIFont fontWithName:@kBuildingFontSCRegular size:15.0];
    
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
    
    style.labelingLineWidth = 2;
    style.labelingLineColor = [UIColor grayColor];
    style.labelingFontName = @(kBuildingFontSC);
    style.labelingTooltipArcLineWidth = 2;
    
    return style;
}
+(REMChartStyle*)getMinimunStyle {
    REMChartStyle* style = [[REMChartStyle alloc]init];
    style.userInteraction = NO;
    style.animationDuration = 0.05;
    style.xLineColor = [REMColor colorByHexString:@"#9d9d9d"];
    style.xLineWidth = 2.0;
    style.yGridlineColor = [REMColor colorByHexString:@"#eaeaea"];
    style.yGridlineWidth = 1.0;
    style.yTextColor = style.xTextColor = [REMColor colorByHexString:@"#969696"];
    style.yTextFont = style.xTextFont = [UIFont fontWithName:@kBuildingFontSCRegular size:10.0];
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
    
    style.labelingLineWidth = 1;
    style.labelingLineColor = [UIColor grayColor];
    style.labelingFontName = @(kBuildingFontSC);
    style.labelingTooltipArcLineWidth = 0.5;
    
    return style;
}

@end
