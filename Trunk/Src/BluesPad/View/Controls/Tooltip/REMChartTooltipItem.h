/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartToolTip.h
 * Created      : 张 锋 on 11/5/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMChartSeriesIndicator.h"

//item model
@interface REMChartTooltipItemModel : NSObject

@property (nonatomic) int index;
@property (nonatomic,strong) NSNumber *identity;
@property (nonatomic) REMChartSeriesIndicatorType type;
@property (nonatomic,strong) UIColor *color;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSNumber *value;
@property (nonatomic,strong) NSString *uom;

@end

//ranking item model
@interface REMRankingTooltipItemModel : REMChartTooltipItemModel

@property (nonatomic) int numerator,denominator;

@end

//item view
@interface REMChartTooltipItem : UIView

@property (nonatomic,weak) REMChartTooltipItemModel *model;

+(REMChartTooltipItem *)itemWithFrame:(CGRect)frame andModel:(REMChartTooltipItemModel *)model;

- (id)initWithFrame:(CGRect)frame andData:(REMChartTooltipItemModel *)model;
- (void)updateModel:(REMChartTooltipItemModel *)model;

@end

//ranking item view
@interface REMRankingTooltipItem : REMChartTooltipItem
@end


