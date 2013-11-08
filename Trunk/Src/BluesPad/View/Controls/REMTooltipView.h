/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTooltipView.h
 * Date Created : 张 锋 on 11/7/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@protocol REMChartTooltipDelegate <NSObject>

-(void)tooltipWillDisapear;

@end

@interface REMTooltipView : UIScrollView

@property (nonatomic,weak) NSObject<REMChartTooltipDelegate> *tooltipDelegate;

- (id)initWithFrame:(CGRect)frame andData:(NSArray *)data;

@end
