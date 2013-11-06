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

@interface REMWidgetEnergyDelegator()

@property (nonatomic,strong) NSMutableArray *currentTimeRangeArray;
@property (nonatomic) REMEnergyStep currentStep;
@property (nonatomic) REMWidgetLegendType currentLegendType;

@property (nonatomic,strong) NSString *currentRelativeDate;
@property (nonatomic) REMRelativeTimeRangeType  currentRelativeDateType;
@property (nonatomic,strong) UIPopoverController *datePickerPopoverController;

@property (nonatomic,strong) REMAbstractChartWrapper *chartWrapper;


@end

@implementation REMWidgetEnergyDelegator

- (void)initBizView{
    
    [self initModelAndSearcher];
    
    [self initSearchView];
    [self initChartView];
}

- (void)initModelAndSearcher{
    self.model = [REMWidgetSearchModelBase searchModelByDataStoreType:self.widgetInfo.contentSyntax
                  .dataStoreType withParam:self.widgetInfo.contentSyntax.params];
    self.searcher=[REMEnergySeacherBase querySearcherByType:self.widgetInfo.contentSyntax.dataStoreType];
}

- (void)initChartView{
    UIView *chartContainer=[[UIView alloc]initWithFrame:CGRectMake(kWidgetChartLeftMargin, kWidgetChartTopMargin, kWidgetChartWidth, kWidgetChartHeight)];
    [self.view addSubview:chartContainer];
    self.chartContainer=chartContainer;
    self.maskerView=self.chartContainer;
    self.chartContainer.layer.borderColor=[UIColor redColor].CGColor;
    self.chartContainer.layer.borderWidth=1;
    //[self showEnergyChart];

    [self setStepControlStatusByStep:self.widgetInfo.contentSyntax.stepType];
    [self setDatePickerButtonValueNoSearchByTimeRange:self.widgetInfo.contentSyntax.timeRanges[0] withRelative:self.widgetInfo.contentSyntax.relativeDateComponent withRelativeType:self.widgetInfo.contentSyntax.relativeDateType];
    
    [self registerTooltopEvent];
}

- (void) showTimePicker{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UINavigationController *nav=[storyboard instantiateViewControllerWithIdentifier:@"datePickerNavigationController"];
    
    //REMDatePickerViewController *dateViewController=[storyboard instantiateViewControllerWithIdentifier:@"datePickerViewController"];
    
    UIPopoverController *popoverController=[[UIPopoverController alloc]initWithContentViewController:nav];
    REMDatePickerViewController *dateViewController =nav.childViewControllers[0];
    dateViewController.relativeDate=self.currentRelativeDate;
    dateViewController.timeRange=self.currentTimeRangeArray[0];
    dateViewController.relativeDateType=self.currentRelativeDateType;
    dateViewController.datePickerProtocol=self;
    dateViewController.popController=popoverController;
    [popoverController setPopoverContentSize:CGSizeMake(400, 500)];
    [popoverController presentPopoverFromRect:self.timePickerButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown|UIPopoverArrowDirectionUp animated:YES];
    self.datePickerPopoverController=popoverController;
    //[self performSegueWithIdentifier:@"timePickerSegue" sender:self];
}


- (void)showChart{
    [self showEnergyChart];
}

