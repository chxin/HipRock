/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartToolTip.h
 * Created      : 张 锋 on 11/5/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMChartSeriesIndicator.h"

@interface REMChartTooltipItemModel : NSObject

@property (nonatomic) int index;
@property (nonatomic,strong) NSNumber *identity;
@property (nonatomic) REMChartSeriesIndicatorType type;
@property (nonatomic,strong) UIColor *color;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSNumber *value;

@end

@interface REMChartTooltipItem : UIControl

@property (nonatomic,weak) REMChartTooltipItemModel *model;

- (id)initWithFrame:(CGRect)frame andData:(REMChartTooltipItemModel *)model;
- (void)updateModel:(REMChartTooltipItemModel *)model;


@end
