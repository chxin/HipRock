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
#import "REMChartLegendView.h"
#import "REMStackChartLegendView.h"
#import "REMClientErrorInfo.h"
#import "DCLineWrapper.h"
#import "DCColumnWrapper.h"
#import "DCRankingWrapper.h"
#import "DCPieWrapper.h"



@interface REMWidgetStepCalculationModel : NSObject

@property (nonatomic,strong) NSArray *stepList;
@property (nonatomic,strong) NSArray *titleList;
@property (nonatomic) REMEnergyStep defaultStep;
@property (nonatomic) NSUInteger defaultStepIndex;

@end

@implementation REMWidgetStepCalculationModel


@end



@interface REMWidgetEnergyDelegator()



@property (nonatomic,strong) UIPopoverController *datePickerPopoverController;

@property (nonatomic,strong) DAbstractChartWrapper *chartWrapper;
@property (nonatomic,strong) REMPieChartWrapper *pieWrapper;

@property (nonatomic,strong) NSArray *currentStepList;
@property (nonatomic,weak) REMTooltipViewBase *tooltipView;

@property (nonatomic,strong) REMWidgetStepEnergyModel *tempModel;

@property (nonatomic,strong) NSArray *supportStepArray;

@property (nonatomic,strong) NSMutableArray *hiddenSeries;

@property (nonatomic,weak) UIView *calendarMsgView;


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
    
    
    [self setDatePickerButtonValueNoSearchByTimeRange:self.tempModel.timeRangeArray[0] withRelative:self.tempModel.relativeDateComponent withRelativeType:self.tempModel.relativeDateType];
    [self initStepButtonWithRange:self.tempModel.timeRangeArray[0] WithStep:self.tempModel.step];
    [self setStepControlStatusByStepNoSearch:self.tempModel.step];
    
    //TODO:Temp code, remove when tooltip delegate is ok
    //[self.view addSubview:[self prepareTooltipView]];
}

- (void)initModelAndSearcher{
    self.model = [REMWidgetSearchModelBase searchModelByDataStoreType:self.widgetInfo.contentSyntax
                  .dataStoreType withParam:self.widgetInfo.contentSyntax.params];
    self.searcher=[REMEnergySeacherBase querySearcherByType:self.widgetInfo.contentSyntax.dataStoreType withWidgetInfo:self.widgetInfo];
    UIActivityIndicatorView *loader=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loader setColor:[UIColor blackColor]];
    [loader setBackgroundColor:[UIColor clearColor]];
    UIView *image=[[UIView alloc]init];
    [image setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4]];
    image.translatesAutoresizingMaskIntoConstraints=NO;
    self.searcher.loadingBackgroundView=image;
    self.searcher.loadingView=loader;
    loader.translatesAutoresizingMaskIntoConstraints=NO;
    REMWidgetStepEnergyModel *m=(REMWidgetStepEnergyModel *)self.model;
    m.relativeDateType=self.widgetInfo.contentSyntax.relativeDateType;
    
    self.tempModel=[self.model copy];
    
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
    [timePickerButton setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
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
    
    UIPopoverController *popoverController=[[UIPopoverController alloc]initWithContentViewController:nav];
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
    if(self.energyData!=nil){
        [self showEnergyChart];
    }
    else{
        [self search];
    }
}

- (void)releaseChart{
    if(self.chartWrapper!=nil){
        //[self.chartWrapper destroyView];
        [[self.chartWrapper getView] removeFromSuperview];
        self.chartWrapper=nil;
    }
    if(self.pieWrapper !=nil){
        [self.pieWrapper.view removeFromSuperview];
        self.pieWrapper=nil;
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
        [self showCalendarMsg:text];
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
            }
            if(showMsg==NO){
                break;
            }
            
        }
        if(showMsg==YES){
            NSString *text=NSLocalizedString(@"Widget_CalendarTimeError", @"");
            //看不到日历背景色？换个时间试试
            [self showCalendarMsg:text];
        }
    }
}

