/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartLegendView.h
 * Date Created : 张 锋 on 11/18/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface REMChartLegendView : UIScrollView

- (id)initWithItems:(NSArray *)itemModels andHiddenSeries:(NSArray *)hiddenSeries;

@end
