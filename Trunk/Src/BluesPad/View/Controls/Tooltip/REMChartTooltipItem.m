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
//        self.layer.borderColor = [UIColor orangeColor].CGColor;
//        self.layer.borderWidth = 1.0f;
        self.backgroundColor = [REMColor colorByHexString: kDMChart_TooltipViewBackgroundColor];
        self.model = model;
        
        // Name label
        UILabel *nameLabel = [self renderTitleLabel:model];
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // Value label
        UILabel *valueLabel = [self renderDataValueLabel:model];
        [self addSubview:valueLabel];
        self.valueLabel = valueLabel;
    }
    return self;
}

- (void)updateModel:(REMChartTooltipItemModel *)model
{
    self.nameLabel.text = model.title;
    
    self.valueLabel.text = [self formatDataValue:model];
}

- (NSString *)formatDataValue:(REMChartTooltipItemModel *)model
{
    //TODO: Need format
    return [NSString stringWithFormat:@"%@%@", REMIsNilOrNull(model.value) ? @"": [model.value stringValue], model.uom];
}

-(UILabel *)renderTitleLabel:(REMChartTooltipItemModel *)model
{
    UIFont *font = [UIFont systemFontOfSize:kDMChart_TooltipItemTitleFontSize];
    CGFloat height = [@"a" sizeWithFont:font].height;
    CGRect frame = CGRectMake(0, ((kDMChart_IndicatorSize - height)/2), self.frame.size.width - 2*(kDMChart_IndicatorSize+kDMChart_TooltipItemTitleLeftOffset), height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = model.title;
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = model.color;
    
    return label;
}

-(UILabel *)renderDataValueLabel:(REMChartTooltipItemModel *)model
{
    UIFont *font = [UIFont systemFontOfSize:kDMChart_TooltipItemDataValueFontSize];
    CGFloat height = [@"a" sizeWithFont:font].height;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.indicator.frame.origin.y + kDMChart_IndicatorSize + kDMChart_TooltipItemDataValueTopOffset, self.frame.size.width, height)];
    label.text = [self formatDataValue:model];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = [REMColor colorByHexString:kDMChart_TooltipItemDataValueColor];
    
    return label;
}


@end
