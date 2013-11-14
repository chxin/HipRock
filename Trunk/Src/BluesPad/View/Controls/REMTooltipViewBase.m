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

@interface REMTooltipViewBase()

@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) UIView *closeView;

@end

@implementation REMTooltipViewBase

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

- (void)update:(id)data
{
}


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


-(void)closeButtonPressed:(UIButton *)button
{
    if(self.tooltipDelegate != nil){
        [self.tooltipDelegate tooltipWillDisapear];
    }
}

@end
