//
//  ChartStyle.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/11/13.
//
//

#import "REMChartStyle.h"

@implementation REMChartStyle

+(REMChartStyle*)getCoverStyle {
    REMChartStyle* style = [[REMChartStyle alloc]init];
    style.acceptPan = YES;
    style.acceptPinch = NO;
    style.acceptTap = NO;
    style.animationDuration = 0.05;
    style.xLineColor = [UIColor colorWithWhite:1 alpha:0.6];
    style.xLineWidth = 1.0;
    style.xGridlineWidth = 0.5;
    style.xGridlineColor = style.xLineColor;
    style.xGridlineStyle = DCLineTypeShortDashed;
    style.yLineColor = style.xLineColor;
    style.yLineWidth = 1;
    style.yGridlineWidth = 0.5;
    style.yGridlineColor = style.xLineColor;
    style.yGridlineStyle = style.xGridlineStyle;
    style.horizentalGridLineAmount = 5;
    style.symbolSize = 10;
    style.xLabelToLine = 6;
    style.yLabelToLine = 10;
    style.xLabelClipToBounds = NO;
    
    style.yAxisTitleToTopLabel = 2;
    style.yAxisTitleFontSize = 9;
    style.yAxisTitleColor = style.yTextColor = style.xTextColor = [UIColor whiteColor];
    style.yTextFont = style.xTextFont = [UIFont systemFontOfSize:11.0f];
    
    
    style.plotPaddingBottom = 0;
    style.plotPaddingTop = 0;
    style.plotPaddingLeft = 0;
    style.plotPaddingRight = 22;
    
    style.benchmarkColor = [REMColor colorByHexString:@"#f15e31"];
    
    
    style.playBeginAnimation = YES;
    
    return style;
}

