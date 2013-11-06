/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartSeriesLegend.h
 * Created      : 张 锋 on 11/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMChartSeriesIndicator.h"

@protocol REMChartLegendItemDelegate <NSObject>

-(void)legendStateChanged:(UIControlState)state onIndex:(int)index;

@end

@interface REMChartLegendItem : UIControl

@property (nonatomic) int seriesIndex;
@property (nonatomic,weak) NSString *seriesName;
@property (nonatomic,weak) NSObject<REMChartLegendItemDelegate> *delegate;

-(REMChartLegendItem *)initWithSeriesIndex:(int)index type:(REMChartSeriesIndicatorType)type andName:(NSString *)name;

@end
