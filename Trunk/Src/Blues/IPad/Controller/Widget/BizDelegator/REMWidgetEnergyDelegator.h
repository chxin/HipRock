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
#import "REMDimensions.h"
#import "REMTrendChartTooltipView.h"
#import "DCChartTrendWrapperDelegate.h"
#import "DCChartPieWrapperDelegate.h"

const static CGFloat kLegendSearchSwitcherTop=16;
const static CGFloat kLegendSearchSwitcherLeft=790;
const static CGFloat kLegendSearchSwitcherHeight=30;
const static CGFloat kLegendSearchSwitcherWidth=102*2;
const static CGFloat kWidgetDatePickerLeftMargin=25;
const static CGFloat kWidgetDatePickerTopMargin=16;
const static CGFloat kWidgetDatePickerHeight=29;
const static CGFloat kWidgetDatePickerTitleSize=14;
const static CGFloat kWidgetStepSingleButtonWidth=60;
const static CGFloat kWidgetStepButtonFontSize=14;
const static CGFloat kWidgetStepButtonHeight=24;
const static CGFloat kWidgetChartLeftMargin=25;
//const static CGFloat kWidgetChartTopMargin=REMDMCOMPATIOS7(62)+kDMChart_ToolbarHeight;
#define kWidgetChartWidth 1024-kWidgetChartLeftMargin*2
#define kWidgetChartHeight 748-(REMDMCOMPATIOS7(62)+kDMChart_ToolbarHeight)-kWidgetChartLeftMargin

typedef enum _REMWidgetLegendType{
    REMWidgetLegendTypeLegend,
    REMWidgetLegendTypeSearch
} REMWidgetLegendType;


@interface REMWidgetEnergyDelegator : REMWidgetBizDelegatorBase<REMWidgetDatePickerViewProtocol,UIAlertViewDelegate,REMChartLegendItemDelegate, DCChartTrendWrapperDelegate, DCChartPieWrapperDelegate, REMChartTooltipDelegate,UIPopoverControllerDelegate>

@property (nonatomic,weak) UIView *searchView;
@property (nonatomic,weak) UIView *searchLegendViewContainer;
@property (nonatomic,weak) UIButton *timePickerButton;
@property (nonatomic,weak) UISegmentedControl *stepControl;
@property (nonatomic,weak) UISegmentedControl *legendSearchControl;
@property (nonatomic) REMWidgetLegendType currentLegendStatus;

- (void)initSearchView;
- (void)initChartView;
- (void)initModelAndSearcher;

- (void)changeTimeRange:(REMTimeRange *)newRange;


- (void)changeStep:(REMEnergyStep) newStep;


- (REMEnergyStep) initStepButtonWithRange:(REMTimeRange *)timeRange WithStep:(REMEnergyStep)step;




@end
