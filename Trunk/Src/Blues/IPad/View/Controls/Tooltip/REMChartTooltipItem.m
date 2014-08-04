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
@property (nonatomic,weak) UILabel *uomLabel;
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
//        self.layer.borderColor = [UIColor redColor].CGColor;
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
        
        [self updateDataValue:model];
    }
    return self;
}

- (void)updateModel:(REMChartTooltipItemModel *)model
{
    self.nameLabel.text = model.title;
    self.nameLabel.textColor = model.color;
    
    [self updateDataValue:model];
}

-(UILabel *)renderTitleLabel:(REMChartTooltipItemModel *)model
{
    UIFont *font = [REMFont defaultFontOfSize:kDMChart_TooltipItemTitleFontSize];
    CGFloat height = [@"a" sizeWithFont:font].height;
    //CGRect frame = CGRectMake(0, ((kDMChart_IndicatorSize - height)/2), self.frame.size.width - 2*(kDMChart_IndicatorSize+kDMChart_TooltipItemTitleLeftOffset), height);
    CGRect frame = CGRectMake(kDMChart_TooltipItemTitleLeftOffset, kDMChart_TooltipItemTitleTopOffset, self.frame.size.width, height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = model.title;
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = model.color;
    
    
    
    return label;
}

-(UILabel *)renderDataValueLabel:(REMChartTooltipItemModel *)model
{
    UIFont *font = [REMFont defaultFontOfSize:kDMChart_TooltipItemDataValueFontSize];
    CGFloat height = [@"a" sizeWithFont:font].height;
    
    //CGRectMake(0, self.indicator.frame.origin.y + kDMChart_IndicatorSize + kDMChart_TooltipItemDataValueTopOffset, self.frame.size.width, height)
    CGRect frame = CGRectMake(kDMChart_TooltipItemDataValueLeftOffset, kDMChart_TooltipItemDataValueTopOffset, self.frame.size.width, height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    //label.textColor = [REMColor colorByHexString:kDMChart_TooltipItemDataValueColor];
    //label.text = [self formatDataValue:model];
    //label.font = font;
    
    
    return label;
}


-(void)updateDataValue:(REMChartTooltipItemModel *)model
{
    NSString *valueText = [REMNumberHelper formatDataValueWithCarry:model.value];
    NSString *uomText = REMIsNilOrNull(model.uom) ? @"" : model.uom;
    NSString *text = [NSString stringWithFormat:@"%@ %@", REMIsNilOrNull(model.value) ? @"": valueText, uomText];
    
    
    NSRange uomRange = REMIsNilOrNull(model.uom) ? NSMakeRange(0, 0) : [text rangeOfString:model.uom];
    NSRange valueRange = NSMakeRange(0, text.length - uomRange.length);
    
    //NSLog(@"valueRange:%@,uomRange:%@", NSStringFromRange(valueRange), NSStringFromRange(uomRange));
    
    UIFont *valueFont = [REMFont defaultFontOfSize:kDMChart_TooltipItemDataValueFontSize];
    UIColor *valueColor = [REMColor colorByHexString:kDMChart_TooltipItemDataValueColor];
    
    UIFont *uomFont = [REMFont defaultFontOfSize:kDMChart_TooltipItemDataValueUomFontSize];
    UIColor *uomColor = [REMColor colorByHexString:kDMChart_TooltipItemDataValueUomColor];
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:text];
    if(valueRange.length > 0)
        [content setAttributes: @{NSFontAttributeName:valueFont,NSForegroundColorAttributeName:valueColor} range:valueRange];
    if(uomRange.length>0)
        [content setAttributes:@{NSFontAttributeName:uomFont,NSForegroundColorAttributeName:uomColor} range:uomRange];
    
    self.valueLabel.attributedText = content;
}


@end
