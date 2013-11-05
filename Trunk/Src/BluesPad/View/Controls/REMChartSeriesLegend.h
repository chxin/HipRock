//
//  REMChartSeriesLegend.h
//  Blues
//
//  Created by 张 锋 on 11/4/13.
//
//

#import <UIKit/UIKit.h>
#import "REMChartSeriesIndicator.h"

@interface REMChartSeriesLegend : UIControl

@property (nonatomic) int seriesIndex;
@property (nonatomic,strong) NSString *seriesName;

-(REMChartSeriesLegend *)initWithSeriesIndex:(int)index type:(REMChartSeriesIndicatorType)type andName:(NSString *)name;

@end
