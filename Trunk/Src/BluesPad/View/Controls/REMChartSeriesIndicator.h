//
//  REMChartSeriesIndicator.h
//  Blues
//
//  Created by 张 锋 on 11/4/13.
//
//

#import <UIKit/UIKit.h>

typedef enum _REMChartSeriesIndicatorType{
    REMChartSeriesIndicatorLine,
    REMChartSeriesIndicatorColumn,
    REMChartSeriesIndicatorPie,
} REMChartSeriesIndicatorType;

@interface REMChartSeriesIndicator : UIView


+(REMChartSeriesIndicator *)indicatorWithType:(REMChartSeriesIndicatorType)type andColor:(UIColor *)color;

@end