- (void) processCalendar{
    DCTrendWrapper *trend=(DCTrendWrapper *)self.chartWrapper;
    
    if(self.widgetInfo.contentSyntax.calendarType == REMCalendarTypeHCSeason){
        if(self.tempModel.step == REMEnergyStepYear){
            trend.calenderType=REMCalendarTypeNone;
            NSString *text=NSLocalizedString(@"Widget_CalendarStepError", @"");
            //"当前步长不支持显示冷暖季背景色"
            [self showCalendarMsg:[NSString stringWithFormat:text,[self calendarComponent]]];
        }
        else{
            trend.calenderType=REMCalendarTypeHCSeason;
            [self checkCalendarDataWithCalendarType:REMCalendarTypeHCSeason withSearchTimeRange:self.tempModel.timeRangeArray[0]];
        }
    }
    else if(self.widgetInfo.contentSyntax.calendarType == REMCalenderTypeHoliday){
        if(self.tempModel.step == REMEnergyStepMonth ||
           self.tempModel.step == REMEnergyStepYear ||
           self.tempModel.step == REMEnergyStepWeek){
            trend.calenderType=REMCalendarTypeNone;
            NSString *text=NSLocalizedString(@"Widget_CalendarStepError", @"");
            //"当前步长不支持显示非工作时间背景色"
            [self showCalendarMsg:[NSString stringWithFormat:text,[self calendarComponent]]];
        }
        else{
            trend.calenderType=REMCalenderTypeHoliday;
            [self checkCalendarDataWithCalendarType:REMCalenderTypeHoliday withSearchTimeRange:self.tempModel.timeRangeArray[0]];
        }
    }
    else{
        
    }

}

- (void)reloadChart{
    if (self.pieWrapper==nil && self.chartWrapper==nil) {
        [self showEnergyChart];
        return;
    }
    if(self.pieWrapper!=nil){
        [self.pieWrapper redraw:self.energyData];
        return;
    }
    
    if([self.chartWrapper isKindOfClass:[DCTrendWrapper class]]==YES){
        DCTrendWrapper *trend=(DCTrendWrapper *)self.chartWrapper;
        [self processCalendar];
        [trend redraw:self.energyData step:self.tempModel.step];
    }
    else{
        [self.chartWrapper redraw:self.energyData];
    }
}

- (void) showCalendarMsg:(NSString *)msg{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectZero];
    label.font=[UIFont fontWithName:@(kBuildingFontSCRegular) size:20];
    [label setBackgroundColor:[UIColor grayColor]];
    label.text=msg;
    label.textAlignment=NSTextAlignmentCenter;
    CGSize expectedLabelSize = [label.text sizeWithFont:label.font];
    CGFloat height=50;
    CGFloat margin=50;
    CGFloat bottom=10;
    [label setFrame:CGRectMake((kDMScreenWidth-(expectedLabelSize.width+margin))/2, REMDMCOMPATIOS7(kDMScreenHeight-kDMStatusBarHeight), expectedLabelSize.width+margin, height)];
    [self.view addSubview:label];
    [UIView animateWithDuration:0.5  delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        [label setFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y-height-bottom, label.frame.size.width,label.frame.size.height)];
    }completion: ^(BOOL finished){
        [UIView animateWithDuration:0.5 delay:3 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
            [label setFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y+height+bottom, label.frame.size.width,label.frame.size.height)];
        }completion:^(BOOL finished){
            [self hideCalendarMsg];
        }];
    }];
}

- (void) hideCalendarMsg{
    [self.calendarMsgView removeFromSuperview];
}

