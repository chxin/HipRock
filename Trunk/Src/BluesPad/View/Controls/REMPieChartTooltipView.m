/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMPieChartTooltipView.m
 * Date Created : 张 锋 on 11/8/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/

#import <QuartzCore/QuartzCore.h>
#import "REMPieChartTooltipView.h"
#import "REMCommonHeaders.h"
#import "REMDimensions.h"
#import "REMChartTooltipItem.h"


@interface REMPieChartTooltipView ()

@property (nonatomic,strong) NSMutableArray *tooltipItems;

@end


@implementation REMPieChartTooltipView

- (id)initWithFrame:(CGRect)frame data:(NSArray *)data andHighlightIndex:(int)highlightIndex
{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.borderColor = [UIColor blueColor].CGColor;
        self.layer.borderWidth = 1.0;
        self.backgroundColor = [REMColor colorByHexString:kDMChart_TooltipViewBackgroundColor];
        
        UIView *contentView = [[UIView alloc] initWithFrame:kDMChart_TooltipContentViewFrame];
        contentView.layer.borderColor = [UIColor redColor].CGColor;
        contentView.layer.borderWidth = 1.0f;
        
        [contentView addSubview:[self renderScrollView:data]];
        [contentView addSubview:[self renderCloseView]];
        
        [self addSubview:contentView];
        
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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


-(UIView *)renderScrollView:(NSArray *)data
{
    self.tooltipItems = [[NSMutableArray alloc] init];
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDMChart_TooltipContentWidth, kDMChart_TooltipViewHeight)];
    
    view.pagingEnabled = NO;
    view.showsHorizontalScrollIndicator = NO;
    view.showsVerticalScrollIndicator = NO;
    view.clipsToBounds = YES;
    view.scrollEnabled = NO;
    
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

- (void)update:(id)highlightIndex
{
    NSLog(@"Now highlight index is %d", [highlightIndex intValue]);
}

@end
