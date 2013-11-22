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
#import "DChartLineChartWrapper.h"
#import "DChartColumnWrapper.h"

@interface REMWidgetEnergyDelegator()



@property (nonatomic,strong) UIPopoverController *datePickerPopoverController;

@property (nonatomic,strong) REMAbstractChartWrapper *chartWrapper;

@property (nonatomic,strong) NSArray *currentStepList;
@property (nonatomic,weak) REMTooltipViewBase *tooltipView;

@property (nonatomic,strong) REMWidgetStepEnergyModel *tempModel;

@property (nonatomic,strong) NSArray *supportStepArray;

@property (nonatomic,strong) NSMutableArray *hiddenSeries;


@property (nonatomic,weak) UIView *calendarMsgView;


@end

@implementation REMWidgetEnergyDelegator

- (void)initBizView{
    
    [self initModelAndSearcher];
    
    [self initSearchView];
    [self initChartView];
    
    
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
    [loader setColor:[UIColor grayColor]];
    [loader setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3]];
    self.searcher.loadingView=loader;
    loader.translatesAutoresizingMaskIntoConstraints=NO;
    REMWidgetStepEnergyModel *m=(REMWidgetStepEnergyModel *)self.model;
    m.relativeDateType=self.widgetInfo.contentSyntax.relativeDateType;
    
    self.tempModel=[self.model copy];
    
}
- (void)initSearchView{
    
    UIView *searchViewContainer=[[UIView alloc]initWithFrame:CGRectMake(0,self.ownerController.titleContainer.frame.origin.y+self.ownerController.titleContainer.frame.size.height,kDMChart_ToolbarWidth,kDMChart_ToolbarHeight)];
    //searchViewContainer.translatesAutoresizingMaskIntoConstraints=NO;
    
    [searchViewContainer setBackgroundColor:[REMColor colorByHexString:@"#f4f4f4"]];
    
    UISegmentedControl *legendControl=[[UISegmentedControl alloc] initWithItems:@[@"search",@"legend"]];
    //[legendControl setFrame:CGRectMake(kLegendSearchSwitcherLeft, kLegendSearchSwitcherTop, kLegendSearchSwitcherWidth, kLegendSearchSwitcherHeight)];
    
    
    [legendControl setSegmentedControlStyle:UISegmentedControlStyleBezeled];
    
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
    
    timePickerButton.layer.cornerRadius=4;
    timePickerButton.translatesAutoresizingMaskIntoConstraints=NO;
    
    [timePickerButton setImage:REMIMG_DatePicker_Chart forState:UIControlStateNormal];
    [timePickerButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kWidgetDatePickerWidth-100)];
    timePickerButton.titleLabel.font=[UIFont fontWithName:@(kBuildingFontSCRegular) size:kWidgetDatePickerTitleSize];
    [timePickerButton setTitleColor:[REMColor colorByHexString:@"#5e5e5e"] forState:UIControlStateNormal];
    
    [timePickerButton addTarget:self action:@selector(showTimePicker) forControlEvents:UIControlEventTouchUpInside];
    [timePickerButton addTarget:self action:@selector(timePickerPressDown) forControlEvents:UIControlEventTouchDown];
    
    [searchViewContainer addSubview:timePickerButton];
    
    
    
    
    
    self.timePickerButton = timePickerButton;
    
    [self.view addSubview:searchViewContainer];
    
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
    NSDictionary *searchViewSubViewMetrics = @{@"margin":@(kWidgetDatePickerLeftMargin),@"buttonHeight":@(kWidgetDatePickerHeight),@"buttonWidth":@(kWidgetDatePickerWidth),@"top":@(kWidgetDatePickerTopMargin),@"stepHeight":@(kWidgetStepButtonHeight),@"stepMinWidth":@(kWidgetStepSingleButtonWidth),@"stepMaxWidth":@(kWidgetStepSingleButtonWidth*3)};
    [searchViewSubViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[timePickerButton(buttonWidth)]" options:0 metrics:searchViewSubViewMetrics views:searchViewSubViewDic]];
    [searchViewSubViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[timePickerButton(buttonHeight)]" options:0 metrics:searchViewSubViewMetrics views:searchViewSubViewDic]];
    
    [searchViewSubViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[stepControl]-margin-|" options:0 metrics:searchViewSubViewMetrics views:searchViewSubViewDic]];
    [searchViewSubViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[stepControl(stepHeight)]" options:0 metrics:searchViewSubViewMetrics views:searchViewSubViewDic]];
    
    [searchViewContainer addConstraints:searchViewSubViewConstraints];
    
    
    
}

- (void)initChartView{
    UIView *c=[[UIView alloc]initWithFrame:CGRectMake(0, REMDMCOMPATIOS7(0), self.view.frame.size.width, kDMScreenHeight-kDMStatusBarHeight)];
    [c setBackgroundColor:[REMColor colorByHexString:@"#f4f4f4"]];
    //UIView *chartContainer=[[UIView alloc]initWithFrame:CGRectMake(kWidgetChartLeftMargin, 0, kWidgetChartWidth, kWidgetChartHeight)];
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
    CGRect rect= CGRectMake(self.timePickerButton.frame.origin.x, self.searchView.frame.origin.y+self.timePickerButton.frame.origin.y, self.timePickerButton.frame.size.width, self.timePickerButton.frame.size.height);
    [popoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown|UIPopoverArrowDirectionUp animated:YES];
    
    self.datePickerPopoverController=popoverController;
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
        [self.chartWrapper destroyView];
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
        BOOL showMsg=NO;
        for (REMEnergyCalendarData *calendarData in validCalendarArray) {
            for (REMTimeRange *range in calendarData.timeRanges) {
                if(range.endTime>=searchRange.startTime){
                    showMsg=YES;
                    break;
                }
            }
            if(showMsg==YES){
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
    REMTrendWidgetWrapper *trend=(REMTrendWidgetWrapper *)self.chartWrapper;
    
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
    
    if([self.chartWrapper isKindOfClass:[REMTrendWidgetWrapper class]]==YES){
        REMTrendWidgetWrapper *trend=(REMTrendWidgetWrapper *)self.chartWrapper;
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
    if(self.chartWrapper!=nil){
        return;
    }
    
    CGRect widgetRect = CGRectMake(0, 0, kWidgetChartWidth, kWidgetChartHeight);
    
    REMDiagramType widgetType = self.widgetInfo.diagramType;
    
    REMChartStyle* style = [REMChartStyle getMaximizedStyle];
    REMAbstractChartWrapper  *widgetWrapper;
    if (widgetType == REMDiagramTypeLine) {
//        widgetWrapper = [[DChartLineChartWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax style:style];
//        ((DTrendChartWrapper*)widgetWrapper).delegate = self;
        widgetWrapper = [[REMLineWidgetWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax style:style];
        REMTrendChartView *trendChart= (REMTrendChartView *)widgetWrapper.view;
        trendChart.delegate = self;
        
        
    } else if (widgetType == REMDiagramTypeColumn) {
//        widgetWrapper = [[DChartColumnWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax style:style];
//        ((DTrendChartWrapper*)widgetWrapper).delegate = self;
        widgetWrapper = [[REMColumnWidgetWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax style:style];
        ((REMTrendChartView *)widgetWrapper.view).delegate = self;
    } else if (widgetType == REMDiagramTypePie) {
        widgetWrapper = [[REMPieChartWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax style:style];
        ((REMPieChartView *)widgetWrapper.view).delegate = self;
    } else if (widgetType == REMDiagramTypeRanking) {
        widgetWrapper = [[REMRankingWidgetWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax style:style];
        ((REMTrendChartView *)widgetWrapper.view).delegate = self;
    } else if (widgetType == REMDiagramTypeStackColumn) {
        widgetWrapper = [[REMStackColumnWidgetWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax style:style];
        ((REMTrendChartView *)widgetWrapper.view).delegate = self;
    }
    if (widgetWrapper != nil) {
        if([widgetWrapper isKindOfClass:[REMTrendWidgetWrapper class]]==YES){
            if(self.widgetInfo.contentSyntax.calendarType!=REMCalendarTypeNone){
                REMTrendWidgetWrapper *trend=(REMTrendWidgetWrapper *)widgetWrapper;
                trend.calenderType=self.widgetInfo.contentSyntax.calendarType;
            }
        }
        [self.chartContainer addSubview:widgetWrapper.view];
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

- (REMEnergyStep) initStepButtonWithRange:(REMTimeRange *)range WithStep:(REMEnergyStep)step{
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
    int defaultStepIndex;
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
    
    
    self.currentStepList=list;
    [self.stepControl removeAllSegments];
    
    for (int i=0; i<titleList.count; ++i) {
        [self.stepControl insertSegmentWithTitle:titleList[i] atIndex:i animated:NO];
        [self.stepControl setWidth:kWidgetStepSingleButtonWidth forSegmentAtIndex:i];
    }
    //[self.searchView updateConstraints];
    //[self.stepControl updateConstraints];
    //UISegmentedControl *control= [[UISegmentedControl alloc] initWithItems:titleList];
    //[control setSegmentedControlStyle:UISegmentedControlStyleBezeled];
    //CGFloat x=kDMScreenWidth-kWidgetChartLeftMargin*2-list.count*kWidgetStepSingleButtonWidth;
    
    //CGRect frame= CGRectMake(x, self.timePickerButton.frame.origin.y, list.count*kWidgetStepSingleButtonWidth, kWidgetStepButtonHeight);
    
    //control.tintColor=[UIColor grayColor];
    
    
    
    
    //[control setFrame:frame];
    //[self.stepControl removeFromSuperview];
    //[self.searchView addSubview:control];
    //self.stepControl=control;
    //[self.stepControl addTarget:self action:@selector(stepChanged:) forControlEvents:UIControlEventValueChanged];
    NSNumber *newStep = [NSNumber numberWithInt:((int)step)];
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
    NSArray *buttonArray;
    NSArray *supportStep;
    NSArray *errorMsgArray;
    if([availableStep isEqualToString:@"Monthly"]==YES){
        buttonArray=@[NSLocalizedString(@"Common_Month", @""),NSLocalizedString(@"Common_Year", @"")];
        supportStep =@[@(REMEnergyStepMonth),@(REMEnergyStepYear)];
        errorMsgArray=@[NSLocalizedString(@"Widget_StepErrorHour", @""),NSLocalizedString(@"Widget_StepErrorDay", @""),NSLocalizedString(@"Widget_StepErrorWeek", @"")];
    }
    else if([availableStep isEqualToString:@"Daily"]==YES){
        buttonArray=@[NSLocalizedString(@"Common_Day", @""),NSLocalizedString(@"Common_Week", @""),NSLocalizedString(@"Common_Month", @"")];
        supportStep =@[@(REMEnergyStepDay),@(REMEnergyStepWeek),@(REMEnergyStepMonth)];
        errorMsgArray=@[NSLocalizedString(@"Widget_StepErrorHour", @"")];
    }
    else if([availableStep isEqualToString:@"Weekly"]==YES){
        buttonArray=@[NSLocalizedString(@"Common_Week", @""),NSLocalizedString(@"Common_Month", @""),NSLocalizedString(@"Common_Year", @"")];
        supportStep =@[@(REMEnergyStepWeek),@(REMEnergyStepMonth),@(REMEnergyStepYear)];
        errorMsgArray=@[NSLocalizedString(@"Widget_StepErrorHour", @""),NSLocalizedString(@"Widget_StepErrorDay", @"")];
    }
    else if([availableStep isEqualToString:@"Yearly"]==YES){
        buttonArray=@[NSLocalizedString(@"Common_Year", @"")];
        supportStep =@[@(REMEnergyStepYear)];
        errorMsgArray=@[NSLocalizedString(@"Widget_StepErrorHour", @""),NSLocalizedString(@"Widget_StepErrorDay", @""),NSLocalizedString(@"Widget_StepErrorWeek", @""),NSLocalizedString(@"Widget_StepErrorMonth", @"")];
    }
    else if([availableStep isEqualToString:@"Hourly"]==YES){
        buttonArray=@[NSLocalizedString(@"Common_Hour", @""),NSLocalizedString(@"Common_Daily", @""),NSLocalizedString(@"Common_Week", @"")];
        supportStep =@[@(REMEnergyStepHour),@(REMEnergyStepDay),@(REMEnergyStepWeek)];
        errorMsgArray=@[];
    }
    else{
        buttonArray=@[];
    }
    self.supportStepArray=supportStep;
    BOOL include=NO;
    for (NSNumber *canStepNumber in self.supportStepArray) {
        REMEnergyStep canStep=(REMEnergyStep)[canStepNumber intValue];
        for (NSNumber *showStepNumber in self.currentStepList) {
            REMEnergyStep showStep=(REMEnergyStep)[showStepNumber intValue];
            if(showStep==canStep){
                include=YES;
                break;
            }
        }
        if(include==YES){
            break;
        }
    }
    if(include==NO){
        buttonArray=@[];
        self.supportStepArray=@[];
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
        //if legend toolbar display, move it out of the view
        if(self.legendView != nil){
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.legendView.frame = kDMChart_ToolbarHiddenFrame;
            } completion:^(BOOL finished) {
                [self.legendView removeFromSuperview];
                self.legendView = nil;
            }];
            
        }
    }
    else{//legend toolbar
        //if legend toolbar is not presenting, move it into the view
        if(self.legendView == nil){
            UIView *view = [self prepareLegendView];
            
            [self.view addSubview:view];
            self.legendView = view;
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.legendView.frame = kDMChart_ToolbarFrame;
            } completion:nil];
        }
    }
    
}

#pragma mark -
#pragma mark touch moved
- (void)touchEndedInNormalStatus:(id)start end:(id)end
{
    NSDate *newStart=start;
    NSDate *newEnd=end;
    
    [self willRangeChange:start end:end];
    
    if(self.tempModel.step == REMEnergyStepHour){
        [self search];
    }
}

- (void)willRangeChange:(id)start end:(id)end
{
    NSDate *newStart=start;
    NSDate *newEnd=end;
    
    REMTimeRange *newRange=[[REMTimeRange alloc]initWithStartTime:newStart EndTime:newEnd];
    
    [self setDatePickerButtonValueNoSearchByTimeRange:newRange withRelative:self.tempModel.relativeDateComponent withRelativeType:self.tempModel.relativeDateType];
}


#pragma mark - Legend bar

-(UIView *)prepareLegendView
{
    REMChartLegendBase *legend = [REMChartLegendBase legendWithData:self.energyData widget:self.widgetInfo parameters:self.tempModel andHiddenIndexes:self.hiddenSeries];
    legend.itemDelegate = self;
    
    return legend;
}

-(void)legendStateChanged:(UIControlState)state onIndex:(int)index
{
    //hide or show the series on index according to state
    //NSLog(@"Series %d is going to %@", index, state == UIControlStateNormal?@"show":@"hide");
    
    //if([self.chartWrapper.view isKindOfClass:[REMTrendChartView class]]){
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
    
        if([self.chartWrapper.view respondsToSelector:@selector(setSeriesHiddenAtIndex:hidden:)])
            [((id)self.chartWrapper.view) setSeriesHiddenAtIndex:index hidden:(state != UIControlStateNormal)];
    //}
}

#pragma mark - Tooltip
// Trend chart delegate
-(void)highlightPoints:(NSArray*)points colors:(NSArray*)colors names:(NSArray*)names
{
    //what's stack column chart tooltip like?
    if(self.widgetInfo.diagramType == REMDiagramTypeStackColumn){
        return;
    }
    
    [self.searchView setHidden:YES];
    
    if(self.tooltipView!=nil){
        [self.tooltipView updateHighlightedData:points];
    }
    else{
        [self showTooltip:points];
    }
}

// Pie chart delegate
-(void)highlightPoint:(REMEnergyData*)point color:(UIColor*)color name:(NSString*)name direction:(REMDirection)direction
{
    NSLog(@"Pie %@ is now on the niddle.", name);
    
    [self.searchView setHidden:YES];
    
    if(self.tooltipView != nil){
        [self.tooltipView updateHighlightedData:@[point]];
    }
    else{
        [self showTooltip:@[point]];
    }
}

-(void)tooltipWillDisapear
{
    //NSLog(@"tool tip will disappear");
    if(self.tooltipView==nil)
        return;
    
    [self hideTooltip:^{
        id chartView = (id)self.chartWrapper.view;
        if([chartView respondsToSelector:@selector(cancelToolTipStatus)]){
            [chartView cancelToolTipStatus];
        }
        
        [self.searchView setHidden:NO];
    }];
}

-(void)showTooltip:(NSArray *)highlightedData
{
    REMTooltipViewBase *tooltip = [REMTooltipViewBase tooltipWithHighlightedData:highlightedData inEnergyData:self.energyData widget:self.widgetInfo andParameters:self.tempModel];
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
