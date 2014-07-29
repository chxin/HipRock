/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartSeriesIndicator.h
 * Created      : 张 锋 on 11/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMEnum.h"

typedef enum _REMChartSeriesIndicatorType{
    REMChartSeriesIndicatorLine,
    REMChartSeriesIndicatorColumn,
    REMChartSeriesIndicatorStack,
    REMChartSeriesIndicatorPie,
} REMChartSeriesIndicatorType;

@interface REMChartSeriesIndicator : UIView

+(REMChartSeriesIndicator *)indicatorWithType:(REMChartSeriesIndicatorType)type andColor:(UIColor *)color;
-(void)renderWithType:(REMChartSeriesIndicatorType)type;

@end
