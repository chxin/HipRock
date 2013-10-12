//
//  REMTrendChartSeriesConfig.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/13/13.
//
//

#import "REMChartHeader.h"

@implementation REMTrendChartAxisConfig

-(id)initWithLineStyle:(CPTLineStyle*)lineStyle gridlineStyle:(CPTLineStyle*)gridlineStyle textStyle:(CPTTextStyle*)textStyle {
    self = [super init];
    _lineStyle = lineStyle;
    _textStyle = textStyle;
    _gridlineStyle = gridlineStyle;
    _reservedSpace = [@"999,999T" sizeWithFont:[UIFont systemFontOfSize:textStyle.fontSize]];
    
    return self;
}

+(REMTrendChartAxisConfig*)getMinWidgetXConfig {
    CPTMutableLineStyle* lineStyle = [[CPTMutableLineStyle alloc]init];
    CPTMutableTextStyle* textStyle = [[CPTMutableTextStyle alloc]init];
    lineStyle.lineColor = [CPTColor whiteColor];
    lineStyle.lineWidth = 1.0;
    
    textStyle.fontName = @kBuildingFontSCRegular;
    textStyle.fontSize = 10.0;
    textStyle.color = [CPTColor whiteColor];
    textStyle.textAlignment = CPTTextAlignmentCenter;
    
    REMTrendChartAxisConfig* config = [[REMTrendChartAxisConfig alloc]initWithLineStyle:lineStyle gridlineStyle:nil textStyle:textStyle];
    
    return config;
}

+(REMTrendChartAxisConfig*)getMinWidgetYConfig {
    CPTMutableLineStyle* gridlineStyle = [[CPTMutableLineStyle alloc]init];
    CPTMutableTextStyle* textStyle = [[CPTMutableTextStyle alloc]init];
    gridlineStyle.lineColor = [CPTColor whiteColor];
    gridlineStyle.lineWidth = 1.0;
    
    textStyle.fontName = @kBuildingFontSCRegular;
    textStyle.fontSize = 10.0;
    textStyle.color = [CPTColor whiteColor];
    textStyle.textAlignment = CPTTextAlignmentCenter;
    
    REMTrendChartAxisConfig* config = [[REMTrendChartAxisConfig alloc]initWithLineStyle:nil gridlineStyle:gridlineStyle textStyle:textStyle];
    
    return config;
}

+(REMTrendChartAxisConfig*)getMaxWidgetXConfig {
    CPTMutableLineStyle* gridlineStyle = [[CPTMutableLineStyle alloc]init];
    CPTMutableTextStyle* textStyle = [[CPTMutableTextStyle alloc]init];
    gridlineStyle.lineColor = [CPTColor whiteColor];
    gridlineStyle.lineWidth = 1.0;
    
    textStyle.fontName = @kBuildingFontSCRegular;
    textStyle.fontSize = 16.0;
    textStyle.color = [CPTColor whiteColor];
    textStyle.textAlignment = CPTTextAlignmentCenter;
    
    REMTrendChartAxisConfig* config = [[REMTrendChartAxisConfig alloc]initWithLineStyle:nil gridlineStyle:gridlineStyle textStyle:textStyle];
    
    return config;
}

+(REMTrendChartAxisConfig*)getMaxWidgetYConfig {
    CPTMutableLineStyle* gridlineStyle = [[CPTMutableLineStyle alloc]init];
    CPTMutableTextStyle* textStyle = [[CPTMutableTextStyle alloc]init];
    gridlineStyle.lineColor = [CPTColor whiteColor];
    gridlineStyle.lineWidth = 1.0;
    
    textStyle.fontName = @kBuildingFontSCRegular;
    textStyle.fontSize = 16.0;
    textStyle.color = [CPTColor whiteColor];
    textStyle.textAlignment = CPTTextAlignmentCenter;
    
    REMTrendChartAxisConfig* config = [[REMTrendChartAxisConfig alloc]initWithLineStyle:nil gridlineStyle:gridlineStyle textStyle:textStyle];
    
    return config;
}
@end
