//
//  REMTrendChartSeriesConfig.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/13/13.
//
//

#import "REMChartHeader.h"

@implementation REMTrendChartAxisConfig
-(REMTrendChartAxisConfig*)initWithLineStyle:(CPTLineStyle*)lineStyle gridlineStyle:(CPTLineStyle*)gridlineStyle textStyle:(CPTTextStyle*)textStyle {
    self = [super init];
    _lineStyle = lineStyle;
    _textStyle = textStyle;
    _gridlineStyle = gridlineStyle;
    _reservedSpace = [@"999,999T" sizeWithFont:[UIFont systemFontOfSize:textStyle.fontSize]];
    
    return self;
}
@end
