/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTooltipViewBase.m
 * Date Created : 张 锋 on 11/8/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMTooltipViewBase.h"
#import "REMDimensions.h"
#import "REMCommonHeaders.h"
#import "REMImages.h"
#import "REMPieChartTooltipView.h"
#import "REMTrendChartTooltipView.h"
#import "REMChartTooltipItem.h"

@interface REMTooltipViewBase()


@end

@implementation REMTooltipViewBase

+(REMTooltipViewBase *)tooltipWithHighlightedData:(NSArray *)points inEnergyData:(REMEnergyViewData *)data widget:(REMWidgetObject *)widget andParameters:(REMWidgetSearchModelBase *)parameters
{
    if(widget.diagramType == REMDiagramTypePie){
        return [[REMPieChartTooltipView  alloc] initWithHighlightedData:points inEnergyData:data widget:widget andParameters:parameters];
    }
    else{
        return [[REMTrendChartTooltipView alloc] initWithHighlightedData:points inEnergyData:data widget:widget andParameters:parameters];
    }
}

-(REMTooltipViewBase *)initWithHighlightedData:(id)points inEnergyData:(REMEnergyViewData *)data widget:(REMWidgetObject *)widget andParameters:(REMWidgetSearchModelBase *)parameters
{
    self = [super initWithFrame:kDMChart_TooltipHiddenFrame];
    
    if(self){
        self.highlightedPoints = points;
        self.data = data;
        self.widget = widget;
        self.parameters = parameters;
        
        self.backgroundColor = [REMColor colorByHexString:kDMChart_TooltipViewBackgroundColor];
        
        UIView *contentView = [[UIView alloc] initWithFrame:kDMChart_TooltipContentViewFrame];
        
        UIView *pointerView = [self pointerView];
        if(pointerView != nil)
           [contentView addSubview:pointerView];
        
        self.itemModels = [self convertItemModels];
        
        UIScrollView *scrollView = [self renderScrollView];
        [contentView addSubview:scrollView];
        self.scrollView = scrollView;
        
        UIView *closeView = [self renderCloseView];
        [contentView addSubview:closeView];
        
        [self addSubview:contentView];
    }
    
    return self;
}

//@virtual
- (void)updateHighlightedData:(NSArray *)data
{
}
- (NSArray *)convertItemModels
{
    return nil;
}
-(UIScrollView *)renderScrollView
{
    return nil;
}
-(UIView *)pointerView
{
    return nil;
}

//@private
-(UIView *)renderCloseView
{
    UIView *closeView = [[UIView alloc] initWithFrame:CGRectMake(kDMChart_TooltipContentWidth - kDMChart_TooltipCloseViewWidth, 0, kDMChart_TooltipCloseViewWidth, kDMChart_TooltipViewHeight)];
    closeView.backgroundColor = [REMColor colorByHexString:kDMChart_TooltipViewBackgroundColor];
    
    CGFloat topOffset = (kDMChart_TooltipViewHeight - REMIMG_Close_Chart.size.height) / 2;
    CGFloat leftOffset = kDMChart_TooltipCloseViewInnerLeftOffset;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(leftOffset, topOffset, REMIMG_Close_Chart.size.width, REMIMG_Close_Chart.size.height)];
    [button setContentMode:UIViewContentModeCenter];
    [button setImage:REMIMG_Close_Chart forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setAdjustsImageWhenHighlighted:YES];
    
    [closeView addSubview:button];
    
    return closeView;
}

//@private
-(void)closeButtonPressed:(UIButton *)button
{
    if(self.tooltipDelegate != nil){
        [self.tooltipDelegate tooltipWillDisapear];
    }
}

@end
