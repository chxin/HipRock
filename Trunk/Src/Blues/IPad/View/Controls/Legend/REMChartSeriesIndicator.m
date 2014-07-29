/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartSeriesIndicator.m
 * Created      : 张 锋 on 11/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <QuartzCore/QuartzCore.h>
#import "REMChartSeriesIndicator.h"
#import "REMDimensions.h"
#import "REMEnum.h"
@interface REMChartSeriesIndicator()

@property (nonatomic) REMChartSeriesIndicatorType type;
@property (nonatomic,strong) UIColor *color;

@end

@implementation REMChartSeriesIndicator


+(REMChartSeriesIndicator *)indicatorWithType:(REMChartSeriesIndicatorType)type andColor:(UIColor *)color;
{
    REMChartSeriesIndicator *indicator = [[REMChartSeriesIndicator alloc] initWithFrame:CGRectMake(0, 0, kDMChart_IndicatorSize, kDMChart_IndicatorSize)];
    indicator.type = type;
    indicator.color = color;
    
    [indicator render];
    
    return indicator;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)render
{
    while (self.subviews.count != 0) {
        [self.subviews[0] removeFromSuperview];
    }
    UIView *content = nil;
    switch (self.type) {
        case REMChartSeriesIndicatorLine:
            content = [self getLineIndicator];
            break;
        case REMChartSeriesIndicatorColumn:
            content = [self getColumnIndicator];
            break;
        case REMChartSeriesIndicatorStack:
            content = [self getStackIndicator];
            break;
        case REMChartSeriesIndicatorPie:
            content = [self getPieIndicator];
            break;
            
        default:
            content = [self getLineIndicator];
            break;
    }
    
    if(content!=nil)
       [self addSubview:content];
}

-(void)renderWithType:(REMChartSeriesIndicatorType)type {
    _type = type;
    [self render];
}

-(UIView *)getLineIndicator
{
    CGFloat padding = (kDMChart_LegendItemHeight - kDMChart_IndicatorSize) / 2;
    UIView *indicator = [[UIView alloc] initWithFrame:CGRectMake(padding, padding+(kDMChart_IndicatorSize - kDMChart_IndicatorLineWidth) / 2, kDMChart_IndicatorSize, kDMChart_IndicatorLineWidth)];
    indicator.backgroundColor = self.color;
    
    return indicator;
}

-(UIView *)getColumnIndicator
{
    CGFloat padding = (kDMChart_LegendItemHeight - kDMChart_IndicatorSize) / 2;
    CGRect mainframe = CGRectMake(padding, padding, kDMChart_IndicatorSize, kDMChart_IndicatorSize);
    
    //add into view
    UIView *indicator = [[UIView alloc] initWithFrame:mainframe];
    indicator.backgroundColor = self.color;
    
    return indicator;
}

-(UIView *)getStackIndicator
{
    CGFloat padding = (kDMChart_LegendItemHeight - kDMChart_IndicatorSize) / 2;
    CGRect mainframe = CGRectMake(padding, padding, kDMChart_IndicatorSize, kDMChart_IndicatorSize);
    UIView *indicator = [[UIView alloc] initWithFrame:mainframe];
    indicator.backgroundColor = self.color;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 6, mainframe.size.width, 2)];
    line.backgroundColor = [UIColor whiteColor];
    [indicator addSubview:line];
    
    return indicator;
}

-(UIView *)getPieIndicator
{
    CGFloat padding = (kDMChart_LegendItemHeight - kDMChart_IndicatorSize) / 2;
    UIView *indicator = [[UIView alloc] initWithFrame:CGRectMake(padding, padding, kDMChart_IndicatorSize, kDMChart_IndicatorSize)];
    indicator.layer.cornerRadius = kDMChart_IndicatorSize / 2;
    indicator.layer.backgroundColor = self.color.CGColor;
    
    return indicator;
}

@end
