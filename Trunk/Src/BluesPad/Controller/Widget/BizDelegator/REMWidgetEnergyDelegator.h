//
//  REMWidgetEnergyDelegator.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 11/4/13.
//
//

#import "REMWidgetBizDelegatorBase.h"
#import "REMDatePickerViewController.h"
#import "REMColor.h"
#import "REMBuildingViewController.h"

const static CGFloat kLegendSearchSwitcherTop=10;
const static CGFloat kWidgetTitleLeftMargin=10;
const static CGFloat kWidgetTitleHeight=30;
const static CGFloat kWidgetTitleFontSize=25;
const static CGFloat kWidgetDatePickerLeftMargin=15;
const static CGFloat kWidgetDatePickerTopMargin=70;
const static CGFloat kWidgetDatePickerHeight=40;
const static CGFloat kWidgetDatePickerWidth=380;
const static CGFloat kWidgetStepSingleButtonWidth=60;
const static CGFloat kWidgetChartLeftMargin=10;
const static CGFloat kWidgetChartTopMargin=kWidgetDatePickerTopMargin+kWidgetDatePickerHeight;
const static CGFloat kWidgetChartWidth=1004;
const static CGFloat kWidgetChartHeight=748-kWidgetChartTopMargin;

typedef enum _REMWidgetLegendType{
    REMWidgetLegendTypeLegend,
    REMWidgetLegendTypeSearch
} REMWidgetLegendType;


@interface REMWidgetEnergyDelegator : REMWidgetBizDelegatorBase<REMWidgetDatePickerViewProtocol>

@property (nonatomic,weak) UIView *searchView;
@property (nonatomic,weak) UIButton *timePickerButton;
@property (nonatomic,weak) UISegmentedControl *stepControl;
@property (nonatomic,weak) UIView *legendView;
@property (nonatomic,weak) UISegmentedControl *legendSearchControl;
@property (nonatomic,weak) UIView *chartContainer;


- (void)initSearchView;
- (void)initChartView;

@end
