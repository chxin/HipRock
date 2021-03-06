/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetEnergyDelegator.m
 * Created      : tantan on 11/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMWidgetEnergyDelegator.h"
#import <QuartzCore/QuartzCore.h>
#import "REMDimensions.h"
#import "REMChartSeriesIndicator.h"
#import "REMChartLegendItem.h"
#import "REMChartTooltipItem.h"
#import "REMTooltipViewBase.h"
#import "REMTrendChartTooltipView.h"
#import "REMPieChartTooltipView.h"
#import "REMChartSeriesIndicator.h"
#import "REMTrendChartLegendView.h"
#import "REMStackChartLegendView.h"
#import "REMClientErrorInfo.h"
#import "DCRankingWrapper.h"
#import "DCLabelingWrapper.h"
#import "DCPieWrapper.h"
#import "REMWidgetStepCalculationModel.h"
#import "REMWidgetCommoditySearchModel.h"
#import "REMCommonHeaders.h"
#import "REMWrapperFactor.h"
#import "REMSegmentedControl.h"
#import "REMButton.h"




@interface REMWidgetEnergyDelegator()

@property (nonatomic,strong) UIPopoverController *datePickerPopoverController;

@property (nonatomic,strong) DAbstractChartWrapper *chartWrapper;

@property (nonatomic,strong) NSArray *currentStepList;
@property (nonatomic,weak) REMTooltipViewBase *tooltipView;



@property (nonatomic,strong) NSArray *supportStepArray;

@property (nonatomic,strong) NSMutableArray *hiddenSeries;

@property (nonatomic) BOOL isReloadChart;

@property (nonatomic,weak) UIButton *touButton;
@property (nonatomic) BOOL isCostStacked;
@property (nonatomic) BOOL tempIsCostStacked;


@end

@implementation REMWidgetEnergyDelegator

- (id)init{
    self = [super init];
    if(self){
        _currentLegendStatus=REMWidgetLegendTypeSearch;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"BizDetailChanged" object:nil];
        self.isReloadChart=NO;
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BizDetailChanged" object:nil];
}

- (void) receiveNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"BizDetailChanged"]){
        REMWidgetLegendType status= (REMWidgetLegendType)[notification.userInfo[@"status"] integerValue];
        self.currentLegendStatus=status;
    }
}


- (void)initBizView{
    self.isCostStacked = [self isWidgetStacking];
    
    [self initModelAndSearcher];
    
    [self initSearchView];
    [self initChartView];
    
    if (self.contentSyntax.contentSyntaxWidgetType == REMWidgetContentSyntaxWidgetTypePie) {
        [self.stepControl removeFromSuperview];
        [self updateTouButtonConstraint];
    }
    
    REMWidgetStepEnergyModel *tempModel=(REMWidgetStepEnergyModel *)self.tempModel;
    
    [self setDatePickerButtonValueNoSearchByTimeRange:tempModel.timeRangeArray[0] withRelative:tempModel.relativeDateComponent withRelativeType:tempModel.relativeDateType];
    [self initStepButtonWithRange:tempModel.timeRangeArray[0] WithStep:tempModel.step];
    [self setStepControlStatusByStepNoSearch:tempModel.step];
}

