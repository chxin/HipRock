/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTooltipView.m
 * Date Created : 张 锋 on 11/7/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <QuartzCore/QuartzCore.h>
#import "REMTrendChartTooltipView.h"
#import "REMDimensions.h"
#import "REMChartTooltipItem.h"
#import "REMColor.h"
#import "REMCommonHeaders.h"
#import "REMImages.h"


@interface REMTrendChartTooltipView()

@property (nonatomic,strong) NSMutableArray *tooltipItems;

@end

@implementation REMTrendChartTooltipView

- (id)initWithFrame:(CGRect)frame andData:(NSArray *)data;
{
    //CGRectMake(0, 0, kTooltipViewWidth, kTooltipViewHeight)
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.layer.borderColor = [UIColor blueColor].CGColor;
//        self.layer.borderWidth = 1.0;
        self.backgroundColor = [REMColor colorByHexString:kDMChart_TooltipViewBackgroundColor];
        
        UIView *contentView = [[UIView alloc] initWithFrame:kDMChart_TooltipContentViewFrame];
//        contentView.layer.borderColor = [UIColor redColor].CGColor;
//        contentView.layer.borderWidth = 1.0f;
        
        [contentView addSubview:[self renderScrollView:data]];
        [contentView addSubview:[self renderCloseView]];
        
        [self addSubview:contentView];
    }
    return self;
}

- (void)update:(NSArray *)data
{
    for(int i=0;i<data.count;i++)
        [[self.tooltipItems objectAtIndex:i] updateModel:data[i]];
}

-(UIView *)renderScrollView:(NSArray *)data
{
    self.tooltipItems = [[NSMutableArray alloc] init];
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDMChart_TooltipContentWidth, kDMChart_TooltipViewHeight)];
    
    view.pagingEnabled = NO;
    view.showsHorizontalScrollIndicator = NO;
    view.showsVerticalScrollIndicator = NO;
    view.clipsToBounds = YES;
    
    int itemCount = data.count;
    
    CGFloat itemOffset = kMDChart_TooltipItemLeftOffset;
    CGFloat itemWidth = kDMChart_TooltipItemWidth;
    CGFloat contentWidth = (itemWidth + itemOffset) * itemCount;
    
    if(contentWidth < view.bounds.size.width){
        itemOffset = itemCount == 1 ? 0 : (kDMChart_TooltipContentWidth - (itemCount * itemWidth)) / (itemCount - 1);
        contentWidth = kDMChart_TooltipContentWidth;
    }
    
    for(int i=0;i<itemCount;i++){
        CGRect itemFrame = CGRectMake(i*(itemWidth + itemOffset),0,itemWidth,kDMChart_TooltipViewHeight);
        
        REMChartTooltipItem *tooltipItem = [[REMChartTooltipItem alloc] initWithFrame:itemFrame andData:data[i]];
        
        [view addSubview:tooltipItem];
        [self.tooltipItems addObject:tooltipItem];
    }
    
    view.contentSize = CGSizeMake(contentWidth+kDMChart_TooltipCloseViewWidth, kDMChart_TooltipViewHeight);
    
    return view;
}

@end