+(REMChartStyle*)getMaximizedStyle {
    REMChartStyle* style = [[REMChartStyle alloc]init];
    style.acceptPan = YES;
    style.acceptPinch = YES;
    style.acceptTap = YES;
    style.animationDuration = 0.05;
    style.xLineColor = [REMColor colorByHexString:@"#9d9d9d"];
    style.xLineWidth = 2.0;
    style.yGridlineColor = [REMColor colorByHexString:@"#eaeaea"];
    style.yGridlineWidth = 1.0;
    style.yGridlineStyle = DCLineTypeDefault;
    style.xGridlineColor = [REMColor colorByHexString:@"#eaeaea"];
    style.xGridlineWidth = 0.0;
    style.xGridlineStyle = DCLineTypeDefault;
    style.horizentalGridLineAmount = 6;
    style.symbolSize = 14;
    style.xLabelToLine = 12;
    style.yLabelToLine = 12;
    style.yAxisTitleColor = [REMColor colorByHexString:@"#3b3b3b"];
    style.yAxisTitleToTopLabel = 10;
    style.yAxisTitleFontSize = 13;
    style.yTextColor = style.xTextColor = [REMColor colorByHexString:@"#969696"];
    style.yTextFont = style.xTextFont = [UIFont fontWithName:@kBuildingFontSCRegular size:15.0];
    style.xLabelClipToBounds = YES;
    
    style.indicatorColor = [REMColor colorByHexString:@"#f4f4f4"];
    style.focusSymbolLineStyle = DCLineTypeDefault;
    style.focusSymbolLineWidth = 2;
    style.focusSymbolIndicatorSize = 40;
    
    style.piePercentageTextHidden = NO;
    style.piePercentageTextRadius = 144;
    style.piePercentageTextColor = [UIColor whiteColor];
    style.piePercentageTextFont = [UIFont fontWithName:@kBuildingFontSCRegular size:15.0];
    
    style.pieRadius = 180;
    style.pieShadowRadius = 188;
    
    style.plotPaddingBottom = 22;
    style.plotPaddingTop = 22;
    style.plotPaddingLeft = 22;
    style.plotPaddingRight = 22;
    
    style.benchmarkColor = [REMColor colorByHexString:@"#f15e31"];
    
    style.backgroundBandFontColor = [REMColor colorByHexString:@"#3b3b3b"];
    style.backgroundBandFont = [UIFont fontWithName:@(kBuildingFontSCRegular) size:12];
    
    style.playBeginAnimation = YES;
    
    style.labelingLineWidth = 1;
    style.labelingLineColor = [REMColor colorByHexString:@"#cfcfcf"];
    style.labelingFontName = @(kBuildingFontSCRegular);
    style.labelingTooltipArcLineWidth = 0;
    style.labelingStageMinWidth = 156;
    style.labelingStageToLineMargin = 21;
    style.labelingLabelToLineMargin = 21;
    style.labelingStageMaxWidth = 403;
    style.labelingLabelWidth = 123;
    style.labelingLabelHeight = 84;
    style.labelingStageToStageTextMargin = 16;
    style.labelingStageToBorderMargin = 66;
    style.labelingStageFontColor = [REMColor colorByHexString:@"#3b3b3b"];
    style.labelingTooltipIconLeftMargin = 12;
    style.labelingTooltipIconRadius = 14;
    style.labelingTooltipIconFontSize = 22;
    style.labelingTooltipIconFontLeftMargin = 24;
    style.labelingTooltipIconFontTopMargin = 1;
    style.labelingStageFontSize = 31;
    style.labelingStageFontRightMargin = 27;
    style.labelingStageFontTopMargin = 2;
    style.labelingLabelFontSize = 65;
    style.labelingLabelFontRightMargin = 10;
    style.labelingLabelFontTopMargin = 14;
    style.labelingEffectFontSize = 18;
    style.labelingLabelValueFontColor = [REMColor colorByHexString:@"#3b3b3b"];
    style.labelingLabelValueFontSize = 20;
    style.labelingLabelValueFontTopMarginToLabel = 10;
    style.labelingLabelTagNameTopMargin = 20;
    style.labelingStageHeightFor3Levels = 84;
    style.labelingStageHeightFor4Levels = 80;
    style.labelingStageHeightFor5Levels = 70;
    style.labelingStageHeightFor6Levels = 54;
    style.labelingStageHeightFor7Levels = 48;
    style.labelingStageHeightFor8Levels = 44;
    style.labelingLabelTagNameFontSize = 20;
    style.labelingRadius = 2;
    style.labelingTooltipViewFontSize = 14;
    style.labelingTooltipViewFontColor = [REMColor colorByHexString:@"#373737"];
    style.labelingTooltipViewHeight = 57;
    style.labelingTooltipViewCornerRadius = 5;
    style.labelingTooltipViewHPadding = 48;
    style.labelingTooltipViewVPadding = 4;
    style.labelingTooltipViewTriangleHeight = 11;
    style.labelingTooltipViewTriangleWidth = 23;
    style.labelingTooltipViewTriangleMinPaddingToEdge = 10;
    
    return style;
}
+(REMChartStyle*)getMinimunStyle {
    REMChartStyle* style = [[REMChartStyle alloc]init];
    style.acceptPan = NO;
    style.acceptPinch = NO;
    style.acceptTap = NO;
    style.animationDuration = 0.05;
    style.xLineColor = [REMColor colorByHexString:@"#9d9d9d"];
    style.xLineWidth = 1.0;
    style.yGridlineColor = [REMColor colorByHexString:@"#eaeaea"];
    style.yGridlineWidth = 1.0;
    style.yGridlineStyle = DCLineTypeDefault;
    style.xGridlineColor = [REMColor colorByHexString:@"#eaeaea"];
    style.xGridlineWidth = 0.0;
    style.xGridlineStyle = DCLineTypeDefault;
    style.yTextColor = style.xTextColor = [REMColor colorByHexString:@"#969696"];
    style.yTextFont = style.xTextFont = [UIFont fontWithName:@kBuildingFontSCRegular size:10.0];
    style.horizentalGridLineAmount = 4;
    style.symbolSize = 4;
    style.xLabelToLine = 4;
    style.yLabelToLine = 4;
    style.yAxisTitleColor = [REMColor colorByHexString:@"#3b3b3b"];
    style.yAxisTitleToTopLabel = 0;
    style.yAxisTitleFontSize = 8;
    style.xLabelClipToBounds = YES;
    
    style.plotPaddingBottom = 0;
    style.plotPaddingTop = 0;
    style.plotPaddingLeft = 0;
    style.plotPaddingRight = 0;
    
    style.piePercentageTextHidden = YES;
//    style.piePercentageTextColor = [UIColor whiteColor];
//    style.piePercentageTextFont = [UIFont fontWithName:@kBuildingFontSCRegular size:15.0];
    style.pieRadius = 30;
    style.pieShadowRadius = 33;
    
    style.plotPaddingTop = 12;
    
    style.benchmarkColor = [REMColor colorByHexString:@"#f15e31"];
    
    style.backgroundBandFontColor = [REMColor colorByHexString:@"#3b3b3b"];
    style.backgroundBandFont = [UIFont fontWithName:@(kBuildingFontSCRegular) size:8];
    
    style.playBeginAnimation = NO;
    
    style.labelingLineWidth = 0.5f;
    style.labelingLineColor = [REMColor colorByHexString:@"#cfcfcf"];
    style.labelingFontName = @(kBuildingFontSCRegular);
    style.labelingTooltipArcLineWidth = 0;
    style.labelingStageMinWidth = 39;
    style.labelingStageToLineMargin = 5;
    style.labelingLabelToLineMargin = 5;
    style.labelingStageMaxWidth = 78;
    style.labelingLabelWidth = 34;
    style.labelingLabelHeight = 18;
    style.labelingStageToStageTextMargin = 4;
    style.labelingStageToBorderMargin = 16;
    style.labelingStageFontColor = [REMColor colorByHexString:@"#3b3b3b"];
    style.labelingTooltipIconLeftMargin = 3;
    style.labelingTooltipIconRadius = 3;
    style.labelingTooltipIconFontSize = 6;
    style.labelingTooltipIconFontLeftMargin = 6;
    style.labelingTooltipIconFontTopMargin = 1;
    style.labelingStageFontSize = 6;
    style.labelingStageFontRightMargin = 4.5;
    style.labelingStageFontTopMargin = 1;
    style.labelingLabelFontSize = 11;
    style.labelingLabelFontRightMargin = 5;
    style.labelingLabelFontTopMargin = 3.5;
    style.labelingEffectFontSize = 5;
    style.labelingLabelValueFontColor = [REMColor colorByHexString:@"#3b3b3b"];
    style.labelingLabelValueFontSize = 5;
    style.labelingLabelValueFontTopMarginToLabel = 2;
    style.labelingLabelTagNameTopMargin = 2;
    style.labelingLabelTagNameFontSize = 5;
    
    style.labelingStageHeightFor3Levels = 18;
    style.labelingStageHeightFor4Levels = 14;
    style.labelingStageHeightFor5Levels = 11;
    style.labelingStageHeightFor6Levels = 9;
    style.labelingStageHeightFor7Levels = 8;
    style.labelingStageHeightFor8Levels = 7;
    style.labelingRadius = 0.7;
    
    return style;
}

@end
