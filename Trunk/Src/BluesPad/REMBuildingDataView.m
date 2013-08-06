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
@property (nonatomic,weak)  REMBuildingOverallModel *buildingInfo;

@property (nonatomic,strong) NSArray *commodityViewArray;

@end
@implementation REMBuildingDataView

static int buttonDimention=64;
- (id)initWithFrame:(CGRect)frame withBuildingInfo:(REMBuildingOverallModel *)buildingInfo
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.buildingInfo=buildingInfo;
        
        [self initCommodityButton];
    }
    
    return self;
}

- (void)initCommodityButton
{
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:self.buildingInfo.commodityUsage.count];
    int margin=5,i=0;
    for (REMCommodityUsageModel *model in self.buildingInfo.commodityUsage) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15+i*(margin+buttonDimention), 0, buttonDimention, buttonDimention)];
        [self addSubview:btn];
        [array addObject:btn];
        ++i;
    }
    
    self.buttonArray=array;
}

- (void)initCommodityView
{
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:self.buildingInfo.commodityUsage.count];
    int margin=5,i=0;
    for (REMCommodityUsageModel *model in self.buildingInfo.commodityUsage) {
        REMBuildingCommodityView *view = [[REMBuildingCommodityView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1000) withCommodityInfo:model];
        ++i;
        [array addObject:view];
    }
    
    self.commodityViewArray=array;
}


//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//        
//        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//        button.titleLabel.text=@"Elec";
//        
//        [self addSubview:button];
//        
//        
//        
//        NSArray *array = @[@"123,2312",@"12312,123",@"435,34534",@"655,464",@"42,678",@"234,3453"];
//        int gap=85;
//        int i=0;
//        for (NSString *str in array) {
//            REMNumberLabel *titleLabel = [[REMNumberLabel alloc]initWithFrame:CGRectMake(5,30+5+gap*i, frame.size.width, 80)];
//            titleLabel.text=str;
//            titleLabel.shadowColor=[UIColor blackColor];
//            titleLabel.shadowOffset=CGSizeMake(1, 1);
//            
//            titleLabel.backgroundColor=[UIColor clearColor];
//            titleLabel.font = [UIFont fontWithName:@"Avenir" size:80];
//            //self.titleLabel.font=[UIFont boldSystemFontOfSize:20];
//            titleLabel.textColor=[UIColor whiteColor];
//            titleLabel.contentMode = UIViewContentModeTopLeft;
//            [self addSubview:titleLabel];
//            ++i;
//        }
//        
//      
//        
//        
//    }
//    return self;
//}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
