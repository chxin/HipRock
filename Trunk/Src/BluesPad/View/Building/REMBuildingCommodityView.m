//
//  REMBuildingCommodityView.m
//  Blues
//
//  Created by tantan on 8/6/13.
//
//

#import "REMBuildingCommodityView.h"

@interface REMBuildingCommodityView()

@property (nonatomic,strong) REMBuildingTitleLabelView *totalLabel;

@property (nonatomic,strong) NSArray *detailLabelArray;
@property (nonatomic,strong) NSArray *chartViewArray;


@property (nonatomic,strong) REMCommodityUsageModel *commodityInfo;

@end

@implementation REMBuildingCommodityView

- (id)initWithFrame:(CGRect)frame withCommodityInfo:(REMCommodityUsageModel *)commodityInfo
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.commodityInfo=commodityInfo;
        
        [self initTotalValue];
        [self initDetailValue];
        [self initChartContainer];
    }
    
    return self;
}

- (void)initTotalValue
{
    
    self.totalLabel=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(0, 0, 1000, kBuildingCommodityTotalHeight) withData:self.commodityInfo.commodityUsage withTitle:@"上月总量" andTitleFontSize:20  withValueFontSize:kBuildingCommodityTotalValueFontSize withUomFontSize:kBuildingCommodityTotalUomFontSize];
    
    [self addSubview:self.totalLabel];
    
}

- (void)initDetailValue
{
    
    REMBuildingTitleLabelView *carbon=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(0, kBuildingCommodityItemGroupMargin+kBuildingCommodityTotalHeight, kBuildingCommodityDetailWidth, kBuildingCommodityDetailHeight) withData:self.commodityInfo.carbonEquivalent withTitle:@"二氧化碳当量" andTitleFontSize:20  withValueFontSize:kBuildingCommodityDetailValueFontSize withUomFontSize:kBuildingCommodityDetailUomFontSize];
    
    [self addSubview:carbon];
    
    REMBuildingRankingView *ranking=[[REMBuildingRankingView alloc]initWithFrame:CGRectMake(kBuildingCommodityDetailWidth, kBuildingCommodityItemGroupMargin+kBuildingCommodityTotalHeight, kBuildingCommodityDetailWidth, kBuildingCommodityDetailHeight) withData:self.commodityInfo.rankingData withTitle:@"集团排名" andTitleFontSize:20];
    
    [self addSubview:ranking];
    
    
    REMBuildingTitleLabelView *target=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(kBuildingCommodityDetailWidth*2, kBuildingCommodityItemGroupMargin+kBuildingCommodityTotalHeight, kBuildingCommodityDetailWidth, kBuildingCommodityDetailHeight) withData:self.commodityInfo.targetValue withTitle:@"目标值"  andTitleFontSize:20  withValueFontSize:kBuildingCommodityDetailValueFontSize withUomFontSize:kBuildingCommodityDetailUomFontSize];
    
    [self addSubview:target];
}

- (void)initChartContainer
{
    
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
