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
#import "DCLineWrapper.h"
#import "DCColumnWrapper.h"
#import "DCRankingWrapper.h"
#import "DCLabelingWrapper.h"
#import "DCPieWrapper.h"
#import "REMWidgetStepCalculationModel.h"




@interface REMWidgetEnergyDelegator()



@property (nonatomic,strong) UIPopoverController *datePickerPopoverController;

@property (nonatomic,strong) DAbstractChartWrapper *chartWrapper;

@property (nonatomic,strong) NSArray *currentStepList;
@property (nonatomic,weak) REMTooltipViewBase *tooltipView;



@property (nonatomic,strong) NSArray *supportStepArray;

@property (nonatomic,strong) NSMutableArray *hiddenSeries;

@property (nonatomic) BOOL isReloadChart;



@end

@implementation REMWidgetEnergyDelegator

- (id)init{
    self = [super init];
    if(self){
        _currentLegendStatus=REMWidgetLegendTypeSearch;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:)
                                                     name:@"BizDetailChanged"
                                                   object:nil];
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
    
    [self initModelAndSearcher];
    
    [self initSearchView];
    [self initChartView];
    
    if (self.widgetInfo.diagramType == REMDiagramTypePie) {
        [self.stepControl setHidden:YES];
    }
    
    REMWidgetStepEnergyModel *tempModel=(REMWidgetStepEnergyModel *)self.tempModel;
    
    [self setDatePickerButtonValueNoSearchByTimeRange:tempModel.timeRangeArray[0] withRelative:tempModel.relativeDateComponent withRelativeType:tempModel.relativeDateType];
    [self initStepButtonWithRange:tempModel.timeRangeArray[0] WithStep:tempModel.step];
    [self setStepControlStatusByStepNoSearch:tempModel.step];
    
    //TODO:Temp code, remove when tooltip delegate is ok
    //[self.view addSubview:[self prepareTooltipView]];
}

