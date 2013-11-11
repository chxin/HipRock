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

@interface REMWidgetEnergyDelegator()



@property (nonatomic,strong) UIPopoverController *datePickerPopoverController;

@property (nonatomic,strong) REMAbstractChartWrapper *chartWrapper;

@property (nonatomic,strong) NSArray *currentStepList;
@property (nonatomic,weak) REMTooltipViewBase *tooltipView;

@property (nonatomic,strong) REMWidgetStepEnergyModel *tempModel;

@property (nonatomic,strong) NSArray *supportStepArray;


@end

@implementation REMWidgetEnergyDelegator

- (void)initBizView{
    
    [self initModelAndSearcher];
    
    [self initSearchView];
    [self initChartView];
    
    //TODO:Temp code, remove when tooltip delegate is ok
    //[self.view addSubview:[self prepareTooltipView]];
}

- (void)initModelAndSearcher{
    self.model = [REMWidgetSearchModelBase searchModelByDataStoreType:self.widgetInfo.contentSyntax
                  .dataStoreType withParam:self.widgetInfo.contentSyntax.params];
    self.searcher=[REMEnergySeacherBase querySearcherByType:self.widgetInfo.contentSyntax.dataStoreType withWidgetInfo:self.widgetInfo];
    self.tempModel=(REMWidgetStepEnergyModel *)[REMWidgetSearchModelBase searchModelByDataStoreType:self.widgetInfo.contentSyntax
                    .dataStoreType withParam:self.widgetInfo.contentSyntax.params];
}


- (void)initChartView{
    UIView *c=[[UIView alloc]initWithFrame:CGRectMake(0, kWidgetChartTopMargin, 1024, kWidgetChartHeight)];
    [c setBackgroundColor:[REMColor colorByHexString:@"#f4f4f4"]];
    UIView *chartContainer=[[UIView alloc]initWithFrame:CGRectMake(kWidgetChartLeftMargin, 0, kWidgetChartWidth, kWidgetChartHeight)];
    [chartContainer setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:c];
    [c addSubview:chartContainer];
    self.chartContainer=chartContainer;
    self.maskerView=self.chartContainer;
    //self.chartContainer.layer.borderColor=[UIColor redColor].CGColor;
    //self.chartContainer.layer.borderWidth=1;
    //[self showEnergyChart];

    [self setStepControlStatusByStepNoSearch:self.widgetInfo.contentSyntax.stepType];
    
    
    
    [self setDatePickerButtonValueNoSearchByTimeRange:self.widgetInfo.contentSyntax.timeRanges[0] withRelative:self.widgetInfo.contentSyntax.relativeDateComponent withRelativeType:self.widgetInfo.contentSyntax.relativeDateType];
}

