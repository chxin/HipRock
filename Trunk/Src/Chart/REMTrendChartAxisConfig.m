//
//  REMTrendChartSeriesConfig.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/13/13.
//
//

#import "REMTrendChart.h"

@implementation REMTrendChartAxisConfig

-(id)initWithCoordinate:(CPTCoordinate)coordinate lineStyle:(CPTLineStyle*)lineStyle gridlineStyle:(CPTLineStyle*)gridlineStyle textStyle:(CPTTextStyle*)textStyle {
    self = [super init];
    _coordinate = coordinate;
    _lineStyle = lineStyle;
    _textStyle = textStyle;
    _gridlineStyle = gridlineStyle;
    _reservedSpace = [@"999,999T" sizeWithFont:[UIFont systemFontOfSize:textStyle.fontSize]];
    
    return self;
}

+(REMTrendChartAxisConfig*)getWidgetXConfig {
    CPTMutableLineStyle* lineStyle = [[CPTMutableLineStyle alloc]init];
    CPTMutableTextStyle* textStyle = [[CPTMutableTextStyle alloc]init];
    lineStyle.lineColor = [CPTColor whiteColor];
    lineStyle.lineWidth = 1.0;
    
    textStyle.fontName = @kBuildingFontSCRegular;
    textStyle.fontSize = 16.0;
    textStyle.color = [CPTColor whiteColor];
    textStyle.textAlignment = CPTTextAlignmentCenter;
    
    REMTrendChartAxisConfig* config = [[REMTrendChartAxisConfig alloc]initWithCoordinate:CPTCoordinateX lineStyle:lineStyle gridlineStyle:nil textStyle:textStyle];
    
    return config;
}

+(REMTrendChartAxisConfig*)getWidgetYConfig {
    CPTMutableLineStyle* gridlineStyle = [[CPTMutableLineStyle alloc]init];
    CPTMutableTextStyle* textStyle = [[CPTMutableTextStyle alloc]init];
    gridlineStyle.lineColor = [CPTColor whiteColor];
    gridlineStyle.lineWidth = 1.0;
    
    textStyle.fontName = @kBuildingFontSCRegular;
    textStyle.fontSize = 16.0;
    textStyle.color = [CPTColor whiteColor];
    textStyle.textAlignment = CPTTextAlignmentCenter;
    
    REMTrendChartAxisConfig* config = [[REMTrendChartAxisConfig alloc]initWithCoordinate:CPTCoordinateX lineStyle:nil gridlineStyle:gridlineStyle textStyle:textStyle];
    
    return config;
}

+(REMTrendChartAxisConfig*)getMaxWidgetXConfig {
    return [REMTrendChartAxisConfig getWidgetXConfig];
}

+(REMTrendChartAxisConfig*)getMaxWidgetYConfig {
    return [REMTrendChartAxisConfig getWidgetXConfig];
}
@end
