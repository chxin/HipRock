//
//  REMWidgetLabelingDelegator.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 11/5/13.
//
//

#import "REMWidgetBizDelegatorBase.h"
#import "REMWidgetMonthPickerViewController.h"
#import "DCLabelingWrapper.h"
#import "REMTooltipViewBase.h"


@interface REMWidgetLabelingDelegator : REMWidgetBizDelegatorBase<REMWidgetMonthPickerViewProtocol, REMChartLabelingDelegate,REMChartTooltipDelegate>

@end
