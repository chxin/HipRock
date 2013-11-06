/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartToolTip.m
 * Created      : 张 锋 on 11/5/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <QuartzCore/QuartzCore.h>
#import "REMChartTooltipItem.h"
#import "REMChartSeriesIndicator.h"

@interface REMChartTooltipItem()

@property (nonatomic,weak) REMChartSeriesIndicator *indicator;
@property (nonatomic,weak) UILabel *nameLabel;
@property (nonatomic,weak) UILabel *valueLabel;

@end

@implementation REMChartTooltipItem

- (id)initWithFrame:(CGRect)frame withName:(NSString *)name color:(UIColor *)color andValue:(NSNumber *)dataValue
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 1.0f;
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
