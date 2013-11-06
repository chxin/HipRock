/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetEnergyDelegator.h
 * Created      : tantan on 11/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMWidgetBizDelegatorBase.h"
#import "REMDatePickerViewController.h"
#import "REMColor.h"
#import "REMBuildingViewController.h"
#import "REMWidgetStepEnergyModel.h"
#import "REMChartLegendItem.h"

const static CGFloat kLegendSearchSwitcherTop=10;

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


@interface REMWidgetEnergyDelegator : REMWidgetBizDelegatorBase<REMWidgetDatePickerViewProtocol,UIAlertViewDelegate,REMChartLegendItemDelegate>

@property (nonatomic,weak) UIView *searchView;
@property (nonatomic,weak) UIButton *timePickerButton;
@property (nonatomic,weak) UISegmentedControl *stepControl;
@property (nonatomic,weak) UIView *legendView;
@property (nonatomic,weak) UISegmentedControl *legendSearchControl;
@property (nonatomic,weak) UIView *chartContainer;


- (void)initSearchView;
- (void)initChartView;

- (void)changeTimeRange:(REMTimeRange *)newRange;


- (void)changeStep:(REMEnergyStep) newStep;


- (REMEnergyStep) initStepButtonWithRange:(REMTimeRange *)timeRange WithStep:(REMEnergyStep)step;




@end
