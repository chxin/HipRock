/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTrendChartSeriesConfig.m
 * Created      : Zilong-Oscar.Xu on 9/13/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
