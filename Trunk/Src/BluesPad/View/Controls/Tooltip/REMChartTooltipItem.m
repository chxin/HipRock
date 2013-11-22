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
#import "REMCommonHeaders.h"
#import "REMDimensions.h"

@implementation REMChartTooltipItemModel
@end
@implementation REMRankingTooltipItemModel
@end

//item view
@interface REMChartTooltipItem()

@property (nonatomic,weak) UILabel *nameLabel;
@property (nonatomic,weak) UILabel *valueLabel;
@property (nonatomic,weak) REMChartSeriesIndicator *indicator;

@end

@implementation REMChartTooltipItem

+(REMChartTooltipItem *)itemWithFrame:(CGRect)frame andModel:(REMChartTooltipItemModel *)model
{
    if([model isKindOfClass:[REMRankingTooltipItemModel class]])
        return [[REMRankingTooltipItem alloc] initWithFrame:frame andData:(REMRankingTooltipItemModel *)model];
    else
        return [[REMChartTooltipItem alloc] initWithFrame:frame andData:model];
}

- (id)initWithFrame:(CGRect)frame andData:(REMChartTooltipItemModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
// Initialization code
//        self.layer.borderColor = [UIColor blueColor].CGColor;
//        self.layer.borderWidth = 1.0f;
        self.backgroundColor = [UIColor clearColor];
        
        self.model = model;
        
        // Indicator
        REMChartSeriesIndicator *indicator = [self renderIndicator:model.type :model.color];
        [self addSubview:indicator];
        self.indicator = indicator;
        
        // Name label
        UILabel *nameLabel = [self renderTitleLabel:model.title];
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // Value label
        UILabel *valueLabel = [self renderDataValueLabel:model.value];
        [self addSubview:valueLabel];
        self.valueLabel = valueLabel;
    }
    return self;
}

- (void)updateModel:(REMChartTooltipItemModel *)model
{
    self.nameLabel.text = model.title;
    
    self.valueLabel.text = [self formatDataValue:model.value];
}

//-(void)setHighlighted:(BOOL)highlighted
//{
//    [super setHighlighted:highlighted];
//    
//    UIColor *backgroundColor = highlighted?[UIColor lightGrayColor]:[UIColor whiteColor];
//    self.backgroundColor = backgroundColor;
//}

- (NSString *)formatDataValue:(NSNumber *)value
{
    //TODO: Need format
    return [value stringValue];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(REMChartSeriesIndicator *)renderIndicator:(REMChartSeriesIndicatorType)type :(UIColor *)color
{
    REMChartSeriesIndicator *indicator = [REMChartSeriesIndicator indicatorWithType:type andColor:color];
    CGRect indicatorFrame =indicator.frame;
    indicatorFrame.origin.y = (kDMChart_TooltipContentHeight - (kDMChart_IndicatorSize + kDMChart_TooltipItemDataValueTopOffset + kDMChart_TooltipItemDataValueFontSize)) / 2;
    indicator.frame = indicatorFrame;
    
    return indicator;
}

-(UILabel *)renderTitleLabel:(NSString *)title
{
    UIFont *font = [UIFont systemFontOfSize:kDMChart_TooltipItemTitleFontSize];
    CGFloat height = [@"a" sizeWithFont:font].height;
    CGRect frame = CGRectMake(kDMChart_IndicatorSize+kDMChart_TooltipItemTitleLeftOffset, self.indicator.frame.origin.y+((kDMChart_IndicatorSize - height)/2), self.frame.size.width - 2*(kDMChart_IndicatorSize+kDMChart_TooltipItemTitleLeftOffset), height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = [REMColor colorByHexString:kDMChart_TooltipItemTitleColor];
    
    return label;
}

-(UILabel *)renderDataValueLabel:(NSNumber *)dataValue
{
    UIFont *font = [UIFont systemFontOfSize:kDMChart_TooltipItemDataValueFontSize];
    CGFloat height = [@"a" sizeWithFont:font].height;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.indicator.frame.origin.y + kDMChart_IndicatorSize + kDMChart_TooltipItemDataValueTopOffset, self.frame.size.width, height)];
    label.text = [self formatDataValue:dataValue];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = [REMColor colorByHexString:kDMChart_TooltipItemDataValueColor];
    
    return label;
}


@end
