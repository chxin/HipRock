/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTooltipView.m
 * Date Created : 张 锋 on 11/7/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <QuartzCore/QuartzCore.h>
#import "REMTooltipView.h"
#import "REMDimensions.h"
#import "REMChartTooltipItem.h"
#import "REMColor.h"
#import "REMEnergyDataPointModel.h"
#import "REMCommonHeaders.h"
#import "REMImages.h"


#define kTooltipViewWidth kDMScreenWidth
#define kTooltipViewHeight 110

#define kTooltipCloseViewWidth 110
#define kTooltipScrollViewWidth (kTooltipViewWidth - kTooltipCloseViewWidth)

#define kTooltipItemHeight 90
#define kTooltipItemHorizontalOffset 10
#define kTooltipItemMaxCount 4.2
#define kTooltipMinWidth (kTooltipScrollViewWidth - ((int)kTooltipItemMaxCount)*kTooltipItemHorizontalOffset) / kTooltipItemMaxCount

@interface REMTooltipView()

@property (nonatomic,strong) NSMutableArray *tooltipItems;

@end

@implementation REMTooltipView

- (id)initWithFrame:(CGRect)frame andData:(NSArray *)data;
{
    //CGRectMake(0, 0, kTooltipViewWidth, kTooltipViewHeight)
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.backgroundColor = [UIColor whiteColor];
        
        self.tooltipItems = [[NSMutableArray alloc] init];
        
        [self drawScrollView:data];
        
        [self drawCloseView];
    }
    return self;
}

- (void)update:(NSArray *)data
{
    for(int i=0;i<data.count;i++){
        REMEnergyDataPointModel *point = data[i];
        
        REMChartTooltipItem *item = [self.tooltipItems objectAtIndex:i];
        
        item.nameLabel.text = point.name;
        item.valueLabel.text = REMIsNilOrNull(point.dataValue) ? @"" : [point.dataValue.dataValue stringValue];
    }
}

-(void)drawScrollView:(NSArray *)data
{
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kTooltipScrollViewWidth, kTooltipViewHeight)];
    
    view.pagingEnabled = NO;
    view.showsHorizontalScrollIndicator = NO;
    view.showsVerticalScrollIndicator = NO;
    
    int itemCount = data.count;
    
    CGFloat itemWidth = itemCount > kTooltipItemMaxCount ? kTooltipMinWidth : (kTooltipScrollViewWidth - (itemCount + 1) * kTooltipItemHorizontalOffset) / itemCount;
    CGFloat contentWidth = itemWidth > kTooltipItemMaxCount ? ((itemWidth + kTooltipItemHorizontalOffset) * itemCount) + kTooltipItemHorizontalOffset : kTooltipScrollViewWidth;
    
    for(int i=0;i<itemCount;i++){
        REMEnergyDataPointModel *point = data[i];
        
        CGRect itemFrame = CGRectMake(((itemWidth + kTooltipItemHorizontalOffset) * i) + kTooltipItemHorizontalOffset, (kTooltipViewHeight - kTooltipItemHeight) / 2, itemWidth, kTooltipItemHeight);
        
        NSLog(@"frame of %dth item: %@", i, NSStringFromCGRect(itemFrame));
        
        REMChartTooltipItem *tooltipItem = [[REMChartTooltipItem alloc] initWithFrame:itemFrame withName:point.name color:point.color andValue: (REMIsNilOrNull(point.dataValue)? nil : point.dataValue.dataValue)];
        
        [view addSubview:tooltipItem];
        [self.tooltipItems addObject:tooltipItem];
    }
    
    view.contentSize = CGSizeMake(contentWidth, kTooltipViewHeight);
    
    [self addSubview:view];
}

-(void)drawCloseView
{
    UIView *closeView = [[UIView alloc] initWithFrame:CGRectMake(kTooltipScrollViewWidth, 0, kTooltipCloseViewWidth, kTooltipViewHeight)];
    
    CGFloat insets = (kTooltipCloseViewWidth - REMIMG_TooltipClose.size.width) / 2;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(insets, insets, REMIMG_TooltipClose.size.width, REMIMG_TooltipClose.size.height)];
    [button setContentMode:UIViewContentModeCenter];
    [button setImage:REMIMG_TooltipClose forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setAdjustsImageWhenHighlighted:YES];
    
    [closeView addSubview:button];
    
    [self addSubview:closeView];
}

-(void)closeButtonPressed:(UIButton *)button
{
    if(self.tooltipDelegate != nil){
        [self.tooltipDelegate tooltipWillDisapear];
    }
}

@end
