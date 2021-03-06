/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartSeriesLegend.h
 * Created      : 张 锋 on 11/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMChartSeriesIndicator.h"
#import "DCSeries.h"
@class REMChartLegendBase;



@protocol REMChartLegendItemDelegate <NSObject>

-(void)legendStateChanged:(UIControlState)state onIndex:(int)index;
-(BOOL)canBeHiddenOnIndex:(int)index;

-(void)tapLegendIconOnIndex:(int)index;
-(BOOL)canChangeSeriesTypeOnIndex:(int)index;

@end


@interface REMChartLegendItemModel : NSObject

@property (nonatomic) int index;
@property (nonatomic) REMChartSeriesIndicatorType type;
@property (nonatomic,weak) NSString *title;
@property (nonatomic,strong) UIColor* color;
//@property (nonatomic) BOOL isBenchmark;
@property (nonatomic,weak) REMChartLegendBase *legendView;
@property (nonatomic) BOOL isDefaultHidden;
@property (nonatomic,strong) NSString *key;

@end


@interface REMChartLegendItem : UIControl

-(REMChartLegendItem *)initWithFrame:(CGRect)frame andModel:(REMChartLegendItemModel *)model;
-(void)setSelected:(BOOL)selected;
-(void)refreshStatus;

@end