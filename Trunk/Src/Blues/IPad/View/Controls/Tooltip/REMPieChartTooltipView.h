/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMPieChartTooltipView.h
 * Date Created : 张 锋 on 11/8/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/

#import "REMTooltipViewBase.h"
#import "REMChartHeader.h"

@interface REMPieChartTooltipView : REMTooltipViewBase

-(REMTooltipViewBase *)initWithHighlightedPoints:(NSArray *)points chartWrapper:(DAbstractChartWrapper *)chartWrapper inEnergyData:(REMEnergyViewData *)data widget:(REMManagedWidgetModel *)widget andParameters:(REMWidgetSearchModelBase *)parameters;

- (void)updateHighlightedData:(id)data fromDirection:(REMDirection)direction;

@end
