/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartLegendView.m
 * Date Created : 张 锋 on 11/18/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMChartLegendView.h"
#import "REMChartLegendItem.h"
#import "REMColor.h"

@implementation REMChartLegendView


- (id)initWithItems:(NSArray *)itemModels andHiddenSeries:(NSArray *)hiddenSeries
{
    self = [super initWithFrame:kDMChart_ToolbarHiddenFrame];
    if (self) {
        // Initialization code
        CGFloat scrollViewContentWidth = (kDMChart_LegendItemWidth + kDMChart_LegendItemLeftOffset) * itemModels.count + kDMChart_LegendItemLeftOffset;
        
        self.backgroundColor = [REMColor colorByHexString:kDMChart_BackgroundColor];
        self.contentSize = CGSizeMake(scrollViewContentWidth, kDMChart_ToolbarHeight);
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        [self addItems:itemModels :hiddenSeries];
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

- (void)addItems:(NSArray *)itemModels :(NSArray *)hiddenSeries
{
    for(int i=0;i<itemModels.count; i++){
        REMChartLegendItemModel *model = itemModels[i];
        
        CGFloat x = i * (kDMChart_LegendItemWidth + kDMChart_LegendItemLeftOffset) + kDMChart_LegendItemLeftOffset;
        CGFloat y = (kDMChart_ToolbarHeight - kDMChart_LegendItemHeight) / 2;
        
        REMChartLegendItem *legend = [[REMChartLegendItem alloc] initWithModel:model];
        legend.frame = CGRectMake(x, y, kDMChart_LegendItemWidth, kDMChart_LegendItemHeight);
        
        if(hiddenSeries != nil && hiddenSeries.count > 0 && [hiddenSeries containsObject:@(i)]){
            [legend setSelected:YES];
        }
        
        [self addSubview:legend];
    }
}

@end
