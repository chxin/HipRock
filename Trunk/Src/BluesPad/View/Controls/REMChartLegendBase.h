/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartLegendBase.h
 * Date Created : 张 锋 on 11/18/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "REMWidgetObject.h"
#import "REMEnergyViewData.h"

@interface REMChartLegendBase : UIScrollView

+ (REMChartLegendBase *)legendWithEnergyData:(REMEnergyViewData *)data andWidgetInfo:(REMWidgetObject *)REMWidgetObject;

- (id)initWithItems:(NSArray *)itemModels andHiddenSeries:(NSArray *)hiddenSeries;

@end