- (void) showTimePicker{
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

- (void) showEnergyChart{
    if(self.chartWrapper!=nil){
        return;
    }
    
    
    CGRect widgetRect = self.chartContainer.bounds;
    REMDiagramType widgetType = self.widgetInfo.diagramType;
    
    REMChartStyle* style = [REMChartStyle getMaximizedStyle];
    REMAbstractChartWrapper  *widgetWrapper;
    if (widgetType == REMDiagramTypeLine) {
        widgetWrapper = [[REMLineWidgetWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax style:style];
        ((REMTrendChartView *)widgetWrapper.view).delegate = self;
    } else if (widgetType == REMDiagramTypeColumn) {
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
        [self.chartContainer addSubview:widgetWrapper.view];
        self.chartWrapper=widgetWrapper;
    }
    
}



- (void) setDatePickerButtonValueNoSearchByTimeRange:(REMTimeRange *)range withRelative:(NSString *)relativeDate withRelativeType:(REMRelativeTimeRangeType)relativeType
{
    NSString *text=[REMTimeHelper formatTimeRangeFullHour:range];
    
    
    NSString *text1=[NSString stringWithFormat:@"%@ %@",relativeDate,text];
    
    [self.timePickerButton setTitle:text1 forState:UIControlStateNormal];
    
    self.tempModel.relativeDateComponent=relativeDate;
    [self.tempModel setTimeRangeItem:range AtIndex:0];
    self.tempModel.relativeDateType=relativeType;
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
    
    switch (i) {
        case 0:
            [list addObject:[NSNumber numberWithInt:1]];
            [titleList addObject: NSLocalizedString(@"Common_Hour", "")];//小时
            break;
        case 1:
            [list addObject:[NSNumber numberWithInt:1]];
            [list addObject:[NSNumber numberWithInt:2]];
            [titleList addObject:NSLocalizedString(@"Common_Hour", "")];//小时
            [titleList addObject:NSLocalizedString(@"Common_Day", "")];//天
            break;
        case 2:
            [list addObject:[NSNumber numberWithInt:2]];
            [list addObject:[NSNumber numberWithInt:5]];
            [titleList addObject:NSLocalizedString(@"Common_Day", "")];//天
            [titleList addObject:NSLocalizedString(@"Common_Week", "")];//周
            break;
        case 3:
            [list addObject:[NSNumber numberWithInt:2]];
            [list addObject:[NSNumber numberWithInt:5]];
            [list addObject:[NSNumber numberWithInt:3]];
            [titleList addObject:NSLocalizedString(@"Common_Day", "")];//天
            [titleList addObject:NSLocalizedString(@"Common_Week", "")];//周
            [titleList addObject:NSLocalizedString(@"Common_Month", "")];//月
            break;
        case 4:
            [list addObject:[NSNumber numberWithInt:3]];
            [titleList addObject:NSLocalizedString(@"Common_Month", "")];//月
            break;
        case 5:
            [list addObject:[NSNumber numberWithInt:3]];
            [list addObject:[NSNumber numberWithInt:4]];
            [titleList addObject:NSLocalizedString(@"Common_Month", "")];//月
            [titleList addObject:NSLocalizedString(@"Common_Year", "")];//年
            break;
        case 6:
            [list addObject:[NSNumber numberWithInt:3]];
            [list addObject:[NSNumber numberWithInt:4]];
            [titleList addObject:NSLocalizedString(@"Common_Month", "")];//月
            [titleList addObject:NSLocalizedString(@"Common_Year", "")];//年
        default:
            break;
    }
    
    
    self.currentStepList=list;
    [self.stepControl removeAllSegments];
    
    UISegmentedControl *control= [[UISegmentedControl alloc] initWithItems:titleList];
    
    CGFloat x=1024-kWidgetChartLeftMargin*2-list.count*kWidgetStepSingleButtonWidth;
    
    CGRect frame= CGRectMake(x, self.timePickerButton.frame.origin.y, list.count*kWidgetStepSingleButtonWidth, kWidgetStepButtonHeight);
    
    UIFont *font = [UIFont fontWithName:@(kBuildingFontSCRegular) size:14];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:UITextAttributeFont];
    [control setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    
    
    
    [control setFrame:frame];
    [self.stepControl removeFromSuperview];
    [self.searchView addSubview:control];
    self.stepControl=control;
    [self.stepControl addTarget:self action:@selector(stepChanged:) forControlEvents:UIControlEventValueChanged];
    NSNumber *newStep = [NSNumber numberWithInt:((int)step)];
    NSUInteger idx;
    if([list containsObject:newStep] == YES)
    {
        idx= [list indexOfObject:newStep];
    }
    else
    {
        newStep = list[0];
        idx =  0;
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
    NSString *text=[REMTimeHelper formatTimeRangeFullHour:newRange];
    
    
    NSString *text1=[NSString stringWithFormat:@"%@ %@",newDateComponent,text];
    
    [self.timePickerButton setTitle:text1 forState:UIControlStateNormal];
    
    [self changeTimeRange:newRange];
    
    REMEnergyStep newStep= [self initStepButtonWithRange:newRange WithStep:self.tempModel.step];
    
    
    
    [self changeStep:newStep];
    
    [self search];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

- (void)rollback{
    REMWidgetStepEnergyModel *stepModel=(REMWidgetStepEnergyModel *)self.model;
    [self setStepControlStatusByStepNoSearch:stepModel.step];
    [self setDatePickerButtonValueNoSearchByTimeRange:stepModel.timeRangeArray[0] withRelative:stepModel.relativeDateComponent withRelativeType:stepModel.relativeDateType];
    
}

- (void)processStepErrorWithAvailableStep:(NSString *)availableStep{
    NSArray *buttonArray;
    NSArray *supportStep;
    if([availableStep isEqualToString:@"Monthly"]==YES){
        buttonArray=@[NSLocalizedString(@"Common_Month", @""),NSLocalizedString(@"Common_Year", @"")];
        supportStep =@[@(REMEnergyStepMonth),@(REMEnergyStepYear)];
    }
    else if([availableStep isEqualToString:@"Daily"]==YES){
        buttonArray=@[NSLocalizedString(@"Common_Daily", @""),NSLocalizedString(@"Common_Week", @""),NSLocalizedString(@"Common_Month", @"")];
        supportStep =@[@(REMEnergyStepDay),@(REMEnergyStepWeek),@(REMEnergyStepMonth)];
    }
    else if([availableStep isEqualToString:@"Weekly"]==YES){
        buttonArray=@[NSLocalizedString(@"Common_Week", @""),NSLocalizedString(@"Common_Month", @""),NSLocalizedString(@"Common_Year", @"")];
        supportStep =@[@(REMEnergyStepWeek),@(REMEnergyStepMonth),@(REMEnergyStepYear)];
    }
    else if([availableStep isEqualToString:@"Yearly"]==YES){
        buttonArray=@[NSLocalizedString(@"Common_Year", @"")];
        supportStep =@[@(REMEnergyStepYear)];
    }
    else if([availableStep isEqualToString:@"Hourly"]==YES){
        buttonArray=@[NSLocalizedString(@"Common_Hour", @""),NSLocalizedString(@"Common_Daily", @""),NSLocalizedString(@"Common_Week", @"")];
        supportStep =@[@(REMEnergyStepHour),@(REMEnergyStepDay),@(REMEnergyStepWeek)];
    }
    else{
        buttonArray=@[];
    }
    self.supportStepArray=supportStep;
    UIAlertView *alert= [[UIAlertView alloc]init];
    alert.title=@"";
    for (int i=0; i<buttonArray.count; ++i) {
        [alert addButtonWithTitle:buttonArray[i]];
        
    }
    
    [alert addButtonWithTitle:NSLocalizedString(@"Common_Cancel", @"")];
    
    alert.cancelButtonIndex=buttonArray.count;
    alert.message=NSLocalizedString(@"Widget_StepError", @"");
    
    [alert show];
    
}

- (void)changeTimeRange:(REMTimeRange *)newRange{
   [self.tempModel setTimeRangeItem:newRange AtIndex:0];
}

- (void)changeStep:(REMEnergyStep)newStep{
    self.tempModel.step=newStep;
}


- (void)reloadChart{
    [self.chartWrapper.view removeFromSuperview];
    [self.chartWrapper destroyView];
    self.chartWrapper=nil;
    [self showEnergyChart];
}

- (void)setStepControlStatusByStepNoSearch:(REMEnergyStep)step{
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



- (void) setStepControlStatusByStep:(REMEnergyStep)step{
    [self setStepControlStatusByStepNoSearch:step];
    [self changeStep:step];
    
    [self search];
}

- (void)search{
    [self doSearchWithModel:self.tempModel callback:^(REMEnergyViewData *data,REMBusinessErrorInfo *error){
        if(data!=nil){
            [self reloadChart];
            [self copyTempModel];
        }
        else{
            if([error.code isEqualToString:@"990001202004"]==YES){ //step error
                [self processStepErrorWithAvailableStep:error.messages[0]];
            }
        }
    }];
}



- (void)initSearchView{
    
    UIView *searchViewContainer=[[UIView alloc]initWithFrame:kDMChart_ToolbarFrame];
    
    [searchViewContainer setBackgroundColor:[REMColor colorByHexString:@"#f4f4f4"]];
    
    UISegmentedControl *legendControl=[[UISegmentedControl alloc] initWithItems:@[@"search",@"legend"]];
    [legendControl setFrame:CGRectMake(kLegendSearchSwitcherLeft, kLegendSearchSwitcherTop, kLegendSearchSwitcherWidth, kLegendSearchSwitcherHeight)];
    [legendControl setSegmentedControlStyle:UISegmentedControlStylePlain];

    UIImage *search=[UIImage imageNamed:@"Up"];
    UIImage *legend=[UIImage imageNamed:@"Down"];
    [legendControl setImage:search forSegmentAtIndex:0];
    [legendControl setImage:legend forSegmentAtIndex:1];
    //[legendControl setBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //[legendControl setBackgroundColor:[UIColor clearColor]];
    [legendControl setSelectedSegmentIndex:0];
    [legendControl addTarget:self action:@selector(legendSwitchSegmentPressed:) forControlEvents:UIControlEventValueChanged];
    
    
    [self.view addSubview:legendControl];
    self.legendSearchControl=legendControl;

    
    UIButton *timePickerButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [timePickerButton setFrame:CGRectMake(kWidgetDatePickerLeftMargin, kWidgetDatePickerTopMargin, kWidgetDatePickerWidth, kWidgetDatePickerHeight)];
    timePickerButton.layer.borderColor=[UIColor clearColor].CGColor;
    timePickerButton.layer.borderWidth=0;
    [timePickerButton setBackgroundColor:[REMColor colorByHexString:@"#9d9d9d"]];
    timePickerButton.layer.cornerRadius=4;
    
    [timePickerButton setImage:[UIImage imageNamed:@"Oil_pressed"] forState:UIControlStateNormal];
    [timePickerButton setImageEdgeInsets:UIEdgeInsetsMake(8, 5, 8, kWidgetDatePickerWidth-40)];
    timePickerButton.titleLabel.font=[UIFont fontWithName:@(kBuildingFontSCRegular) size:kWidgetDatePickerTitleSize];
    [timePickerButton setTitleColor:[REMColor colorByHexString:@"#5e5e5e"] forState:UIControlStateNormal];
    
    [timePickerButton addTarget:self action:@selector(showTimePicker) forControlEvents:UIControlEventTouchUpInside];
    
    
    [searchViewContainer addSubview:timePickerButton];
    
    self.timePickerButton = timePickerButton;
    
    [self.view addSubview:searchViewContainer];
    
    self.searchView=searchViewContainer;
    
    UISegmentedControl *stepControl=[[UISegmentedControl alloc] initWithItems:@[@"hour",@"day",@"week",@"month",@"year"]];
    
    [searchViewContainer addSubview:stepControl];
    self.stepControl=stepControl;
     [self.stepControl addTarget:self action:@selector(stepChanged:) forControlEvents:UIControlEventValueChanged];
    REMTimeRange *timeRange=self.tempModel.timeRangeArray[0];
    REMEnergyStep step = [self initStepButtonWithRange:timeRange WithStep:self.widgetInfo.contentSyntax.stepType];
    
    
    
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
    //NSLog(@"Series %d is going to %@", index, state == UIControlStateNormal?@"show":@"hide");
    
    if([self.chartWrapper.view isKindOfClass:[REMTrendChartView class]]){
        [((REMTrendChartView *)self.chartWrapper.view) setSeriesHiddenAtIndex:index hidden:(state != UIControlStateNormal)];
    }
}

#pragma mark - Tooltip
// Trend chart delegate
-(void)highlightPoints:(NSArray*)points colors:(NSArray*)colors names:(NSArray*)names
{
    if(self.widgetInfo.diagramType == REMDiagramTypeStackColumn){
        return;
    }
    
    NSMutableArray *models = [[NSMutableArray alloc] init];
    for(int i=0;i<names.count;i++){
        REMChartTooltipItemModel *model = [[REMChartTooltipItemModel alloc] init];
        model.title = names[i];
        model.value = REMIsNilOrNull(points[i]) ? nil : [points[i] dataValue];
        model.color = colors[i];
        model.index = i;
        model.type = [REMChartSeriesIndicator indicatorTypeWithDiagramType: self.widgetInfo.diagramType];
        
        [models addObject:model];
    }
    
    if(self.tooltipView!=nil){
        [self.tooltipView update:models];
    }
    else{
        [self showTooltip:models:0];
    }
}

// Pie chart delegate
-(void)highlightPoint:(REMEnergyData*)point color:(UIColor*)color name:(NSString*)name
{
    NSLog(@"Pie %@ is now on the niddle.", name);
    
    NSMutableArray *models = [[NSMutableArray alloc] init];
    int highlightIndex=0;
    
    for(int i=0;i<self.energyData.targetEnergyData.count;i++){
        REMTargetEnergyData *targetData = self.energyData.targetEnergyData[i];
        if([targetData.target.name isEqualToString:name]){
            highlightIndex = i;
        }
        
        REMChartTooltipItemModel *model = [[REMChartTooltipItemModel alloc] init];
        model.title = targetData.target.name;
        model.value = REMIsNilOrNull(targetData.energyData[0]) ? nil : [targetData.energyData[0] dataValue];
        model.color = [REMColor colorByIndex:i].uiColor;
        model.index = i;
        model.type = [REMChartSeriesIndicator indicatorTypeWithDiagramType: self.widgetInfo.diagramType];
        
        [models addObject:model];
    }
    
    if(self.tooltipView != nil){
        [self.tooltipView update:@(highlightIndex)];
    }
    else{
        [self showTooltip:models:highlightIndex];
    }
}

-(void)tooltipWillDisapear
{
    NSLog(@"tool tip will disappear");
    if(self.tooltipView==nil)
        return;
    
    [self hideTooltip:^{
        id chartView = (id)self.chartWrapper.view;
        if([chartView respondsToSelector:@selector(cancelToolTipStatus)]){
            [chartView cancelToolTipStatus];
        }
    }];
}

-(void)showTooltip:(NSArray *)data :(int)highlightIndex
{
    REMTooltipViewBase *tooltip;
    switch (self.widgetInfo.diagramType) {
        case REMDiagramTypePie:
            tooltip = [[REMPieChartTooltipView alloc] initWithFrame:kDMChart_TooltipHiddenFrame data:data andHighlightIndex:highlightIndex];
            tooltip.tooltipDelegate = self;
            break;
            
        default:
            tooltip = [[REMTrendChartTooltipView alloc] initWithFrame:kDMChart_TooltipHiddenFrame andData:data];
            tooltip.tooltipDelegate = self;
            
            break;
    }
    
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
