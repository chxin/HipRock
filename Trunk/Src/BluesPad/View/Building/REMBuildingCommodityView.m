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

- (id)initWithFrame:(CGRect)frame withBuildingInfo:(REMCommodityUsageModel *)commodityInfo
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
    int margin=5,groupMargin=10;
    
    self.totalLabel=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(margin, groupMargin+64, 500, 80) withData:self.commodityInfo.commodityUsage withTitle:@"上月总量" andTitleFontSize:80];
    
    [self addSubview:self.totalLabel];
    
}

- (void)initDetailValue
{
    int margin=5,groupMargin=10;
    
    REMBuildingTitleLabelView *carbon=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(margin, groupMargin+64, 120, 80) withData:self.commodityInfo.carbonEquivalent withTitle:@"二氧化碳当量" andTitleFontSize:40];
    
    [self addSubview:carbon];
    
//    REMBuildingTitleLabelView *rank=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(margin, groupMargin+64, 120, 80) withData:self.commodityInfo.rankingData withTitle:@"二氧化碳当量" andTitleFontSize:40];
//    
//    [self addSubview:rank];
    
    
    REMBuildingTitleLabelView *target=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(margin, groupMargin+64, 120, 80) withData:self.commodityInfo.targetValue withTitle:@"目标值" andTitleFontSize:40];
    
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
