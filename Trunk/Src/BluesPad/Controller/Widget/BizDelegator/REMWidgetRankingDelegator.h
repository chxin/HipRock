//
//  REMWidgetRankingDelegator.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 11/5/13.
//
//

#import "REMWidgetBizDelegatorBase.h"
#import "REMDatePickerViewController.h"
#import "REMWidgetEnergyDelegator.h"
#import "REMDimensions.h"
#import "REMWidgetRankingSearchModel.h"
#import "REMChartHeader.h"


@interface REMWidgetRankingDelegator : REMWidgetBizDelegatorBase<REMWidgetDatePickerViewProtocol,REMTrendChartDelegate,REMChartTooltipDelegate>

@property (nonatomic,weak) UIView *searchView;
@property (nonatomic,weak) UIButton *timePickerButton;
@property (nonatomic,weak) UIView *legendView;
@property (nonatomic,weak) UISegmentedControl *legendSearchControl;
@property (nonatomic,weak) UIView *chartContainer;
@property (nonatomic,weak) UIButton *orderButton;

@end
