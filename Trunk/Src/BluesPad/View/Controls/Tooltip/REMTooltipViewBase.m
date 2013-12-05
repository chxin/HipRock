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
        //self.backgroundColor = [UIColor orangeColor];
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
        //self.backgroundColor = [UIColor orangeColor];
        UIView *contentView = [self renderContentView];
        //contentView.backgroundColor = [UIColor yellowColor];
        [self addSubview:contentView];
        self.contentView=contentView;
        
        self.highlightedPoints = points;
        self.data = data;
        self.widget = widget;
        self.parameters = parameters;
        
        self.itemModels = [self convertItemModels];
        
        UIScrollView *scrollView = [self renderScrollView];
        [self.contentView addSubview:scrollView];
        self.scrollView = scrollView;
        
        
        UIView *closeView = [self renderCloseView];
        [self.contentView addSubview:closeView];
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
    UIView *contentView = [[UIView alloc] initWithFrame:kDMChart_TooltipContentViewFrame];
    NSLog(@"content view frame: %@", NSStringFromCGRect(contentView.frame));
    
    return contentView;
}

//@private
-(UIView *)renderCloseView
{
    UIView *closeView = [[UIView alloc] initWithFrame:kDMChart_TooltipCloseViewFrame];
    closeView.backgroundColor = [REMColor colorByHexString:kDMChart_TooltipViewBackgroundColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(kDMChart_TooltipCloseIconLeftOffset, kDMChart_TooltipCloseIconTopOffset, kDMChart_TooltipCloseIconSize,kDMChart_TooltipCloseIconSize)];
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
