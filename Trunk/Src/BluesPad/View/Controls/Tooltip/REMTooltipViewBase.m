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

+(REMTooltipViewBase *)tooltipWithHighlightedPoints:(NSArray *)points inEnergyData:(REMEnergyViewData *)data widget:(REMWidgetObject *)widget andParameters:(REMWidgetSearchModelBase *)parameters
{
    if(widget.diagramType == REMDiagramTypePie){
        return [[REMPieChartTooltipView  alloc] initWithHighlightedPoints:points inEnergyData:data widget:widget andParameters:parameters];
    }
    else{
        return [[REMTrendChartTooltipView alloc] initWithHighlightedPoints:points inEnergyData:data widget:widget andParameters:parameters];
    }
}

-(REMTooltipViewBase *)initWithDefaults
{
    self = [super initWithFrame:kDMChart_TooltipHiddenFrame];
    
    if(self){
        self.backgroundColor = [REMColor colorByHexString:kDMChart_TooltipViewBackgroundColor];
        UIView *contentView = [self renderContentView];
        [self addSubview:contentView];
        self.contentView=contentView;
        
        UIView *closeView = [self renderCloseView];
        [contentView addSubview:closeView];
    }
    
    return self;
}

-(REMTooltipViewBase *)initWithHighlightedPoints:(NSArray *)points inEnergyData:(REMEnergyViewData *)data widget:(REMWidgetObject *)widget andParameters:(REMWidgetSearchModelBase *)parameters
{
    self = [super initWithFrame:kDMChart_TooltipHiddenFrame];
    
    if(self){
        self.backgroundColor = [REMColor colorByHexString:kDMChart_TooltipViewBackgroundColor];
        UIView *contentView = [self renderContentView];
        [self addSubview:contentView];
        self.contentView=contentView;
        
        UIView *closeView = [self renderCloseView];
        [contentView addSubview:closeView];
        
        //
        self.highlightedPoints = points;
        self.data = data;
        self.widget = widget;
        self.parameters = parameters;
        
        self.itemModels = [self convertItemModels];
        
        UIScrollView *scrollView = [self renderScrollView];
        
        
        [self.contentView addSubview:scrollView];
        self.scrollView = scrollView;
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

//@private
-(UIView *)renderContentView
{
    CGRect frame = CGRectMake(kDMChart_TooltipContentLeftOffset, kDMChart_TooltipContentTopOffset, kDMChart_TooltipContentWidth, kDMChart_TooltipContentHeight);
    
    UIView *contentView = [[UIView alloc] initWithFrame:frame];
    
    return contentView;
}

//@private
-(UIView *)renderCloseView
{
    UIView *closeView = [[UIView alloc] initWithFrame:CGRectMake(kDMChart_TooltipContentWidth - kDMChart_TooltipCloseViewWidth, 0, kDMChart_TooltipCloseViewWidth, kDMChart_TooltipContentHeight)];
    closeView.backgroundColor = [REMColor colorByHexString:kDMChart_TooltipViewBackgroundColor];
    //closeView.backgroundColor = [UIColor clearColor];
    
    CGFloat topOffset = (kDMChart_TooltipContentHeight - REMIMG_Close_Chart.size.height) / 2;
    CGFloat leftOffset = kDMChart_TooltipCloseViewInnerLeftOffset;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(leftOffset, topOffset, REMIMG_Close_Chart.size.width, REMIMG_Close_Chart.size.height)];
    [button setContentMode:UIViewContentModeCenter];
    [button setImage:REMIMG_Close_Chart forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setAdjustsImageWhenHighlighted:YES];
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor orangeColor].CGColor;
    
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
