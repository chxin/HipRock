//
//  REMBuildingDataView.m
//  TestImage
//
//  Created by tantan on 7/31/13.
//  Copyright (c) 2013 demo. All rights reserved.
//

#import "REMBuildingDataView.h"

@interface REMBuildingDataView()

@property (nonatomic,strong) NSArray *buttonArray;
@property (nonatomic,strong)  REMBuildingOverallModel *buildingInfo;

@property (nonatomic,strong) NSArray *commodityViewArray;
@property (nonatomic) NSUInteger currentIndex;
@end
@implementation REMBuildingDataView

- (id)initWithFrame:(CGRect)frame withBuildingInfo:(REMBuildingOverallModel *)buildingInfo
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.buildingInfo=buildingInfo;
        self.currentIndex=0;
        
        [self initCommodityButton];
        [self initCommodityView];
    }
    
    return self;
}

- (void)initCommodityButton
{
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:self.buildingInfo.commodityUsage.count];
    int i=0;
    for (REMCommodityUsageModel *model in self.buildingInfo.commodityUsage) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*(kBuildingCommodityItemMargin+kBuildingCommodityButtonDimension), 0, kBuildingCommodityButtonDimension, kBuildingCommodityButtonDimension)];
        btn.titleLabel.text=model.commodity.code;
        
        [btn setImage:[UIImage imageNamed:[self retrieveCommodityImageName:model.commodity]] forState:UIControlStateNormal];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(commodityChanged:) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:btn];
        ++i;
    }
    
    self.buttonArray=array;
}

- (NSString *)retrieveCommodityImageName:(REMCommodityModel *)model
{
    if ([model.commodityId isEqualToNumber:@(1)] == YES) {
        return @"elec.jpg";
    }
    else if([model.commodityId isEqualToNumber:@(4)] == YES)
    {
        return @"water.jpg";
    }
    else{
        return @"elec.jpg";
    }
}

- (void)commodityChanged:(UIButton *)button
{
    
}

- (void)initCommodityView
{
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:self.buildingInfo.commodityUsage.count];
    int i=0;
    for (;i<self.buildingInfo.commodityUsage.count;++i ) {
        REMCommodityUsageModel *model = self.buildingInfo.commodityUsage[i];
        REMBuildingCommodityView *view = [[REMBuildingCommodityView alloc]initWithFrame:CGRectMake(0, kBuildingCommodityItemGroupMargin+ kBuildingCommodityButtonDimension, self.frame.size.width, 800) withCommodityInfo:model];
        
        if(i!=0){
            view.alpha=0;
        }
        ++i;
        [self addSubview:view];
        [array addObject:view];
    }
    
    self.commodityViewArray=array;
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
