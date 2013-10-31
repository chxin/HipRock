//
//  REMTrendChartSeriesConfig.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
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