- (void)initModelAndSearcher{
    
    REMWidgetStepEnergyModel *m=(REMWidgetStepEnergyModel *)self.model;
    m.relativeDateType=self.widgetInfo.contentSyntax.relativeDateType;
    
}
- (void)initSearchView{
    
    UIView *searchLegendViewContainer=[[UIView alloc]initWithFrame:CGRectMake(0,self.ownerController.titleContainer.frame.origin.y+self.ownerController.titleContainer.frame.size.height,kDMScreenWidth,kDMChart_ToolbarHeight)];
    
    [searchLegendViewContainer setBackgroundColor:[UIColor clearColor]];
    
    
    UIView *searchViewContainer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, searchLegendViewContainer.frame.size.width, searchLegendViewContainer.frame.size.height)];
    searchViewContainer.translatesAutoresizingMaskIntoConstraints=NO;
    
    [searchViewContainer setBackgroundColor:[REMColor colorByHexString:@"#f4f4f4"]];
    
    [searchLegendViewContainer addSubview:searchViewContainer];
    
    self.searchLegendViewContainer=searchLegendViewContainer;
    
    UISegmentedControl *legendControl=[[UISegmentedControl alloc] initWithItems:@[@"search",@"legend"]];
    //[legendControl setFrame:CGRectMake(kLegendSearchSwitcherLeft, kLegendSearchSwitcherTop, kLegendSearchSwitcherWidth, kLegendSearchSwitcherHeight)];
    
    
    [legendControl setSegmentedControlStyle:UISegmentedControlStylePlain];
    
    [legendControl setImage:REMIMG_DateView_Chart forSegmentAtIndex:0];
    [legendControl setImage:REMIMG_Legend_Chart forSegmentAtIndex:1];
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
    
    
    UIButton *timePickerButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //[timePickerButton setFrame:CGRectMake(kWidgetDatePickerLeftMargin, kWidgetDatePickerTopMargin, kWidgetDatePickerWidth, kWidgetDatePickerHeight)];
    timePickerButton.layer.borderColor=[UIColor clearColor].CGColor;
    timePickerButton.layer.borderWidth=0;
    //[timePickerButton setBackgroundColor:[REMColor colorByHexString:@"#9d9d9d"]];
    [timePickerButton sizeToFit];
    timePickerButton.layer.cornerRadius=4;
    timePickerButton.translatesAutoresizingMaskIntoConstraints=NO;
    
    [timePickerButton setImage:REMIMG_DatePicker_Chart forState:UIControlStateNormal];
    //[timePickerButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kWidgetDatePickerWidth-100)];
    [timePickerButton setImageEdgeInsets:UIEdgeInsetsMake(0, -4, 0, 0)];
    //timePickerButton.layer.borderColor=[UIColor redColor].CGColor;
    //timePickerButton.layer.borderWidth=1;
    timePickerButton.titleLabel.font=[UIFont fontWithName:@(kBuildingFontSCRegular) size:kWidgetDatePickerTitleSize];
    [timePickerButton setTitleColor:[REMColor colorByHexString:@"#5e5e5e"] forState:UIControlStateNormal];
    
    [timePickerButton addTarget:self action:@selector(showTimePicker) forControlEvents:UIControlEventTouchUpInside];
    [timePickerButton addTarget:self action:@selector(timePickerPressDown) forControlEvents:UIControlEventTouchDown];
    
    [searchViewContainer addSubview:timePickerButton];
    
    
    
    
    
    self.timePickerButton = timePickerButton;
    
    [self.view addSubview:searchLegendViewContainer];
    
    self.searchView=searchViewContainer;
    
    UISegmentedControl *stepControl=[[UISegmentedControl alloc] initWithItems:@[]];
    stepControl.translatesAutoresizingMaskIntoConstraints=NO;
    [searchViewContainer addSubview:stepControl];
    
    stepControl.tintColor=[UIColor grayColor];
    UIFont *font = [UIFont fontWithName:@(kBuildingFontSCRegular) size:14];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:UITextAttributeFont];
    [stepControl setTitleTextAttributes:attributes
                           forState:UIControlStateNormal];
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

    [searchLegendViewContainer addConstraints:searchContainerConstraints];
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

    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
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
    dateViewController.showHour=YES;
    [popoverController setPopoverContentSize:CGSizeMake(400, 500)];
    CGRect rect= CGRectMake(self.timePickerButton.frame.origin.x, self.searchLegendViewContainer.frame.origin.y+self.timePickerButton.frame.origin.y, self.timePickerButton.frame.size.width, self.timePickerButton.frame.size.height);
    [popoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown|UIPopoverArrowDirectionUp animated:YES];
    
    self.datePickerPopoverController=popoverController;
}

- (void)setCurrentLegendStatus:(REMWidgetLegendType)currentLegendStatus
{
    if(_currentLegendStatus!=currentLegendStatus){
        _currentLegendStatus=currentLegendStatus;
        
        if (currentLegendStatus==REMWidgetLegendTypeSearch) {
            [self.legendSearchControl setSelectedSegmentIndex:0];
            [self hideLegendView];
        }
        else if(currentLegendStatus == REMWidgetLegendTypeLegend){
            [self.legendSearchControl setSelectedSegmentIndex:1];
            [self showLegendView];
        }
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"BizChanged"
         object:self userInfo:@{@"status":@(currentLegendStatus)}];
    }
}


