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
        
        [self updateDataValue:model];
    }
    
    return self;
}

- (void)updateModel:(REMChartTooltipItemModel *)model
{
    REMRankingTooltipItemModel *rankingModel = (REMRankingTooltipItemModel *)model;
    
    self.nameLabel.text = model.title;
    self.denominatorLabel.text = [NSString stringWithFormat:@"/%d",rankingModel.denominator];
    
    [self updateNumerator:rankingModel];
    [self updateDataValue:model];
}


-(UILabel *)renderNumeratorLabel
{
    NSString *text = [NSString stringWithFormat:@"%d",self.rankingModel.numerator];
    UIFont *font = [REMFont defaultFontOfSize:kDMChart_RankingTooltipNumeratorFontSize];
    CGSize size = [text sizeWithFont:font];
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = [REMColor colorByHexString:kDMChart_RankingTooltipNumeratorFontColor];
//    label.layer.borderWidth = 1.0;
//    label.layer.borderColor = [UIColor purpleColor].CGColor;
    
    return label;
}

-(UILabel *)renderDenominatorLabel
{
    NSString *text = [NSString stringWithFormat:@"/%d",self.rankingModel.denominator];
    UIFont *font = [REMFont defaultFontOfSize:kDMChart_RankingTooltipDenominatorFontSize];
    CGSize size = [text sizeWithFont:font];
    CGRect frame = CGRectMake(self.numeratorLabel.frame.origin.x+self.numeratorLabel.frame.size.width, self.numeratorLabel.frame.origin.y + self.numeratorLabel.frame.size.height - size.height, size.width, size.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = [REMColor colorByHexString:kDMChart_RankingTooltipDenominatorFontColor];
//    label.layer.borderWidth = 1.0;
//    label.layer.borderColor = [UIColor purpleColor].CGColor;
    
    return label;
}

-(UILabel *)renderTitleLabel:(NSString *)title
{
    CGFloat titleLeftOffset = [self getRankingSize].width + kDMChart_RankingTooltipTitleLeftOffset;
    
    UIFont *font = [REMFont defaultFontOfSize:kDMChart_TooltipItemTitleFontSize];
    CGSize size = [@"a" sizeWithFont:font];
    CGRect frame = CGRectMake(titleLeftOffset, self.numeratorLabel.frame.origin.y, self.frame.size.width - titleLeftOffset, size.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = [REMColor colorByHexString:kDMChart_TooltipItemTitleColor];
//    label.layer.borderWidth = 1.0;
//    label.layer.borderColor = [UIColor purpleColor].CGColor;
    
    return label;
}

-(UILabel *)renderDataValueLabel:(REMChartTooltipItemModel *)model
{
    CGFloat labelLeftOffset = [self getRankingSize].width + kDMChart_RankingTooltipTitleLeftOffset;
    CGFloat labelTopOffset = kDMChart_TooltipItemTitleFontSize + 11;
    
    UIFont *font = [REMFont defaultFontOfSize:kDMChart_TooltipItemDataValueFontSize];
    CGFloat height = [@"a" sizeWithFont:font].height;
    CGRect frame = CGRectMake(labelLeftOffset, labelTopOffset, self.frame.size.width - labelLeftOffset, height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
//    label.layer.borderWidth = 1.0;
//    label.layer.borderColor = [UIColor purpleColor].CGColor;
    
    return label;
}

-(CGSize)getRankingSize
{
    return CGSizeMake(self.numeratorLabel.frame.size.width+self.denominatorLabel.frame.size.width, self.numeratorLabel.frame.size.height);
}


-(void)updateNumerator:(REMRankingTooltipItemModel *)model
{
    NSString *text = [NSString stringWithFormat:@"%d",model.numerator];
    
    CGSize oldSize = self.numeratorLabel.frame.size;
    CGSize newSize = [text sizeWithFont:[REMFont defaultFontOfSize:kDMChart_RankingTooltipNumeratorFontSize]];
    
    CGFloat diff = newSize.width - oldSize.width;
    
    CGRect numeratorFrame = CGRectMake(self.numeratorLabel.frame.origin.x,self.numeratorLabel.frame.origin.y,newSize.width,oldSize.height);
    CGRect denominatorFrame = CGRectMake(self.denominatorLabel.frame.origin.x + diff, self.denominatorLabel.frame.origin.y, self.denominatorLabel.frame.size.width, self.denominatorLabel.frame.size.height);
    
    self.numeratorLabel.text = text;
    self.numeratorLabel.frame = numeratorFrame;
    self.denominatorLabel.frame = denominatorFrame;
}

@end