- (void) showEnergyChart{
    if(self.chartWrapper!=nil){
        return;
    }
    
    
    CGRect widgetRect = self.chartContainer.bounds;
    REMDiagramType widgetType = self.widgetInfo.diagramType;
    
    NSMutableDictionary* style = [[NSMutableDictionary alloc]init];
    //    self.userInteraction = ([dictionary[@"userInteraction"] isEqualToString:@"YES"]) ? YES : NO;
    //    self.series = dictionary[@"series"];
    CPTMutableLineStyle* gridlineStyle = [[CPTMutableLineStyle alloc]init];
    CPTMutableTextStyle* textStyle = [[CPTMutableTextStyle alloc]init];
    gridlineStyle.lineColor = [CPTColor whiteColor];
    gridlineStyle.lineWidth = 1.0;
    textStyle.fontName = @kBuildingFontSCRegular;
    textStyle.fontSize = 16.0;
    textStyle.color = [CPTColor whiteColor];
    textStyle.textAlignment = CPTTextAlignmentCenter;
    
    [style setObject:@"YES" forKey:@"userInteraction"];
    [style setObject:@(0.05) forKey:@"animationDuration"];
    [style setObject:gridlineStyle forKey:@"xLineStyle"];
    [style setObject:textStyle forKey:@"xTextStyle"];
    //    [style setObject:nil forKey:@"xGridlineStyle"];
    //    [style setObject:nil forKey:@"yLineStyle"];
    [style setObject:textStyle forKey:@"yTextStyle"];
    [style setObject:gridlineStyle forKey:@"yGridlineStyle"];
    [style setObject:@(6) forKey:@"horizentalGridLineAmount"];
    REMAbstractChartWrapper  *widgetWrapper;
    if (widgetType == REMDiagramTypeLine) {
        widgetWrapper = [[REMLineWidgetWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax styleDictionary:style];
    } else if (widgetType == REMDiagramTypeColumn) {
        widgetWrapper = [[REMColumnWidgetWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax styleDictionary:style];
    } else if (widgetType == REMDiagramTypePie) {
        widgetWrapper = [[REMPieChartWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax styleDictionary:style];
    } else if (widgetType == REMDiagramTypeRanking) {
        widgetWrapper = [[REMRankingWidgetWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax styleDictionary:style];
    } else if (widgetType == REMDiagramTypeStackColumn) {
        widgetWrapper = [[REMStackColumnWidgetWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax styleDictionary:style];
    }
    if (widgetWrapper != nil) {
        [self.chartContainer addSubview:widgetWrapper.view];
        self.chartWrapper=widgetWrapper;
    }
    
}

- (void) setDatePickerButtonValueNoSearchByTimeRange:(REMTimeRange *)range withRelative:(NSString *)relativeDate withRelativeType:(REMRelativeTimeRangeType)relativeType
{
    NSString *text=[REMTimeHelper formatTimeRangeFullHour:range];
    
    
    NSString *text1=[NSString stringWithFormat:@"%@ %@",relativeDate,text];
    
    [self.timePickerButton setTitle:text1 forState:UIControlStateNormal];
    
    self.currentRelativeDate=relativeDate;
    self.currentTimeRangeArray[0]=range;
    self.currentRelativeDateType=relativeType;
}

- (void)setNewTimeRange:(REMTimeRange *)newRange withRelativeType:(REMRelativeTimeRangeType)relativeType withRelativeDateComponent:(NSString *)newDateComponent
{
    NSString *text=[REMTimeHelper formatTimeRangeFullHour:newRange];
    
    
    NSString *text1=[NSString stringWithFormat:@"%@ %@",newDateComponent,text];
    
    [self.timePickerButton setTitle:text1 forState:UIControlStateNormal];
    
    self.model.timeRangeArray = @[newRange];
    
    
    [self doSearch:^(REMEnergyViewData *data,REMError *error){
        if(data!=nil){
            self.currentRelativeDate=newDateComponent;
            self.currentTimeRangeArray[0]=newRange;
            self.currentRelativeDateType=relativeType;
            [self reloadChart];
        }
    }];
    
}



- (void)reloadChart{
    [self.chartWrapper.view removeFromSuperview];
    [self.chartWrapper destroyView];
    self.chartWrapper=nil;
    [self showEnergyChart];
}



- (void) setStepControlStatusByStep:(REMEnergyStep)step{
    NSUInteger pressedIndex;
    if (step == REMEnergyStepHour) {
        pressedIndex=0;
    }
    else if(step == REMEnergyStepDay){
        pressedIndex=1;
    }
    else if(step == REMEnergyStepWeek){
        pressedIndex=2;
    }
    else if(step == REMEnergyStepMonth){
        pressedIndex=3;
    }
    else if(step == REMEnergyStepYear){
        pressedIndex=4;
    }
    else{
        pressedIndex=NSNotFound;
    }
    if(pressedIndex!=NSNotFound){
        [self.stepControl setSelectedSegmentIndex:pressedIndex];
    }
    
}


- (void)initSearchView{
    self.currentTimeRangeArray=[[NSMutableArray alloc]initWithCapacity:self.widgetInfo.contentSyntax.timeRanges.count];
    
    UIView *searchViewContainer=[[UIView alloc]initWithFrame:kDMChart_ToolbarFrame];
    
    
    
    UISegmentedControl *legendControl=[[UISegmentedControl alloc] initWithItems:@[@"search",@"legend"]];
    [legendControl setFrame:CGRectMake(800, kLegendSearchSwitcherTop, 200, 30)];
    UIImage *search=[UIImage imageNamed:@"Up"];
    UIImage *legend=[UIImage imageNamed:@"Down"];
    [legendControl setImage:search forSegmentAtIndex:0];
    [legendControl setImage:legend forSegmentAtIndex:1];
    [legendControl setSelectedSegmentIndex:0];
    [legendControl addTarget:self action:@selector(legendSwitchSegmentPressed:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:legendControl];
    self.legendSearchControl=legendControl;
    
    UIButton *timePickerButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [timePickerButton setFrame:CGRectMake(kWidgetDatePickerLeftMargin, 0, kWidgetDatePickerWidth, kWidgetDatePickerHeight)];
    
    [timePickerButton setImage:[UIImage imageNamed:@"Oil_pressed"] forState:UIControlStateNormal];
    [timePickerButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, kWidgetDatePickerWidth-40)];
    [timePickerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [timePickerButton addTarget:self action:@selector(showTimePicker) forControlEvents:UIControlEventTouchUpInside];
    
    
    [searchViewContainer addSubview:timePickerButton];
    
    self.timePickerButton = timePickerButton;
    
    
    UISegmentedControl *stepControl=[[UISegmentedControl alloc] initWithItems:@[@"hour",@"day",@"week",@"month",@"year"]];
    [stepControl setFrame:CGRectMake(700, timePickerButton.frame.origin.y, 5*kWidgetStepSingleButtonWidth, 30)];
    [stepControl setTitle:NSLocalizedString(@"Common_Hour", "") forSegmentAtIndex:0];//小时
    [stepControl setTitle:NSLocalizedString(@"Common_Day", "") forSegmentAtIndex:1];//天
    [stepControl setTitle:NSLocalizedString(@"Common_Week", "") forSegmentAtIndex:2];//周
    [stepControl setTitle:NSLocalizedString(@"Common_Month", "") forSegmentAtIndex:3];//月
    [stepControl setTitle:NSLocalizedString(@"Common_Year", "") forSegmentAtIndex:4];//年
    
    [searchViewContainer addSubview:stepControl];
    self.stepControl=stepControl;
    
    [self.view addSubview:searchViewContainer];
    

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

#pragma mark - Legend bar

-(UIView *)prepareLegendView
{
    CGFloat scrollViewContentWidth = (kDMChart_LegendItemWidth + kDMChart_LegendItemLeftOffset) * self.energyData.targetEnergyData.count + kDMChart_LegendItemLeftOffset;
    
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:kDMChart_ToolbarHiddenFrame];
    view.backgroundColor = [UIColor whiteColor];
    view.contentSize = CGSizeMake(scrollViewContentWidth, kDMChart_ToolbarHeight);
    view.pagingEnabled = NO;
    view.showsHorizontalScrollIndicator = NO;
    view.showsVerticalScrollIndicator = NO;
    
    
    for(int i=0;i<self.energyData.targetEnergyData.count; i++){
        REMTargetEnergyData *targetData = self.energyData.targetEnergyData[i];
        
        REMChartSeriesIndicatorType indicatorType = [REMChartSeriesIndicator indicatorTypeWithDiagramType:self.widgetInfo.diagramType];
        CGFloat x = i * (kDMChart_LegendItemWidth + kDMChart_LegendItemLeftOffset) + kDMChart_LegendItemLeftOffset;
        CGFloat y = (kDMChart_ToolbarHeight - kDMChart_LegendItemHeight) / 2;
        
        REMChartLegendItem *legend = [[REMChartLegendItem alloc] initWithSeriesIndex:i type:indicatorType andName:targetData.target.name];
        legend.frame = CGRectMake(x, y, kDMChart_LegendItemWidth, kDMChart_LegendItemHeight);
        legend.delegate = self;
        
        [view addSubview:legend];
    }
    
    return view;
}

-(void)legendStateChanged:(UIControlState)state onIndex:(int)index
{
    //hide or show the series on index according to state
    NSLog(@"Series %d is going to %@", index, state == UIControlStateNormal?@"show":@"hide");
}

#pragma mark - Tooltip
-(void)registerTooltopEvent
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tooltipEventHandler:) name:kREMChartLongPressNotification object:nil];
}

-(void)unregisterTooltopEvent
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kREMChartLongPressNotification object:nil];
}

-(void)tooltipEventHandler:(NSNotification*)notification {
    NSArray* points = notification.userInfo[@"points"];
    for (NSDictionary* dic in points) {
        UIColor* pointColor = dic[@"color"];
        REMEnergyData* pointData = dic[@"energydata"];
    }
    
    NSLog(@"item count 2: %d", points.count);
}

@end
