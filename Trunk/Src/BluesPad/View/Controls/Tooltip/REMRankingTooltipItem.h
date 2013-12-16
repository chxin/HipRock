/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartToolTip.h
 * Created      : 张 锋 on 11/5/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMChartTooltipItem.h"


//ranking item model
@interface REMRankingTooltipItemModel : REMChartTooltipItemModel

@property (nonatomic) int numerator,denominator;

@end

//ranking item view
@interface REMRankingTooltipItem : REMChartTooltipItem
@end


