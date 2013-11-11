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


#define kPieTooltipHighlightFrame CGRectMake((kDMChart_TooltipContentWidth - kDMChart_TooltipItemWidth) / 2, 0, kDMChart_TooltipItemWidth, kDMChart_TooltipViewHeight)


@interface REMPieChartTooltipView ()

@property (nonatomic,strong) NSMutableArray *tooltipItems;
@property (nonatomic,strong) NSArray *data;
@property (nonatomic) int highlightIndex;
@property (nonatomic,weak) UIView *itemsView;

@end


@implementation REMPieChartTooltipView

- (id)initWithFrame:(CGRect)frame data:(NSArray *)data andHighlightIndex:(int)highlightIndex
{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.borderColor = [UIColor blueColor].CGColor;
        self.layer.borderWidth = 1.0;
        self.backgroundColor = [REMColor colorByHexString:kDMChart_TooltipViewBackgroundColor];
        
        self.data = data;
        self.highlightIndex = highlightIndex;
        
        UIView *contentView = [[UIView alloc] initWithFrame:kDMChart_TooltipContentViewFrame];
//        contentView.layer.borderColor = [UIColor redColor].CGColor;
//        contentView.layer.borderWidth = 1.0f;
        
        UIView *itemsView = [self renderItemsContainerView];
        [contentView addSubview:itemsView];
        self.itemsView = itemsView;
        
        [self renderTooltipItems];
        
        [contentView addSubview:[self renderCloseView]];
        [contentView addSubview:[self renderPointerView]];
        
        
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


-(UIView *)renderItemsContainerView
{
    self.tooltipItems = [[NSMutableArray alloc] init];
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDMChart_TooltipContentWidth, kDMChart_TooltipViewHeight)];
    
    view.pagingEnabled = NO;
    view.showsHorizontalScrollIndicator = NO;
    view.showsVerticalScrollIndicator = NO;
    view.clipsToBounds = YES;
    view.scrollEnabled = NO;
//    view.backgroundColor = [UIColor redColor];
    
    int itemCount = self.data.count;
    
    CGFloat contentWidth = (kDMChart_TooltipItemWidth + kMDChart_TooltipItemLeftOffset) * itemCount;
    
    if(contentWidth < view.bounds.size.width){
        contentWidth = kDMChart_TooltipContentWidth;
    }
    
    view.contentSize = CGSizeMake(contentWidth+kDMChart_TooltipCloseViewWidth, kDMChart_TooltipViewHeight);
    
    return view;
}

- (void)renderTooltipItems
{
    CGFloat baseX = kPieTooltipHighlightFrame.origin.x;
    
    int itemCount = self.data.count;
    int index = self.highlightIndex;
    
    CGFloat itemOffset = kMDChart_TooltipItemLeftOffset;
    CGFloat itemWidth = kDMChart_TooltipItemWidth;
    CGFloat contentWidth = (itemWidth + itemOffset) * itemCount;
    
    if(contentWidth < kDMChart_TooltipContentWidth){
        itemOffset = itemCount == 1 ? 0 : (kDMChart_TooltipContentWidth - (itemCount * itemWidth)) / (itemCount - 1);
        contentWidth = kDMChart_TooltipContentWidth;
    }
    
    NSLog(@"width per item: %f",itemWidth + itemOffset);
    
    for(int i=0;i<itemCount;i++){
        CGRect itemFrame = CGRectMake((i - index)*(itemWidth + itemOffset) + baseX,0,itemWidth,kDMChart_TooltipViewHeight);
        
        NSLog(@"%dth frame: %@",i,NSStringFromCGRect(itemFrame));
        
        REMChartTooltipItem *tooltipItem = [[REMChartTooltipItem alloc] initWithFrame:itemFrame andData:self.data[i]];
        
        [self.itemsView addSubview:tooltipItem];
        [self.tooltipItems addObject:tooltipItem];
    }
    
    //    if(itemCount > 2){
    //        if(index - 3 < 0){
    //            for(int i = index - 3; i < 0; i++){
    //                CGRect itemFrame = CGRectMake(i*(itemWidth + itemOffset) + baseX,0,itemWidth,kDMChart_TooltipViewHeight);
    //
    //                REMChartTooltipItem *tooltipItem = [[REMChartTooltipItem alloc] initWithFrame:itemFrame andData:self.data[itemCount-1 + i]];
    //
    //                [view addSubview:tooltipItem];
    //                [self.tooltipItems addObject:tooltipItem];
    //            }
    //        }
    //        if(index + 3 > itemCount - 1){
    //            for(int i = 0; i< (index + 3) % itemCount; i++){
    //                CGRect itemFrame = CGRectMake((i+1)*(itemWidth + itemOffset) + baseX,0,itemWidth,kDMChart_TooltipViewHeight);
    //
    //                REMChartTooltipItem *tooltipItem = [[REMChartTooltipItem alloc] initWithFrame:itemFrame andData:self.data[i]];
    //
    //                [view addSubview:tooltipItem];
    //                [self.tooltipItems addObject:tooltipItem];
    //            }
    //        }
    //
    //        contentWidth = (itemWidth + itemOffset) * (itemCount + 3);
    //    }
}

-(UIView *)renderPointerView
{
    UIView *view = [[UIView alloc] initWithFrame:kPieTooltipHighlightFrame];
    view.layer.borderColor = [UIColor purpleColor].CGColor;
    view.layer.borderWidth = 1.0;
    view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    
    return view;
}

- (void)update:(id)highlightIndex
{
    int offset = self.highlightIndex - [highlightIndex intValue];
    NSLog(@"Now highlight index is %d, offset: %d", [highlightIndex intValue], offset);
    
    self.highlightIndex = [highlightIndex intValue];
    
    for(UIView *subview in self.itemsView.subviews){
        [subview removeFromSuperview];
    }
    
    [self renderTooltipItems];
}

@end