- (void) showEnergyChart{
    if(self.chartWrapper!=nil || self.pieWrapper){
        return;
    }
    
    CGRect widgetRect = CGRectMake(0, 0, kWidgetChartWidth, kWidgetChartHeight);
    
    REMDiagramType widgetType = self.widgetInfo.diagramType;
    
    REMChartStyle* style = [REMChartStyle getMaximizedStyle];
    DAbstractChartWrapper  *widgetWrapper;
    REMPieChartWrapper *pieWrapper;
    if (widgetType == REMDiagramTypeLine) {
        widgetWrapper = [[DCLineWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax style:style];
        widgetWrapper.delegate = self;
//        widgetWrapper = [[REMLineWidgetWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax style:style];
//        REMTrendChartView *trendChart= (REMTrendChartView *)widgetWrapper.view;
//        trendChart.delegate = self;
        
        
    } else if (widgetType == REMDiagramTypeColumn) {
        widgetWrapper = [[DCColumnWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax style:style];
        widgetWrapper.delegate = self;
//        widgetWrapper = [[REMColumnWidgetWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax style:style];
//        ((REMTrendChartView *)widgetWrapper.view).delegate = self;
    } else if (widgetType == REMDiagramTypePie) {
        pieWrapper = [[REMPieChartWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax style:style];
        ((REMPieChartView *)pieWrapper.view).delegate = self;
    } else if (widgetType == REMDiagramTypeRanking) {
        widgetWrapper = [[DCRankingWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax style:style];
        widgetWrapper.delegate = self;
    } else if (widgetType == REMDiagramTypeStackColumn) {
        widgetWrapper = [[DCColumnWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax style:style];
        widgetWrapper.delegate = self;
    }
    if (widgetWrapper != nil) {
        if([widgetWrapper isKindOfClass:[DCTrendWrapper class]]==YES){
            if(self.widgetInfo.contentSyntax.calendarType!=REMCalendarTypeNone){
                DCTrendWrapper *trend=(DCTrendWrapper *)widgetWrapper;
                trend.calenderType=self.widgetInfo.contentSyntax.calendarType;
            }
        }
        [self.chartContainer addSubview:[widgetWrapper getView]];
        self.chartWrapper=widgetWrapper;
    }
    else if(pieWrapper!=nil){
        [self.chartContainer addSubview:pieWrapper.view];
        self.pieWrapper=pieWrapper;
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

- (REMWidgetStepCalculationModel *)tryNewStepByRange:(REMTimeRange *)range {
    long diff = [range.endTime timeIntervalSinceDate:range.startTime];
    NSMutableArray *lvs=[[NSMutableArray alloc]initWithCapacity:7];
    [lvs addObject:[NSNumber numberWithLong:REMDAY]];
    [lvs addObject:[NSNumber numberWithLong:REMWEEK]];
    [lvs addObject:[NSNumber numberWithLong:REMDAY*31]];
    [lvs addObject:[NSNumber numberWithLong:REMDAY*31*3]];
    [lvs addObject:[NSNumber numberWithLong:REMYEAR]];
    [lvs addObject:[NSNumber numberWithLong:REMYEAR*2]];
    
    [lvs addObject:[NSNumber numberWithLong:REMYEAR*10]];
    
    //long[ *lvs = @[REMDAY,REMWEEK,31*REMDAY,31*3*REMDAY,REMYEAR,REMYEAR*2,REMYEAR*10];
    int i=0;
    for ( ; i<lvs.count; ++i)
    {
        NSNumber *num = lvs[i];
        if(diff<=[num longValue])
        {
            break;
        }
    }
    NSMutableArray *list=[[NSMutableArray alloc] initWithCapacity:3];
    NSMutableArray *titleList=[[NSMutableArray alloc] initWithCapacity:3];
    int defaultStepIndex=0;
    switch (i) {
        case 0:
            [list addObject:[NSNumber numberWithInt:1]];
            [titleList addObject: NSLocalizedString(@"Common_Hour", "")];//小时
            defaultStepIndex=0;
            break;
        case 1:
            [list addObject:[NSNumber numberWithInt:1]];
            [list addObject:[NSNumber numberWithInt:2]];
            [titleList addObject:NSLocalizedString(@"Common_Hour", "")];//小时
            [titleList addObject:NSLocalizedString(@"Common_Day", "")];//天
            defaultStepIndex=1;
            break;
        case 2:
            [list addObject:[NSNumber numberWithInt:2]];
            [list addObject:[NSNumber numberWithInt:5]];
            [titleList addObject:NSLocalizedString(@"Common_Day", "")];//天
            [titleList addObject:NSLocalizedString(@"Common_Week", "")];//周
            defaultStepIndex=0;
            break;
        case 3:
            [list addObject:[NSNumber numberWithInt:2]];
            [list addObject:[NSNumber numberWithInt:5]];
            [list addObject:[NSNumber numberWithInt:3]];
            [titleList addObject:NSLocalizedString(@"Common_Day", "")];//天
            [titleList addObject:NSLocalizedString(@"Common_Week", "")];//周
            [titleList addObject:NSLocalizedString(@"Common_Month", "")];//月
            defaultStepIndex=2;
            break;
        case 4:
            [list addObject:[NSNumber numberWithInt:3]];
            [titleList addObject:NSLocalizedString(@"Common_Month", "")];//月
            defaultStepIndex=0;
            break;
        case 5:
            [list addObject:[NSNumber numberWithInt:3]];
            [list addObject:[NSNumber numberWithInt:4]];
            [titleList addObject:NSLocalizedString(@"Common_Month", "")];//月
            [titleList addObject:NSLocalizedString(@"Common_Year", "")];//年
            defaultStepIndex=0;
            break;
        case 6:
            [list addObject:[NSNumber numberWithInt:3]];
            [list addObject:[NSNumber numberWithInt:4]];
            [titleList addObject:NSLocalizedString(@"Common_Month", "")];//月
            [titleList addObject:NSLocalizedString(@"Common_Year", "")];//年
            defaultStepIndex=0;
        default:
            break;
    }

    if (list.count==0) {
        return nil;
    }
    REMEnergyStep defaultStep=(REMEnergyStep)[list[defaultStepIndex] integerValue];
    
    REMWidgetStepCalculationModel *retModel=[[REMWidgetStepCalculationModel alloc]init];
    retModel.stepList=list;
    retModel.titleList=titleList;
    retModel.defaultStep=defaultStep;
    retModel.defaultStepIndex=defaultStepIndex;
    
    return retModel;
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
    
    REMWidgetStepCalculationModel *model=[self tryNewStepByRange:range];
    
    return [self reloadStepButtonGroup:model withSelectedStep:step isMustContain:NO];
}

- (void)stepChanged:(UISegmentedControl *)control{
    NSUInteger index=  control.selectedSegmentIndex;
    NSNumber *number=self.currentStepList[index];
    REMEnergyStep currentStep= (REMEnergyStep) [number intValue];
    [self setStepControlStatusByStep:currentStep];
}

- (void)copyTempModel{
    self.model=[self.tempModel copy];
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
    REMEnergyStep newStep= [self initStepButtonWithRange:newRange WithStep:self.tempModel.step];
    [self changeStep:newStep];
    
   
    
    [self search];
    
}



- (void)rollback{
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
        [self rollback];
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

- (void)changeStep:(REMEnergyStep)newStep{
    self.tempModel.step=newStep;
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
    [self setStepControlStatusByStepNoSearch:step];
    [self changeStep:step];
    
    [self search];
}

- (void)search{
    [self doSearchWithModel:self.tempModel callback:^(REMEnergyViewData *data,REMBusinessErrorInfo *error){
        if(data!=nil){
            [self copyTempModel];
            
            [self reloadChart];
            
        }
        else{
            if([error.code isEqualToString:@"990001202004"]==YES){ //step error
                [self processStepErrorWithAvailableStep:error.messages[0]];
            }
            else if([error isKindOfClass:[REMClientErrorInfo class]]==YES){
                REMClientErrorInfo *err=(REMClientErrorInfo *)error;
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:err.messageInfo delegate:nil cancelButtonTitle:NSLocalizedString(@"Common_OK", @"") otherButtonTitles:nil, nil];
                [alert show];
                [self rollback];
            }
        }
    }];
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
#pragma mark touch moved
- (void)touchEndedInNormalStatus:(id)start end:(id)end
{
    
    
    [self willRangeChange:start end:end];
    
    if(self.tempModel.step == REMEnergyStepHour){
        [self search];
    }
}



- (BOOL)willRangeChange:(id)start end:(id)end
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
    
    
    
    REMWidgetStepCalculationModel *model= [self tryNewStepByRange:newRange];
    if (model==nil) {
        return NO;
    }
    
    int currentStepInt=[self calculationStep:self.currentStepList];
    int newStepInt=[self calculationStep:model.stepList];
    if(currentStepInt!=newStepInt){
        [self reloadStepButtonGroup:model withSelectedStep:self.tempModel.step isMustContain:YES];
    }
    
    
    
    if([model.stepList containsObject:@(self.tempModel.step)]==NO){
        return NO;
    }
    
    
    NSString *text=[REMTimeHelper relativeDateComponentFromType:REMRelativeTimeRangeTypeNone];
    [self setDatePickerButtonValueNoSearchByTimeRange:newRange withRelative:text withRelativeType:REMRelativeTimeRangeTypeNone];
    
    return YES;
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
    REMChartLegendBase *legend = [REMChartLegendBase legendWithData:self.energyData widget:self.widgetInfo parameters:self.tempModel andHiddenIndexes:self.hiddenSeries];
    legend.itemDelegate = self;
    
    return legend;
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
    
    if ([self.chartWrapper isKindOfClass:[DCTrendWrapper class]]) {
        [((DCTrendWrapper*)self.chartWrapper) setSeriesHiddenAtIndex:index hidden:(state != UIControlStateNormal)];
    } else if ([self.chartWrapper isKindOfClass:[DCPieChartView class]]) {
        [((REMPieChartView*)[self.chartWrapper getView]) setSeriesHiddenAtIndex:index hidden:(state != UIControlStateNormal)];
    }
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
-(void)highlightPoint:(REMEnergyData*)point color:(UIColor*)color name:(NSString*)name direction:(REMDirection)direction
{
    //NSLog(@"Pie %@ is now on the niddle.", name);
    NSLog(@"direction is %d", direction);
    
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
        if(self.widgetInfo.diagramType == REMDiagramTypePie){
            id chartView = (id)self.pieWrapper.view;
            if([chartView respondsToSelector:@selector(cancelToolTipStatus)]){
                [chartView cancelToolTipStatus];
            }
        }
        else{
            [self.chartWrapper cancelToolTipStatus];
        }
        
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
