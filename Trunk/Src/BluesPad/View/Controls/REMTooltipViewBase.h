/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTooltipViewBase.h
 * Date Created : 张 锋 on 11/8/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@protocol REMChartTooltipDelegate <NSObject>

-(void)tooltipWillDisapear;

@end


@interface REMTooltipViewBase : UIView

// Properties
@property (nonatomic,weak) NSObject<REMChartTooltipDelegate> *tooltipDelegate;

// Methods
- (void)update:(id)data;

-(UIView *)renderCloseView;

@end
