/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMRankingTooltipItem.m
 * Date Created : 张 锋 on 11/21/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <QuartzCore/QuartzCore.h>
#import "REMChartTooltipItem.h"
#import "REMCommonHeaders.h"
#import "REMDimensions.h"


@implementation REMRankingTooltipItemModel
@end


//ranking item view
@interface REMRankingTooltipItem()

@property (nonatomic,weak) UILabel *numeratorLabel;
@property (nonatomic,weak) UILabel *denominatorLabel;
@property (nonatomic,weak) UILabel *nameLabel;
@property (nonatomic,weak) UILabel *valueLabel;

@property (nonatomic,weak) REMRankingTooltipItemModel *rankingModel;

@end



@implementation REMRankingTooltipItem

- (id)initWithFrame:(CGRect)frame andData:(REMChartTooltipItemModel *)model
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        self.rankingModel = (REMRankingTooltipItemModel *)model;
        
        UILabel *numeratorLabel = [self renderNumeratorLabel];
        [self addSubview:numeratorLabel];
        self.numeratorLabel = numeratorLabel;
        
        UILabel *denominatorLabel = [self renderDenominatorLabel];
        [self addSubview:denominatorLabel];
        self.denominatorLabel = denominatorLabel;
        
        // Name label
        UILabel *nameLabel = [self renderTitleLabel:model.title];
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
    REMRankingTooltipItemModel *rankingModel = (REMRankingTooltipItemModel *)model;
    
    self.nameLabel.text = model.title;
    self.valueLabel.text = [super formatDataValue:model];
    self.numeratorLabel.text = [NSString stringWithFormat:@"%d",rankingModel.numerator];
    self.denominatorLabel.text = [NSString stringWithFormat:@"/%d",rankingModel.denominator];
}


-(UILabel *)renderNumeratorLabel
{
    NSString *text = [NSString stringWithFormat:@"%d",self.rankingModel.numerator];
    UIFont *font = [UIFont systemFontOfSize:24];
    CGSize size = [text sizeWithFont:font];
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = [UIColor blackColor];
    
    return label;
}

-(UILabel *)renderDenominatorLabel
{
    NSString *text = [NSString stringWithFormat:@"/%d",self.rankingModel.denominator];
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize size = [text sizeWithFont:font];
    CGRect frame = CGRectMake(self.numeratorLabel.frame.origin.x+self.numeratorLabel.frame.size.width, self.numeratorLabel.frame.origin.y + self.numeratorLabel.frame.size.height - size.height, size.width, size.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = [UIColor blackColor];
    
    return label;
}

-(UILabel *)renderTitleLabel:(NSString *)title
{
    CGSize rankingSize = CGSizeMake(self.numeratorLabel.frame.size.width+self.denominatorLabel.frame.size.width, self.numeratorLabel.frame.size.height);
    
    UIFont *font = [UIFont systemFontOfSize:kDMChart_TooltipItemTitleFontSize];
    CGSize size = [@"a" sizeWithFont:font];
    CGRect frame = CGRectMake(rankingSize.width+kDMChart_TooltipItemTitleLeftOffset, self.numeratorLabel.frame.origin.y, self.frame.size.width - (rankingSize.width+kDMChart_TooltipItemTitleLeftOffset), size.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = [REMColor colorByHexString:kDMChart_TooltipItemTitleColor];
    
    return label;
}

-(UILabel *)renderDataValueLabel:(REMChartTooltipItemModel *)model
{
    CGSize rankingSize = CGSizeMake(self.numeratorLabel.frame.size.width+self.denominatorLabel.frame.size.width, self.numeratorLabel.frame.size.height);
    
    UIFont *font = [UIFont systemFontOfSize:kDMChart_TooltipItemDataValueFontSize];
    CGFloat height = [@"a" sizeWithFont:font].height;
    CGRect frame = CGRectMake(rankingSize.width+kDMChart_TooltipItemTitleLeftOffset, self.numeratorLabel.frame.origin.y + rankingSize.height + kDMChart_TooltipItemDataValueTopOffset, self.frame.size.width - (rankingSize.width+kDMChart_TooltipItemTitleLeftOffset), height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = [super formatDataValue:model];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = [REMColor colorByHexString:kDMChart_TooltipItemDataValueColor];
    
    return label;
}

@end
