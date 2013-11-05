//
//  REMChartSeriesLegend.h
//  Blues
//
//  Created by 张 锋 on 11/4/13.
//
//

#import <UIKit/UIKit.h>
#import "REMChartSeriesIndicator.h"

@protocol REMChartSeriesLegendDelegate <NSObject>

-(void)legendStateChanged:(UIControlState)state onIndex:(int)index;

@end

@interface REMChartSeriesLegend : UIControl

@property (nonatomic) int seriesIndex;
@property (nonatomic,weak) NSString *seriesName;
@property (nonatomic,weak) NSObject<REMChartSeriesLegendDelegate> *delegate;

-(REMChartSeriesLegend *)initWithSeriesIndex:(int)index type:(REMChartSeriesIndicatorType)type andName:(NSString *)name;

@end