- (void)initModelAndSearcher{
    
    REMWidgetStepEnergyModel *m=(REMWidgetStepEnergyModel *)self.model;
    m.relativeDateType=self.contentSyntax.relativeDateType;
    
}
- (void)initSearchView{
    UIView *searchLegendViewContainer=[[UIView alloc]initWithFrame:CGRectMake(0,self.ownerController.titleContainer.frame.origin.y+self.ownerController.titleContainer.frame.size.height,kDMScreenWidth,kDMChart_ToolbarHeight)];
    
    [searchLegendViewContainer setBackgroundColor:[UIColor clearColor]];
    
    
    UIView *searchViewContainer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, searchLegendViewContainer.frame.size.width, searchLegendViewContainer.frame.size.height)];
    searchViewContainer.translatesAutoresizingMaskIntoConstraints=NO;
    
    [searchViewContainer setBackgroundColor:[REMColor colorByHexString:@"#f4f4f4"]];
    
    [searchLegendViewContainer addSubview:searchViewContainer];
    
    self.searchLegendViewContainer=searchLegendViewContainer;
    
    REMSegmentedControl *legendControl=[[REMSegmentedControl alloc] initWithItems:@[@"search",@"legend"] andMargins:CGPointMake(5, 15)];
    //[legendControl setFrame:CGRectMake(kLegendSearchSwitcherLeft, kLegendSearchSwitcherTop, kLegendSearchSwitcherWidth, kLegendSearchSwitcherHeight)];
    
    
    //[legendControl setSegmentedControlStyle:UISegmentedControlStylePlain];
    if (REMISIOS7) {
        [legendControl setImage:REMIMG_DateView_Chart forSegmentAtIndex:0];
        [legendControl setImage:REMIMG_Legend_Chart forSegmentAtIndex:1];
    }
    else{
        [legendControl setImage:REMIMG_DateView_Chart_iOS6 forSegmentAtIndex:0];
        [legendControl setImage:REMIMG_Legend_Chart_iOS6_Normal forSegmentAtIndex:1];
        
    }
    
    //[legendControl setBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //[legendControl setBackgroundColor:[UIColor clearColor]];
    [legendControl setSelectedSegmentIndex:0];
    [legendControl addTarget:self action:@selector(legendSwitchSegmentPressed:) forControlEvents:UIControlEventValueChanged];
    [legendControl setTintColor:[REMColor colorByHexString:@"#37ab3c"]];
    
    [self.ownerController.titleContainer addSubview:legendControl];
    
    legendControl.translatesAutoresizingMaskIntoConstraints=NO;
    
    NSMutableArray *tmpConstraints = [NSMutableArray array];
    NSDictionary *dict1 = NSDictionaryOfVariableBindings(legendControl);
    NSDictionary *metrics = @{@"rightMargin":@(kWidgetChartLeftMargin),@"height":@(kLegendSearchSwitcherHeight),@"width":@(kLegendSearchSwitcherWidth),@"top":@(kLegendSearchSwitcherTop)};
    [tmpConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[legendControl(width)]-rightMargin-|" options:0 metrics:metrics views:dict1]];
    [tmpConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[legendControl(height)]" options:0 metrics:metrics views:dict1]];
    
    [self.ownerController.titleContainer addConstraints:tmpConstraints];

    
    self.legendSearchControl=legendControl;
    
    
    REMButton *timePickerButton=[REMButton buttonWithType:UIButtonTypeCustom];
    timePickerButton.extendingInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    //[timePickerButton setFrame:CGRectMake(kWidgetDatePickerLeftMargin, kWidgetDatePickerTopMargin, kWidgetDatePickerWidth, kWidgetDatePickerHeight)];
    timePickerButton.layer.borderColor=[UIColor clearColor].CGColor;
    timePickerButton.layer.borderWidth=0;
    //[timePickerButton setBackgroundColor:[REMColor colorByHexString:@"#9d9d9d"]];
    
    timePickerButton.layer.cornerRadius=4;
    timePickerButton.translatesAutoresizingMaskIntoConstraints=NO;
    
    [timePickerButton setImage:REMIMG_DatePicker_Chart forState:UIControlStateNormal];
    timePickerButton.imageView.contentMode=UIViewContentModeLeft;
    [timePickerButton.imageView setFrame:CGRectMake(timePickerButton.imageView.frame.origin.x, timePickerButton.imageView.frame.origin.y, 26, 32)];
    //[timePickerButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kWidgetDatePickerWidth-100)];
    //[timePickerButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    [timePickerButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    //CGSize size= [timePickerButton sizeThatFits:CGSizeMake(500, kWidgetDatePickerHeight)];
    [timePickerButton sizeToFit];
    //timePickerButton.layer.borderColor=[UIColor redColor].CGColor;
    //timePickerButton.layer.borderWidth=1;
    timePickerButton.titleLabel.font=[REMFont defaultFontOfSize:kWidgetDatePickerTitleSize];
    [timePickerButton setTitleColor:[REMColor colorByHexString:@"#5e5e5e"] forState:UIControlStateNormal];
    
    [timePickerButton addTarget:self action:@selector(showTimePicker) forControlEvents:UIControlEventTouchUpInside];
    [timePickerButton addTarget:self action:@selector(timePickerPressDown) forControlEvents:UIControlEventTouchDown];
    
    [searchViewContainer addSubview:timePickerButton];
    
    
    
    
    
    self.timePickerButton = timePickerButton;
    
    [self.view addSubview:searchLegendViewContainer];
    
    self.searchView=searchViewContainer;
    
    REMSegmentedControl *stepControl=[[REMSegmentedControl alloc] initWithItems:@[@"test"] andMargins:CGPointMake(5,15)];
    stepControl.translatesAutoresizingMaskIntoConstraints=NO;
    [searchViewContainer addSubview:stepControl];
    
    stepControl.tintColor=[UIColor grayColor];
    UIFont *font = [REMFont defaultFontOfSize:14];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
    [stepControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    self.stepControl=stepControl;
    [self.stepControl addTarget:self action:@selector(stepChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    NSMutableArray *searchViewSubViewConstraints = [NSMutableArray array];
    NSDictionary *searchViewSubViewDic = NSDictionaryOfVariableBindings(timePickerButton,stepControl);
    NSDictionary *searchViewSubViewMetrics = @{@"margin":@(kWidgetDatePickerLeftMargin),@"buttonHeight":@(kWidgetDatePickerHeight),@"top":@(kWidgetDatePickerTopMargin),@"stepHeight":@(kWidgetStepButtonHeight),@"stepMinWidth":@(kWidgetStepSingleButtonWidth),@"stepMaxWidth":@(kWidgetStepSingleButtonWidth*3)};
    [searchViewSubViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[timePickerButton]" options:0 metrics:searchViewSubViewMetrics views:searchViewSubViewDic]];
    [searchViewSubViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[timePickerButton(buttonHeight)]" options:0 metrics:searchViewSubViewMetrics views:searchViewSubViewDic]];
    
    
    [searchViewSubViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[stepControl]-0-|" options:0 metrics:searchViewSubViewMetrics views:searchViewSubViewDic]];
    [searchViewSubViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[stepControl(stepHeight)]" options:0 metrics:searchViewSubViewMetrics views:searchViewSubViewDic]];
    
    [searchViewContainer addConstraints:searchViewSubViewConstraints];
    
    
    NSMutableArray *searchContainerConstraints = [NSMutableArray array];
    NSDictionary *searchContainerDic = NSDictionaryOfVariableBindings(searchViewContainer);
    NSDictionary *searchContainerMetrics = @{@"width":@(kDMChart_ToolbarWidth),@"height":@(self.searchLegendViewContainer.frame.size.height),@"margin":@(kDMCommon_ContentLeftMargin)};
    [searchContainerConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[searchViewContainer(width)]" options:0 metrics:searchContainerMetrics views:searchContainerDic]];
    [searchContainerConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[searchViewContainer(height)]-0-|" options:0 metrics:searchContainerMetrics views:searchContainerDic]];
    
    
    //峰谷分项
    if([self isElectricityCost]){
        UIFont *buttonFont = [REMFont defaultFontOfSize:14];
        NSString *buttonText = REMIPadLocalizedString(@"Chart_TouButton");
        REMButton *touButton = [REMButton buttonWithType:UIButtonTypeCustom];
        touButton.extendingInsets = UIEdgeInsetsMake(15, 5, 15, 5);
        touButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        touButton.titleLabel.font = buttonFont;
        touButton.translatesAutoresizingMaskIntoConstraints = NO;
        touButton.layer.cornerRadius = 3;
        [touButton setTitle:buttonText forState:UIControlStateNormal];
        [touButton addTarget:self action:@selector(touButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [searchViewContainer addSubview:touButton];
        self.touButton = touButton;
        [self updateTouButtonStyle];
        
        NSLayoutConstraint *touButtonConstraintX = [NSLayoutConstraint constraintWithItem:touButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:stepControl attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-20];
        NSLayoutConstraint *touButtonConstraintY = [NSLayoutConstraint constraintWithItem:touButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:stepControl attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        
        
        [searchViewContainer addConstraint:touButtonConstraintX];
        [searchViewContainer addConstraint:touButtonConstraintY];
    }

    [searchLegendViewContainer addConstraints:searchContainerConstraints];
}

-(void)updateTouButtonStyle
{
    if(self.isCostStacked){
        [self.touButton setBackgroundColor:[REMColor colorByHexString:@"#37ab3c"]];
        [self.touButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else{
        [self.touButton setBackgroundColor:[UIColor clearColor]];
        [self.touButton setTitleColor:[REMColor colorByHexString:@"#37ab3c"] forState:UIControlStateNormal];
    }
}

-(void)updateTouButtonConstraint{
    if(self.touButton){
        NSLayoutConstraint *touButtonConstraintX = [NSLayoutConstraint constraintWithItem:self.touButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.touButton.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *touButtonConstraintY = [NSLayoutConstraint constraintWithItem:self.touButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.touButton.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [self.searchView addConstraint:touButtonConstraintX];
        [self.searchView addConstraint:touButtonConstraintY];
    }
}

-(void)updateStepButton
{
    for (int i=0;i<self.stepControl.numberOfSegments;i++){
        NSString *title = [self.stepControl titleForSegmentAtIndex:i];
        
        if([title isEqualToString:REMIPadLocalizedString(@"Widget_StepRaw")] || [title isEqualToString:REMIPadLocalizedString(@"Common_Hour")]){
            //if there is raw or hour step button, disable/enable them according to stack status
            BOOL enable = self.isCostStacked ? NO : YES;
            [self.stepControl setEnabled:enable forSegmentAtIndex:i];
        }
    }
}

- (void)initChartView{
    UIView *c=[[UIView alloc]initWithFrame:CGRectMake(0, REMDMCOMPATIOS7(0), self.view.frame.size.width, kDMScreenHeight-kDMStatusBarHeight)];
    [c setBackgroundColor:[REMColor colorByHexString:@"#f4f4f4"]];
    
    [self.view insertSubview:c belowSubview:self.ownerController.titleContainer];
    
    UIView *chartContainer=[[UIView alloc]init];
    chartContainer.translatesAutoresizingMaskIntoConstraints=NO;
    [chartContainer setBackgroundColor:[UIColor whiteColor]];
    
    [c addSubview:chartContainer];
    self.chartContainer=chartContainer;
    self.maskerView=self.chartContainer;
    //self.chartContainer.layer.borderColor=[UIColor redColor].CGColor;
    //self.chartContainer.layer.borderWidth=1;
    //[self showEnergyChart];
    
    
    NSMutableArray *chartConstraints = [NSMutableArray array];
    UIView *searchView=self.searchView;
    NSDictionary *dic = NSDictionaryOfVariableBindings(chartContainer,searchView);
    NSDictionary *metrics = @{@"margin":@(kWidgetChartLeftMargin),@"height":@(kWidgetChartHeight),@"width":@(kWidgetChartWidth),@"top":@(0)};
    [chartConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[chartContainer(width)]-margin-|" options:0 metrics:metrics views:dic]];
    [chartConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[searchView]-top-[chartContainer]-margin-|" options:0 metrics:metrics views:dic]];
    
    [self.view addConstraints:chartConstraints];
}

- (void)timePickerPressDown{
    [self.timePickerButton setBackgroundColor:[REMColor colorByHexString:@"#ebebeb"]];
}

- (void) showTimePicker{
    [self.timePickerButton setBackgroundColor:[UIColor clearColor]];

    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main_IPad" bundle:nil];
    UINavigationController *nav=[storyboard instantiateViewControllerWithIdentifier:@"datePickerNavigationController"];
    nav.navigationBar.translucent=NO;
    UIPopoverController *popoverController=[[UIPopoverController alloc]initWithContentViewController:nav];
    popoverController.delegate=self;
    REMDatePickerViewController *dateViewController =nav.childViewControllers[0];
    dateViewController.relativeDate=self.tempModel.relativeDateComponent;
    dateViewController.timeRange=self.tempModel.timeRangeArray[0];
    dateViewController.relativeDateType=self.tempModel.relativeDateType;
    dateViewController.datePickerProtocol=self;
    dateViewController.popController=popoverController;
    
    dateViewController.showHour=[self.contentSyntax isHourSupported];
    [popoverController setPopoverContentSize:CGSizeMake(400, 500)];
    CGRect rect= CGRectMake(self.timePickerButton.frame.origin.x, self.searchLegendViewContainer.frame.origin.y+self.timePickerButton.frame.origin.y, self.timePickerButton.frame.size.width, self.timePickerButton.frame.size.height);
    [popoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown|UIPopoverArrowDirectionUp animated:YES];
    
    self.datePickerPopoverController=popoverController;
}

- (void)setCurrentLegendStatus:(REMWidgetLegendType)currentLegendStatus
{
    if(_currentLegendStatus!=currentLegendStatus){
        _currentLegendStatus=currentLegendStatus;
        if (self.chartWrapper==nil) return;
        if (currentLegendStatus==REMWidgetLegendTypeSearch) {
            [self.legendSearchControl setSelectedSegmentIndex:0];
            [self legendSwitcherStatus:0];
            [self hideLegendView];
        }
        else if(currentLegendStatus == REMWidgetLegendTypeLegend){
            [self.legendSearchControl setSelectedSegmentIndex:1];
            [self legendSwitcherStatus:1];
            [self showLegendView];
        }
        
    }
}


- (void)showChart{
    [super showChart];
    
//    if ([self.model isKindOfClass:[REMWidgetStepEnergyModel class]]==YES) {
//        if (self.energyData && self.energyData.targetEnergyData.count > 0) {
//            REMWidgetStepEnergyModel *tempModel=(REMWidgetStepEnergyModel *)self.model;
//            REMTargetEnergyData *data = (REMTargetEnergyData *)self.energyData.targetEnergyData[0];
//            if (data && data.target.subStep != tempModel.step) {
//                tempModel.step = data.target.subStep;
//            }
//        }
//    }
    
    if(self.energyData!=nil){
        [self showEnergyChart];
    }
    else{
        if (self.ownerController.serverError == nil && self.ownerController.isServerTimeout==NO) {
            [self search];
        }
        else{
            if([self.ownerController.serverError matchesErrorCode:@"990001202004"]){
                [self processStepErrorWithAvailableStep:self.ownerController.serverError.messages[0]];
            }
        }
    }
}

- (void)releaseChart{
    if(self.chartWrapper!=nil){
        //[self.chartWrapper destroyView];
        [[self.chartWrapper getView] removeFromSuperview];
        self.chartWrapper=nil;
    }
}

- (NSString *)calendarComponent{
    if(self.contentSyntax.calendarType==REMCalendarTypeHCSeason){
        return REMIPadLocalizedString(@"Widget_CalendarHC"); //"冷暖季";
    }
    else if(self.contentSyntax.calendarType==REMCalenderTypeHoliday){
        return REMIPadLocalizedString(@"Widget_CalendarHoliday");//非工作时间
    }
    else{
        return @"";
    }
}

- (void)checkCalendarDataWithCalendarType:(REMCalendarType)calendarType withSearchTimeRange:(REMTimeRange *)searchRange{
    NSArray *calendarDataArray=self.energyData.calendarData;
    if(calendarDataArray==nil || [calendarDataArray isEqual:[NSNull null]]==YES){
        NSString *text=REMIPadLocalizedString(@"Widget_CalendarTimeError");
        //看不到日历背景色？换个时间试试
        [self showPopupMsg:text];
    }
    else{
        NSMutableArray *validCalendarArray=[[NSMutableArray alloc]initWithCapacity:calendarDataArray.count];
        for (REMEnergyCalendarData *calendarData in calendarDataArray) {
            if([calendarData isEqual:[NSNull null]]==YES) continue;
            if(calendarType == REMCalendarTypeHCSeason && ( calendarData.calendarType == REMCalenderTypeHeatSeason ||
               calendarData.calendarType == REMCalenderTypeCoolSeason)){
                [validCalendarArray addObject:calendarData];
            }
            else if(calendarType == REMCalenderTypeHoliday && (calendarData.calendarType == REMCalenderTypeHoliday || calendarData.calendarType == REMCalenderTypeRestTime)){
                [validCalendarArray addObject:calendarData];
            }
            else{
                continue;
            }
        }
        BOOL showMsg=YES;
        for (REMEnergyCalendarData *calendarData in validCalendarArray) {
            
            for (REMTimeRange *range in calendarData.timeRanges) {
                if([range.endTime timeIntervalSinceDate:searchRange.endTime]<=0 && [range.endTime timeIntervalSinceDate:searchRange.startTime]>=0){
                    showMsg=NO;
                    break;
                }
                else if ([range.startTime timeIntervalSinceDate:searchRange.startTime] >= 0 && [range.startTime timeIntervalSinceDate:searchRange.endTime]<=0){
                    showMsg=NO;
                    break;
                }
                else if ([range.startTime timeIntervalSinceDate:searchRange.startTime]<=0 && [range.endTime timeIntervalSinceDate:searchRange.endTime]>=0){
                    showMsg=NO;
                    break;
                }
            }
            if(showMsg==NO){
                break;
            }
            
        }
        if(showMsg==YES){
            NSString *text=REMIPadLocalizedString(@"Widget_CalendarTimeError");
            //看不到日历背景色？换个时间试试
            [self showPopupMsg:text];
        }
    }
}

- (void) processCalendar{
    DCTrendWrapper *trend=(DCTrendWrapper *)self.chartWrapper;
    REMWidgetStepEnergyModel *tempModel=(REMWidgetStepEnergyModel *)self.tempModel;
    if(self.contentSyntax.calendarType == REMCalendarTypeHCSeason){
        if(tempModel.step == REMEnergyStepYear){
            [trend updateCalendarType:REMCalendarTypeNone];
            NSString *text=REMIPadLocalizedString(@"Widget_CalendarStepError");
            //"当前步长不支持显示冷暖季背景色"
            [self showPopupMsg:[NSString stringWithFormat:text,[self calendarComponent]]];
        }
        else{
            [trend updateCalendarType:REMCalendarTypeHCSeason];
            [self checkCalendarDataWithCalendarType:REMCalendarTypeHCSeason withSearchTimeRange:self.tempModel.timeRangeArray[0]];
        }
    }
    else if(self.contentSyntax.calendarType == REMCalenderTypeHoliday){
        if(tempModel.step == REMEnergyStepMonth ||
           tempModel.step == REMEnergyStepYear ||
           tempModel.step == REMEnergyStepWeek){
            [trend updateCalendarType:REMCalendarTypeNone];
            NSString *text=REMIPadLocalizedString(@"Widget_CalendarStepError");
            //"当前步长不支持显示非工作时间背景色"
            [self showPopupMsg:[NSString stringWithFormat:text,[self calendarComponent]]];
        }
        else{
            [trend updateCalendarType:REMCalenderTypeHoliday];
            [self checkCalendarDataWithCalendarType:REMCalenderTypeHoliday withSearchTimeRange:tempModel.timeRangeArray[0]];
        }
    }
    else{
        
    }

}

- (void) showEnergyChart{
    if(self.chartWrapper!=nil){
        return;
    }
    
    CGRect widgetRect = CGRectMake(0, 0, kWidgetChartWidth, kWidgetChartHeight);
    
    
    DCChartStyle* style = [DCChartStyle getMaximizedStyle];
    DAbstractChartWrapper  *widgetWrapper;
    DWrapperConfig* wrapperConfig = [[DWrapperConfig alloc]initWith:self.contentSyntax];
    if ([self.model isKindOfClass:[REMWidgetStepEnergyModel class]]==YES) {
        REMWidgetStepEnergyModel *stepModel=(REMWidgetStepEnergyModel *)self.model;
        wrapperConfig.step=stepModel.step;
        wrapperConfig.benckmarkText=stepModel.benchmarkText;
        wrapperConfig.relativeDateType=stepModel.relativeDateType;
//        wrapperConfig.multiTimeSpans=stepModel.timeRangeArray;
    }
    widgetWrapper = [REMWrapperFactor constructorWrapper:widgetRect data:self.energyData wrapperConfig:wrapperConfig style:style];
    if (widgetWrapper != nil) {
        widgetWrapper.delegate = self;
        [self.chartContainer addSubview:[widgetWrapper getView]];
        self.chartWrapper=widgetWrapper;
    }
    if (self.legendView==nil && self.currentLegendStatus==REMWidgetLegendTypeLegend) {
        [self.legendSearchControl setSelectedSegmentIndex:1];
        [self legendSwitcherStatus:1];
        [self showLegendView];
    }
}





- (void) setDatePickerButtonValueNoSearchByTimeRange:(REMTimeRange *)range withRelative:(NSString *)relativeDate withRelativeType:(REMRelativeTimeRangeType)relativeType
{
    NSString *text = nil;
    if ([self.contentSyntax isHourSupported]) {
        text = [REMTimeHelper formatTimeRangeFullHour:range];
    } else {
        text = [REMTimeHelper formatTimeRangeFullDay:range];
    }
    
    
    
    NSString *text1=[NSString stringWithFormat:@"  %@ %@",relativeDate,text];
    
    [self.timePickerButton setTitle:text1 forState:UIControlStateNormal];
    self.tempModel.relativeDateType=relativeType;
    [self.tempModel setTimeRangeItem:range AtIndex:0];
    
}



- (int)calculationStep:(NSArray *)stepList{
    int ret=0;
    for (NSNumber *number in stepList) {
        REMEnergyStep step=(REMEnergyStep)[number integerValue];
        if (step == REMEnergyStepHour) {
            ret|=1;
        }
        else if(step == REMEnergyStepDay){
            ret|=(1<<1);
        }
        else if(step == REMEnergyStepWeek){
            ret|=(1<<2);
        }
        else if(step == REMEnergyStepMonth){
            ret|=(1<<3);
        }
        else if(step == REMEnergyStepYear){
            ret|=(1<<4);
        }
    }
    
    return ret;
}

- (REMEnergyStep)reloadStepButtonGroup:(REMWidgetStepCalculationModel *)model withSelectedStep:(REMEnergyStep)step isMustContain:(BOOL)mustContain{
    NSArray *list=model.stepList;
    NSArray *titleList=model.titleList;
    NSUInteger defaultStepIndex=model.defaultStepIndex;
    NSNumber *newStep = [NSNumber numberWithInt:((int)step)];
    if (mustContain==YES) {
        if([list containsObject:newStep] == NO){
            return step;
        }
    }
    
    //Ratio should have no raw & hour step
    if(self.contentSyntax.dataStoreType == REMDSEnergyRatio){
        list = [list filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return ![@[@(REMEnergyStepMinute), @(REMEnergyStepHour)] containsObject:evaluatedObject];
        }]];
        
        titleList = [titleList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return ![@[REMIPadLocalizedString(@"Widget_StepRaw"),REMIPadLocalizedString(@"Common_Hour")] containsObject:evaluatedObject];
        }]];
    }
    
    self.currentStepList=list;
    [self.stepControl removeAllSegments];
    
    for (int i=0; i<titleList.count; ++i) {
        
        [self.stepControl insertSegmentWithTitle:titleList[i] atIndex:i animated:NO];
        [self.stepControl setWidth:kWidgetStepSingleButtonWidth forSegmentAtIndex:i];
    }
    
    if([self isElectricityCost]){
        [self updateStepButton];
    }
    
    NSUInteger idx;
    if([list containsObject:newStep] == YES)
    {
        idx= [list indexOfObject:newStep];
    }
    else
    {
        newStep = list[defaultStepIndex];
        idx =  defaultStepIndex;
    }
    
    [self.stepControl setSelectedSegmentIndex:idx];
    
    return (REMEnergyStep)[newStep intValue];
}

- (REMEnergyStep) initStepButtonWithRange:(REMTimeRange *)range WithStep:(REMEnergyStep)step{
    
    REMWidgetStepCalculationModel *model=[REMWidgetStepCalculationModel tryNewStepByRange:range];
    
    return [self reloadStepButtonGroup:model withSelectedStep:step isMustContain:NO];
}

- (void)stepChanged:(UISegmentedControl *)control{
    NSUInteger index=  control.selectedSegmentIndex;
    NSNumber *number=self.currentStepList[index];
    REMEnergyStep currentStep= (REMEnergyStep) [number intValue];
    [self setStepControlStatusByStep:currentStep];
}


- (void)setNewTimeRange:(REMTimeRange *)newRange withRelativeType:(REMRelativeTimeRangeType)relativeType withRelativeDateComponent:(NSString *)newDateComponent
{
    if(relativeType == REMRelativeTimeRangeTypeNone){
        [self setDatePickerButtonValueNoSearchByTimeRange:newRange withRelative:newDateComponent withRelativeType:relativeType ];
    }
    else{
        self.tempModel.relativeDateComponent=newDateComponent;
        self.tempModel.relativeDateType=relativeType;
        NSString *text=[REMTimeHelper formatTimeRangeFullHour:self.tempModel.timeRangeArray[0]];
        
        
        NSString *text1=[NSString stringWithFormat:@"%@ %@",self.tempModel.relativeDateComponent,text];
        
        [self.timePickerButton setTitle:text1 forState:UIControlStateNormal];
    }
    REMWidgetStepEnergyModel *tempModel=(REMWidgetStepEnergyModel *)self.tempModel;
    REMEnergyStep newStep= [self initStepButtonWithRange:newRange WithStep:tempModel.step];
    [self changeStep:newStep];
    
    [self search];
}



- (void)innerRollback{
    REMWidgetStepEnergyModel *stepModel=(REMWidgetStepEnergyModel *)self.model;
    [self initStepButtonWithRange:stepModel.timeRangeArray[0] WithStep:stepModel.step];
    [self setStepControlStatusByStepNoSearch:stepModel.step];
    [self setDatePickerButtonValueNoSearchByTimeRange:stepModel.timeRangeArray[0] withRelative:stepModel.relativeDateComponent withRelativeType:stepModel.relativeDateType];
    
    //TODO: need rollback tou button status
    if([self isElectricityCost]){
        self.isCostStacked = self.tempIsCostStacked;
        
        REMDataStoreType store = self.contentSyntax.dataStoreType;
        
        //energy.CostUsage,energy.CostUsageDistribution,energy.CostElectricityUsage,energy.CostElectricityUsageDistribution
        if(self.isCostStacked){
            if(store == REMDSEnergyCost){
                self.contentSyntax.dataStoreType = REMDSEnergyCostElectricity;
                self.contentSyntax.storeType = @"energy.CostElectricityUsage";
            }
            if(store == REMDSEnergyCostDistribute){
                self.contentSyntax.dataStoreType = REMDSEnergyCostDistributeElectricity;
                self.contentSyntax.storeType = @"energy.CostElectricityUsageDistribution";
            }
        }
        else{
            if(store == REMDSEnergyCostElectricity){
                self.contentSyntax.dataStoreType = REMDSEnergyCost;
                self.contentSyntax.storeType = @"energy.CostUsage";
            }
            if(store == REMDSEnergyCostDistributeElectricity){
                self.contentSyntax.dataStoreType = REMDSEnergyCostDistribute;
                self.contentSyntax.storeType = @"energy.CostUsageDistribution";
            }
        }
        
        [self updateTouButtonStyle];
        [self updateStepButton];
    }
    
    
    self.tempModel=[self.model copy];
    
}

- (void)processStepErrorWithAvailableStep:(NSString *)availableStep{
    NSMutableArray *buttonArray=[NSMutableArray array];
    NSArray *supportStep;
    NSArray *errorMsgArray;
    if([availableStep isEqualToString:@"Monthly"]==YES){
        //buttonArray=@[REMIPadLocalizedString(@"Common_Month"),REMIPadLocalizedString(@"Common_Year")];
        supportStep =@[@(REMEnergyStepMonth),@(REMEnergyStepYear)];
        errorMsgArray=@[REMIPadLocalizedString(@"Widget_StepErrorHour"),REMIPadLocalizedString(@"Widget_StepErrorDay"),REMIPadLocalizedString(@"Widget_StepErrorWeek")];
    }
    else if([availableStep isEqualToString:@"Daily"]==YES){
        //buttonArray=@[REMIPadLocalizedString(@"Common_Day"),REMIPadLocalizedString(@"Common_Week"),REMIPadLocalizedString(@"Common_Month")];
        supportStep =@[@(REMEnergyStepDay),@(REMEnergyStepWeek),@(REMEnergyStepMonth)];
        errorMsgArray=@[REMIPadLocalizedString(@"Widget_StepErrorHour")];
    }
    else if([availableStep isEqualToString:@"Weekly"]==YES){
        //buttonArray=@[REMIPadLocalizedString(@"Common_Week"),REMIPadLocalizedString(@"Common_Month"),REMIPadLocalizedString(@"Common_Year")];
        supportStep =@[@(REMEnergyStepWeek),@(REMEnergyStepMonth),@(REMEnergyStepYear)];
        errorMsgArray=@[REMIPadLocalizedString(@"Widget_StepErrorHour"),REMIPadLocalizedString(@"Widget_StepErrorDay")];
    }
    else if([availableStep isEqualToString:@"Yearly"]==YES){
        //buttonArray=@[REMIPadLocalizedString(@"Common_Year")];
        supportStep =@[@(REMEnergyStepYear)];
        errorMsgArray=@[REMIPadLocalizedString(@"Widget_StepErrorHour"),REMIPadLocalizedString(@"Widget_StepErrorDay"),REMIPadLocalizedString(@"Widget_StepErrorWeek"),REMIPadLocalizedString(@"Widget_StepErrorMonth")];
    }
    else if([availableStep isEqualToString:@"Hourly"]==YES){
        //buttonArray=@[REMIPadLocalizedString(@"Common_Hour"),REMIPadLocalizedString(@"Common_Daily"),REMIPadLocalizedString(@"Common_Week")];
        supportStep =@[@(REMEnergyStepHour),@(REMEnergyStepDay),@(REMEnergyStepWeek)];
        errorMsgArray=@[REMIPadLocalizedString(@"Widget_StepRaw")];
    }
    
    self.supportStepArray=supportStep;
    
    NSMutableArray *finalSupportStepArray=[NSMutableArray array];
    for (int i=0;i<self.supportStepArray.count;++i) {
        REMEnergyStep canStep=(REMEnergyStep)[self.supportStepArray[i] intValue];
        for (NSNumber *showStepNumber in self.currentStepList) {
            REMEnergyStep showStep=(REMEnergyStep)[showStepNumber intValue];
            if(showStep==canStep){
                [finalSupportStepArray addObject:@(showStep)];
            }
        }
    }
    if(finalSupportStepArray.count==0){
        self.supportStepArray=@[];
    }
    else{
        self.supportStepArray=finalSupportStepArray;
        for (int i=0; i<finalSupportStepArray.count; ++i) {
            REMEnergyStep showStep=(REMEnergyStep)[finalSupportStepArray[i] intValue];
            if (showStep == REMEnergyStepHour) {
                [buttonArray addObject:REMIPadLocalizedString(@"Common_Hour")];
            }
            else if(showStep == REMEnergyStepDay) {
                [buttonArray addObject:REMIPadLocalizedString(@"Common_Day")];
            }
            else if(showStep == REMEnergyStepWeek) {
                [buttonArray addObject:REMIPadLocalizedString(@"Common_Week")];
            }
            else if(showStep == REMEnergyStepMonth) {
                [buttonArray addObject:REMIPadLocalizedString(@"Common_Month")];
            }
            else if(showStep == REMEnergyStepYear) {
                [buttonArray addObject:REMIPadLocalizedString(@"Common_Year")];
            }
        }
        
    }
    UIAlertView *alert= [[UIAlertView alloc]init];
    alert.title=@"";
    for (int i=0; i<buttonArray.count; ++i) {
        [alert addButtonWithTitle:buttonArray[i]];
        
    }
    alert.delegate=self;
    [alert addButtonWithTitle:REMIPadLocalizedString(@"Common_Cancel")];
    
    alert.cancelButtonIndex=buttonArray.count;
    NSString *str= [errorMsgArray componentsJoinedByString:REMIPadLocalizedString(@"Widget_StepErrorJoinString")];
    alert.message= [NSString stringWithFormat: REMIPadLocalizedString(@"Widget_StepError"),str];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex>=self.supportStepArray.count) {
        [self innerRollback];
    }
    else{
        NSNumber *stepNumber=self.supportStepArray[buttonIndex];
        REMEnergyStep step=(REMEnergyStep)[stepNumber intValue];
        [self setStepControlStatusByStep:step];
    }
}

- (void)changeTimeRange:(REMTimeRange *)newRange{
   [self.tempModel setTimeRangeItem:newRange AtIndex:0];
}

- (void)setStepControlStatusByStepNoSearch:(REMEnergyStep)step{
    NSUInteger pressedIndex=NSNotFound;
    int i=0;
    for (; i<self.currentStepList.count; ++i) {
        NSNumber *stepNumber=self.currentStepList[i];
        REMEnergyStep step1=(REMEnergyStep)[stepNumber intValue];
        if(step1==step){
            pressedIndex=i;
            break;
        }
    }
    
    if(pressedIndex!=NSNotFound){
        [self.stepControl setSelectedSegmentIndex:pressedIndex];
        
    }
    
}



- (void) setStepControlStatusByStep:(REMEnergyStep)step{
    REMWidgetStepEnergyModel *tempModel=(REMWidgetStepEnergyModel *)self.tempModel;

    [self setStepControlStatusByStepNoSearch:step];
    
    tempModel.step=step;
    
    [self search];
}


- (void)rollbackWithError:(REMBusinessErrorInfo *)error
{
    [super rollbackWithError:error];
    
    if([error matchesErrorCode:@"990001202004"]) {
    //if([error.code isEqualToString:@"990001202004"]==YES){ //step error
        [self processStepErrorWithAvailableStep:error.messages[0]];
    }
    else{
        [self innerRollback];
    }
}

-(void)changeStep:(REMEnergyStep)newStep{
    REMWidgetStepEnergyModel *temp=(REMWidgetStepEnergyModel *)self.tempModel;
    temp.step=newStep;
}

- (void)reloadChart{
    if (self.chartWrapper==nil) {
        [self showEnergyChart];
        return;
    }
    REMWidgetStepEnergyModel *tempModel=(REMWidgetStepEnergyModel *)self.tempModel;
//    REMTargetEnergyData *data = (REMTargetEnergyData *)self.energyData.targetEnergyData[0];
//    if (data && data.target.subStep != tempModel.step) {
//        tempModel.step = data.target.subStep;
//    }
    
    if([self.chartWrapper isKindOfClass:[DCTrendWrapper class]]==YES){
        DCTrendWrapper *trend=(DCTrendWrapper *)self.chartWrapper;
        [self processCalendar];
//        [trend redraw:self.energyData step:data.target.subStep];
        [trend redraw:self.energyData step:tempModel.step];
    }
    else{
        [self.chartWrapper redraw:self.energyData];
    }
}


- (void)search{
    [self searchData:self.tempModel];
}

-(void)legendSwitchSegmentPressed:(UISegmentedControl *)segment
{
    if(segment.selectedSegmentIndex == 0){//search toolbar
        self.currentLegendStatus=REMWidgetLegendTypeSearch;
    }
    else{//legend toolbar
        self.currentLegendStatus=REMWidgetLegendTypeLegend;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BizDetailChanged" object:self userInfo:@{@"status":@(self.currentLegendStatus)}];
    
    [self legendSwitcherStatus:segment.selectedSegmentIndex];
}

- (void)legendSwitcherStatus:(NSUInteger)selectedIndex{
    if (!REMISIOS7) {
        if (selectedIndex == 0) {
            [self.legendSearchControl setImage:REMIMG_Legend_Chart_iOS6_Normal forSegmentAtIndex:1];
            [self.legendSearchControl setImage:REMIMG_DateView_Chart_iOS6 forSegmentAtIndex:0];
            
        }
        else{
            [self.legendSearchControl setImage:REMIMG_DateView_Chart_iOS6_Normal forSegmentAtIndex:0];
            [self.legendSearchControl setImage:REMIMG_Legend_Chart_iOS6 forSegmentAtIndex:1];
        }
    }
}

#pragma mark -
#pragma mark popoverController delegate
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.datePickerPopoverController=nil;
    
}


#pragma mark -
#pragma mark touch moved
- (void)gestureEndFrom:(id)start end:(id)end
{
    
    
    [self willRangeChange:start end:end];
    REMWidgetStepEnergyModel *tempModel=(REMWidgetStepEnergyModel *)self.tempModel;

    if(tempModel.step == REMEnergyStepHour || tempModel.step == REMEnergyStepMinute){
        [self search];
    }
}



- (void)willRangeChange:(id)start end:(id)end
{
    NSDate *newStart=start;
    NSDate *newEnd=end;
    NSCalendar *calendar= [REMTimeHelper gregorianCalendar];
    NSDateComponents *components= [calendar components:NSYearCalendarUnit| NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit| NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:newStart];
    [components setMinute:0];
    [components setSecond:0];
    newStart=[calendar dateFromComponents:components];
    components=[calendar components:NSYearCalendarUnit| NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit| NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:newEnd];
    [components setMinute:0];
    [components setSecond:0];
    newEnd=[calendar dateFromComponents:components];
    REMTimeRange *newRange=[[REMTimeRange alloc]initWithStartTime:newStart EndTime:newEnd];
    
    //when reload chart, willRangeChanged delegator is called by call, then change relative date to custom date,
    //this check avoids the situation
    REMTimeRange *modelTimeRange=self.model.timeRangeArray[0];
    if ([newRange.startTime isEqualToDate:modelTimeRange.startTime] && [newRange.endTime isEqualToDate:modelTimeRange.endTime]) {
        return;
    }
    
    REMWidgetStepCalculationModel *model= [REMWidgetStepCalculationModel tryNewStepByRange:newRange];
    if (model==nil) {
        return;
    }
    
    int currentStepInt=[self calculationStep:self.currentStepList];
    int newStepInt=[self calculationStep:model.stepList];
    REMWidgetStepEnergyModel *tempModel=(REMWidgetStepEnergyModel *)self.tempModel;

    if(currentStepInt!=newStepInt){
        [self reloadStepButtonGroup:model withSelectedStep:tempModel.step isMustContain:YES];
    }
    
    
    
    if([model.stepList containsObject:@(tempModel.step)]==NO){
        return;
    }
    
    
    NSString *text=[REMTimeHelper relativeDateComponentFromType:REMRelativeTimeRangeTypeNone];
    [self setDatePickerButtonValueNoSearchByTimeRange:newRange withRelative:text withRelativeType:REMRelativeTimeRangeTypeNone];
    
    return;
}

#pragma mark - Electricity cost

-(BOOL)isElectricityCost
{
    REMDataStoreType store = self.contentSyntax.dataStoreType;
    
    if(store == REMDSEnergyCost || store == REMDSEnergyCostElectricity || store == REMDSEnergyCostDistribute || store == REMDSEnergyCostDistributeElectricity){
        NSArray *commidities = self.contentSyntax.params[@"commodityIds"];
        if(!REMIsNilOrNull(commidities) && commidities.count == 1 && [commidities[0] integerValue] == REMCommodityElectricity){
            return YES;
        }
    }
    
    return NO;
}

-(BOOL)isWidgetStacking
{
    REMDataStoreType store = self.contentSyntax.dataStoreType;
    
    return store == REMDSEnergyCostElectricity || store == REMDSEnergyCostDistributeElectricity;
}

-(void)touButtonPressed:(UIButton *)sender
{
    REMDataStoreType store = self.contentSyntax.dataStoreType;
    
    self.tempIsCostStacked = !!self.isCostStacked;
    
    if(self.isCostStacked){
        self.isCostStacked = NO;
        if(store == REMDSEnergyCostElectricity){
            self.contentSyntax.dataStoreType = REMDSEnergyCost;
            self.contentSyntax.storeType = @"energy.CostUsage";
        }
        if(store == REMDSEnergyCostDistributeElectricity){
            self.contentSyntax.dataStoreType = REMDSEnergyCostDistribute;
            self.contentSyntax.storeType = @"energy.CostUsageDistribution";
        }
    }
    else{
        self.isCostStacked = YES;
        if(store == REMDSEnergyCost){
            self.contentSyntax.dataStoreType = REMDSEnergyCostElectricity;
            self.contentSyntax.storeType = @"energy.CostElectricityUsage";
        }
        if(store == REMDSEnergyCostDistribute){
            self.contentSyntax.dataStoreType = REMDSEnergyCostDistributeElectricity;
            self.contentSyntax.storeType = @"energy.CostElectricityUsageDistribution";
        }
    }
    
    [self updateTouButtonStyle];
    [self updateStepButton];
    [self search];
}


#pragma mark - Legend bar

-(void)showLegendView
{
    if(self.legendView == nil){
        REMChartLegendBase *view = [self prepareLegendView];
        
        [self.searchLegendViewContainer addSubview:view];
        self.legendView = view;
        
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.legendView.frame = kDMChart_ToolbarFrame;
        } completion:nil];
    }
}

-(void)hideLegendView
{
    if(self.legendView != nil){
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.legendView.frame = kDMChart_ToolbarHiddenFrame;
        } completion:^(BOOL finished) {
            [self.legendView removeFromSuperview];
            self.legendView = nil;
        }];
    }
}

-(REMChartLegendBase *)prepareLegendView
{
    //REMChartLegendBase *legend = [REMChartLegendBase legendWithData:self.energyData widget:self.widgetInfo parameters:self.tempModel andHiddenIndexes:self.hiddenSeries];
    REMChartLegendBase *legend = [REMChartLegendBase legendViewChartWrapper:self.chartWrapper data:self.energyData widget:self.widgetInfo parameters:self.tempModel delegate:self];
    
    return legend;
}

-(BOOL)canBeHiddenOnIndex:(int)index {
    return index >= 0 && [self.chartWrapper canSeriesBeHiddenAtIndex:index];
}

-(BOOL)canChangeSeriesTypeOnIndex:(int)index {
    if ([self.chartWrapper isKindOfClass:[DCTrendWrapper class]]) {
        DCTrendWrapper* wrapper = (DCTrendWrapper*)self.chartWrapper;
        return [wrapper canBeChangeSeriesAtIndex:index];
    }
    return NO;
}

-(void)tapLegendIconOnIndex:(int)index {
    if ([self.chartWrapper isKindOfClass:[DCTrendWrapper class]]) {
        DCTrendWrapper* wrapper = (DCTrendWrapper*)self.chartWrapper;
        [wrapper switchSeriesTypeAtIndex:index];
    }
}

-(void)legendStateChanged:(UIControlState)state onIndex:(int)index
{
    if(self.hiddenSeries == nil)
        self.hiddenSeries = [[NSMutableArray alloc] init];
    
    if(state == UIControlStateNormal){
        if([self.hiddenSeries containsObject:@(index)]){
            [self.hiddenSeries removeObject:@(index)];
        }
    }
    else{
        if([self.hiddenSeries containsObject:@(index)] == NO){
            [self.hiddenSeries addObject:@(index)];
        }
    }
    [self.chartWrapper setHiddenAtIndex:index hidden:(state != UIControlStateNormal)];
//    if ([self.chartWrapper isKindOfClass:[DCTrendWrapper class]]) {
//        [((DCTrendWrapper*)self.chartWrapper) setSeriesHiddenAtIndex:index hidden:(state != UIControlStateNormal)];
//    } else if ([self.chartWrapper isKindOfClass:[DCPieWrapper class]]) {
//        DCPieDataPoint* pie = ((DCPieChartView*)[self.chartWrapper getView]).series.datas[index];
//        pie.hidden = (state != UIControlStateNormal);
//    }
}

#pragma mark - Tooltip
// Trend chart delegate
-(void)highlightPoints:(NSArray*)points x:(id)x
{
    [self.searchLegendViewContainer setHidden:YES];
    
    if(self.tooltipView != nil){
        REMTrendChartTooltipView *trendTooltip = (REMTrendChartTooltipView *)self.tooltipView;
        
        [trendTooltip updateHighlightedData:points atX:x];
    }
    else{
        [self showTooltip:points forX:x];
    }
}

// Pie chart delegate
-(void)highlightPoint:(DCPieDataPoint*)point direction:(REMDirection)direction
{
    [self.searchLegendViewContainer setHidden:YES];
    
    if(self.tooltipView != nil){
        //now tooltip view is pie tooltip
        REMPieChartTooltipView *pieTooltip = (REMPieChartTooltipView *)self.tooltipView;
        
        [pieTooltip updateHighlightedData:@[point] fromDirection:direction];
    }
    else{
        [self showTooltip:@[point] forX:nil];
    }
}

-(void)tooltipWillDisapear
{
    //NSLog(@"tool tip will disappear");
    if(self.tooltipView==nil)
        return;
    
    [self.chartWrapper cancelToolTipStatus];
    
    [self.searchLegendViewContainer setHidden:NO];
    
    [self hideTooltip:^{
    }];
}

-(void)showTooltip:(NSArray *)highlightedPoints forX:(id)x
{
    REMTooltipViewBase *tooltip = [REMTooltipViewBase tooltipWithHighlightedPoints:highlightedPoints atX:x chartWrapper:self.chartWrapper inEnergyData:self.energyData widget:self.widgetInfo andParameters:self.tempModel];
    tooltip.tooltipDelegate = self;
    
    [self.view addSubview:tooltip];
    self.tooltipView = tooltip;
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        tooltip.frame = kDMChart_TooltipFrame;
    } completion:nil];
}

-(void)hideTooltip:(void (^)(void))complete
{
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tooltipView.frame = kDMChart_TooltipHiddenFrame;
    } completion:^(BOOL isCompleted){
        [self.tooltipView removeFromSuperview];
        self.tooltipView = nil;
        
        if(complete != nil)
            complete();
    }];
}

@end