- (void)showChart{
    [super showChart];
    if(self.energyData!=nil){
        [self showEnergyChart];
    }
    else{
        if (self.ownerController.serverError == nil) {
            [self search];
        }
        else{
            if([self.ownerController.serverError.code isEqualToString:@"990001202004"]==YES){ //step error
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
    if(self.widgetInfo.contentSyntax.calendarType==REMCalendarTypeHCSeason){
        return NSLocalizedString(@"Widget_CalendarHC", @""); //"冷暖季";
    }
    else if(self.widgetInfo.contentSyntax.calendarType==REMCalenderTypeHoliday){
        return NSLocalizedString(@"Widget_CalendarHoliday", @"");//非工作时间
    }
    else{
        return @"";
    }
}

- (void)checkCalendarDataWithCalendarType:(REMCalendarType)calendarType withSearchTimeRange:(REMTimeRange *)searchRange{
    NSArray *calendarDataArray=self.energyData.calendarData;
    if(calendarDataArray==nil || [calendarDataArray isEqual:[NSNull null]]==YES){
        NSString *text=NSLocalizedString(@"Widget_CalendarTimeError", @"");
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
            NSString *text=NSLocalizedString(@"Widget_CalendarTimeError", @"");
            //看不到日历背景色？换个时间试试
            [self showPopupMsg:text];
        }
    }
}

- (void) processCalendar{
    DCTrendWrapper *trend=(DCTrendWrapper *)self.chartWrapper;
    REMWidgetStepEnergyModel *tempModel=(REMWidgetStepEnergyModel *)self.tempModel;
    if(self.widgetInfo.contentSyntax.calendarType == REMCalendarTypeHCSeason){
        if(tempModel.step == REMEnergyStepYear){
            trend.calenderType=REMCalendarTypeNone;
            NSString *text=NSLocalizedString(@"Widget_CalendarStepError", @"");
            //"当前步长不支持显示冷暖季背景色"
            [self showPopupMsg:[NSString stringWithFormat:text,[self calendarComponent]]];
        }
        else{
            trend.calenderType=REMCalendarTypeHCSeason;
            [self checkCalendarDataWithCalendarType:REMCalendarTypeHCSeason withSearchTimeRange:self.tempModel.timeRangeArray[0]];
        }
    }
    else if(self.widgetInfo.contentSyntax.calendarType == REMCalenderTypeHoliday){
        if(tempModel.step == REMEnergyStepMonth ||
           tempModel.step == REMEnergyStepYear ||
           tempModel.step == REMEnergyStepWeek){
            trend.calenderType=REMCalendarTypeNone;
            NSString *text=NSLocalizedString(@"Widget_CalendarStepError", @"");
            //"当前步长不支持显示非工作时间背景色"
            [self showPopupMsg:[NSString stringWithFormat:text,[self calendarComponent]]];
        }
        else{
            trend.calenderType=REMCalenderTypeHoliday;
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
    
    REMDiagramType widgetType = self.widgetInfo.diagramType;
    
    REMChartStyle* style = [REMChartStyle getMaximizedStyle];
    DAbstractChartWrapper  *widgetWrapper;
    DWrapperConfig* wrapperConfig = [[DWrapperConfig alloc]initWith:self.widgetInfo];
    if ([self.model isKindOfClass:[REMWidgetStepEnergyModel class]]==YES) {
        REMWidgetStepEnergyModel *stepModel=(REMWidgetStepEnergyModel *)self.model;
        wrapperConfig.stacked=NO;
        wrapperConfig.step=stepModel.step;
        wrapperConfig.benckmarkText=stepModel.benchmarkText;
        wrapperConfig.relativeDateType=stepModel.relativeDateType;
    }
    
    if (widgetType == REMDiagramTypeLine) {
        widgetWrapper = [[DCLineWrapper alloc]initWithFrame:widgetRect data:self.energyData wrapperConfig:wrapperConfig style:style];
        widgetWrapper.delegate = self;
        
        
    } else if (widgetType == REMDiagramTypeColumn) {
        widgetWrapper = [[DCColumnWrapper alloc]initWithFrame:widgetRect data:self.energyData wrapperConfig:wrapperConfig style:style];
        widgetWrapper.delegate = self;
    } else if (widgetType == REMDiagramTypePie) {
        widgetWrapper = [[DCPieWrapper alloc]initWithFrame:widgetRect data:self.energyData wrapperConfig:wrapperConfig style:style];
        widgetWrapper.delegate = self;
    } else if (widgetType == REMDiagramTypeRanking) {
        widgetWrapper = [[DCRankingWrapper alloc]initWithFrame:widgetRect data:self.energyData wrapperConfig:wrapperConfig style:style];
        widgetWrapper.delegate = self;
    } else if (widgetType == REMDiagramTypeStackColumn) {
        wrapperConfig.stacked=YES;
        widgetWrapper = [[DCColumnWrapper alloc]initWithFrame:widgetRect data:self.energyData wrapperConfig:wrapperConfig style:style];
        widgetWrapper.delegate = self;
    } else if (widgetType == REMDiagramTypeLabelling) {
        widgetWrapper = [[DCLabelingWrapper alloc]initWithFrame:widgetRect data:self.energyData wrapperConfig:wrapperConfig style:style];
    }
    if (widgetWrapper != nil) {
        if([widgetWrapper isKindOfClass:[DCTrendWrapper class]]==YES){
            if(self.widgetInfo.contentSyntax.calendarType!=REMCalendarTypeNone){
                DCTrendWrapper *trend=(DCTrendWrapper *)widgetWrapper;
                trend.calenderType=self.widgetInfo.contentSyntax.calendarType;
                [self processCalendar];
            }
        }
        [self.chartContainer addSubview:[widgetWrapper getView]];
        self.chartWrapper=widgetWrapper;
    }    
}





- (void) setDatePickerButtonValueNoSearchByTimeRange:(REMTimeRange *)range withRelative:(NSString *)relativeDate withRelativeType:(REMRelativeTimeRangeType)relativeType
{
    NSString *text=[REMTimeHelper formatTimeRangeFullHour:range];
    
    
    
    
    NSString *text1=[NSString stringWithFormat:@"%@ %@",relativeDate,text];
    
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
        
        if([list containsObject:newStep] == NO)
        {
            return step;
        }

    }
    
    self.currentStepList=list;
    [self.stepControl removeAllSegments];
    
    for (int i=0; i<titleList.count; ++i) {
        [self.stepControl insertSegmentWithTitle:titleList[i] atIndex:i animated:NO];
        [self.stepControl setWidth:kWidgetStepSingleButtonWidth forSegmentAtIndex:i];
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
    self.tempModel=[self.model copy];
    
}

- (void)processStepErrorWithAvailableStep:(NSString *)availableStep{
    NSMutableArray *buttonArray=[NSMutableArray array];
    NSArray *supportStep;
    NSArray *errorMsgArray;
    if([availableStep isEqualToString:@"Monthly"]==YES){
        //buttonArray=@[NSLocalizedString(@"Common_Month", @""),NSLocalizedString(@"Common_Year", @"")];
        supportStep =@[@(REMEnergyStepMonth),@(REMEnergyStepYear)];
        errorMsgArray=@[NSLocalizedString(@"Widget_StepErrorHour", @""),NSLocalizedString(@"Widget_StepErrorDay", @""),NSLocalizedString(@"Widget_StepErrorWeek", @"")];
    }
    else if([availableStep isEqualToString:@"Daily"]==YES){
        //buttonArray=@[NSLocalizedString(@"Common_Day", @""),NSLocalizedString(@"Common_Week", @""),NSLocalizedString(@"Common_Month", @"")];
        supportStep =@[@(REMEnergyStepDay),@(REMEnergyStepWeek),@(REMEnergyStepMonth)];
        errorMsgArray=@[NSLocalizedString(@"Widget_StepErrorHour", @"")];
    }
    else if([availableStep isEqualToString:@"Weekly"]==YES){
        //buttonArray=@[NSLocalizedString(@"Common_Week", @""),NSLocalizedString(@"Common_Month", @""),NSLocalizedString(@"Common_Year", @"")];
        supportStep =@[@(REMEnergyStepWeek),@(REMEnergyStepMonth),@(REMEnergyStepYear)];
        errorMsgArray=@[NSLocalizedString(@"Widget_StepErrorHour", @""),NSLocalizedString(@"Widget_StepErrorDay", @"")];
    }
    else if([availableStep isEqualToString:@"Yearly"]==YES){
        //buttonArray=@[NSLocalizedString(@"Common_Year", @"")];
        supportStep =@[@(REMEnergyStepYear)];
        errorMsgArray=@[NSLocalizedString(@"Widget_StepErrorHour", @""),NSLocalizedString(@"Widget_StepErrorDay", @""),NSLocalizedString(@"Widget_StepErrorWeek", @""),NSLocalizedString(@"Widget_StepErrorMonth", @"")];
    }
    else if([availableStep isEqualToString:@"Hourly"]==YES){
        //buttonArray=@[NSLocalizedString(@"Common_Hour", @""),NSLocalizedString(@"Common_Daily", @""),NSLocalizedString(@"Common_Week", @"")];
        supportStep =@[@(REMEnergyStepHour),@(REMEnergyStepDay),@(REMEnergyStepWeek)];
        errorMsgArray=@[];
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
                [buttonArray addObject:NSLocalizedString(@"Common_Hour", @"")];
            }
            else if(showStep == REMEnergyStepDay) {
                [buttonArray addObject:NSLocalizedString(@"Common_Day", @"")];
            }
            else if(showStep == REMEnergyStepWeek) {
                [buttonArray addObject:NSLocalizedString(@"Common_Week", @"")];
            }
            else if(showStep == REMEnergyStepMonth) {
                [buttonArray addObject:NSLocalizedString(@"Common_Month", @"")];
            }
            else if(showStep == REMEnergyStepYear) {
                [buttonArray addObject:NSLocalizedString(@"Common_Year", @"")];
            }
        }
        
    }
    UIAlertView *alert= [[UIAlertView alloc]init];
    alert.title=@"";
    for (int i=0; i<buttonArray.count; ++i) {
        [alert addButtonWithTitle:buttonArray[i]];
        
    }
    alert.delegate=self;
    [alert addButtonWithTitle:NSLocalizedString(@"Common_Cancel", @"")];
    
    alert.cancelButtonIndex=buttonArray.count;
    NSString *str= [errorMsgArray componentsJoinedByString:@","];
    alert.message= [NSString stringWithFormat: NSLocalizedString(@"Widget_StepError", @""),str];
    
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
    if([error.code isEqualToString:@"990001202004"]==YES){ //step error
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

    if([self.chartWrapper isKindOfClass:[DCTrendWrapper class]]==YES){
        DCTrendWrapper *trend=(DCTrendWrapper *)self.chartWrapper;
        [self processCalendar];
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

    if(tempModel.step == REMEnergyStepHour){
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


#pragma mark - Legend bar

-(void)showLegendView
{
    if(self.legendView == nil){
        UIView *view = [self prepareLegendView];
        
        //TODO: should add into container
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

-(UIView *)prepareLegendView
{
    //REMChartLegendBase *legend = [REMChartLegendBase legendWithData:self.energyData widget:self.widgetInfo parameters:self.tempModel andHiddenIndexes:self.hiddenSeries];
    REMChartLegendBase *legend = [REMChartLegendBase legendViewChartWrapper:self.chartWrapper data:self.energyData widget:self.widgetInfo parameters:self.tempModel];
    legend.itemDelegate = self;
    
    return legend;
}

-(BOOL)canBeHidden {
    return [self.chartWrapper getVisableSeriesCount] > 1;
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
    
    [self hideTooltip:^{
        [self.chartWrapper cancelToolTipStatus];
        
        [self.searchLegendViewContainer setHidden:NO];
    }];
}

-(void)showTooltip:(NSArray *)highlightedPoints forX:(id)x
{
    REMTooltipViewBase *tooltip = [REMTooltipViewBase tooltipWithHighlightedPoints:highlightedPoints atX:x inEnergyData:self.energyData widget:self.widgetInfo andParameters:self.tempModel];
    tooltip.tooltipDelegate = self;
    
    [self.view addSubview:tooltip];
    self.tooltipView = tooltip;
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        tooltip.frame = kDMChart_TooltipFrame;
    } completion:nil];
}

-(void)hideTooltip:(void (^)(void))complete
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tooltipView.frame = kDMChart_TooltipHiddenFrame;
    } completion:^(BOOL isCompleted){
        [self.tooltipView removeFromSuperview];
        self.tooltipView = nil;
        
        if(complete != nil)
            complete();
    }];
}

@end
