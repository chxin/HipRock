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


#define kIndicatorSize 16
#define kNameLabelFontSize kIndicatorSize
#define kValueLabelFontSize 22

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
        self.backgroundColor = [UIColor whiteColor];
        
        CGSize nameLabelSize = [name sizeWithFont:[UIFont systemFontOfSize:kNameLabelFontSize]];
        CGSize valueLabelSize = [[dataValue stringValue] sizeWithFont:[UIFont systemFontOfSize:kValueLabelFontSize]];
        
        NSLog(@"name size: %@", NSStringFromCGSize(nameLabelSize));
        NSLog(@"value size: %@", NSStringFromCGSize(valueLabelSize));
        
        CGFloat contentHeight = kIndicatorSize*2 + valueLabelSize.height;
        CGFloat firstLineTopOffset = (frame.size.height - contentHeight) / 2;
        CGFloat secondLineTopOffset = firstLineTopOffset + 2*kIndicatorSize;
        
        // Indicator
        REMChartSeriesIndicator *indicator = [REMChartSeriesIndicator indicatorWithType:REMChartSeriesIndicatorColumn andColor:color];
        CGRect indicatorFrame =indicator.frame;
        indicatorFrame.origin.y = firstLineTopOffset;
        indicator.frame = indicatorFrame;
        
        [self addSubview:indicator];
        
        // Name label
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*kIndicatorSize, firstLineTopOffset, frame.size.width - 2*kIndicatorSize, nameLabelSize.height)];
        nameLabel.text = name;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:kNameLabelFontSize];
        nameLabel.textColor = [UIColor blackColor];
        
        [self addSubview:nameLabel];
        
        // Value label
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, secondLineTopOffset, frame.size.width, valueLabelSize.height)];
        valueLabel.text = [dataValue stringValue];
        valueLabel.backgroundColor = [UIColor clearColor];
        valueLabel.font = [UIFont systemFontOfSize:kValueLabelFontSize];
        valueLabel.textColor = [UIColor lightGrayColor];
        
        [self addSubview:valueLabel];
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
