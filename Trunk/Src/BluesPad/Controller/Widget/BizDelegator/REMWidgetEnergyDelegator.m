//
//  REMWidgetEnergyDelegator.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 11/4/13.
//
//

#import "REMWidgetEnergyDelegator.h"
#import <QuartzCore/QuartzCore.h>
#import "REMDimensions.h"
#import "REMChartSeriesLegend.h"

@interface REMWidgetEnergyDelegator()



@property (nonatomic,strong) UIPopoverController *datePickerPopoverController;

@property (nonatomic,strong) REMAbstractChartWrapper *chartWrapper;

@property (nonatomic,strong) NSArray *currentStepList;

@property (nonatomic,strong) REMWidgetStepEnergyModel *tempModel;

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
    self.tempModel=(REMWidgetStepEnergyModel *)[REMWidgetSearchModelBase searchModelByDataStoreType:self.widgetInfo.contentSyntax
                    .dataStoreType withParam:self.widgetInfo.contentSyntax.params];
}


- (void)initChartView{
    UIView *chartContainer=[[UIView alloc]initWithFrame:CGRectMake(kWidgetChartLeftMargin, kWidgetChartTopMargin, kWidgetChartWidth, kWidgetChartHeight)];
    [self.view addSubview:chartContainer];
    self.chartContainer=chartContainer;
    self.maskerView=self.chartContainer;
    self.chartContainer.layer.borderColor=[UIColor redColor].CGColor;
    self.chartContainer.layer.borderWidth=1;
    //[self showEnergyChart];

    [self setStepControlStatusByStepNoSearch:self.widgetInfo.contentSyntax.stepType];
    [self setDatePickerButtonValueNoSearchByTimeRange:self.widgetInfo.contentSyntax.timeRanges[0] withRelative:self.widgetInfo.contentSyntax.relativeDateComponent withRelativeType:self.widgetInfo.contentSyntax.relativeDateType];
}

- (void) showTimePicker{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UINavigationController *nav=[storyboard instantiateViewControllerWithIdentifier:@"datePickerNavigationController"];
    
    //REMDatePickerViewController *dateViewController=[storyboard instantiateViewControllerWithIdentifier:@"datePickerViewController"];
    
    UIPopoverController *popoverController=[[UIPopoverController alloc]initWithContentViewController:nav];
    REMDatePickerViewController *dateViewController =nav.childViewControllers[0];
    dateViewController.relativeDate=self.tempModel.relativeDateComponent;
    dateViewController.timeRange=self.tempModel.timeRangeArray[0];
    dateViewController.relativeDateType=self.tempModel.relativeDateType;
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
            [list addObject:[NSNumber numberWithInt:3]];
            [list addObject:[NSNumber numberWithInt:5]];
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
    
    [self.stepControl initWithItems:titleList];
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
    
    [self doSearch:^(REMEnergyViewData *data,REMBusinessErrorInfo *error){
        if(data!=nil){
            [self changeTimeRange:newRange];
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

- (void)rollback{
    REMWidgetStepEnergyModel *stepModel=(REMWidgetStepEnergyModel *)self.model;
    [self setStepControlStatusByStepNoSearch:stepModel.step];
    
}

- (void)processStepErrorWithAvailableStep:(NSString *)availableStep{
    if([availableStep isEqualToString:@"Monthly"]==YES){
        
    }
    else if([availableStep isEqualToString:@"Daily"]==YES){
        
    }
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
    self.tempModel.step=step;
    [self doSearch:^(REMEnergyViewData *data,REMBusinessErrorInfo *error){
        if(data!=nil){
            [self changeStep:step];
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
    
    
    [searchViewContainer addSubview:stepControl];
    self.stepControl=stepControl;
    REMTimeRange *timeRange=self.widgetInfo.contentSyntax.timeRanges[0];
    [self initStepButtonWithRange:timeRange WithStep:self.widgetInfo.contentSyntax.stepType];
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
            self.legendView = [self prepareLegendView];
            
            [self.view addSubview:self.legendView];
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.legendView.frame = kDMChart_ToolbarFrame;
            } completion:nil];
        }
        
    }
}

-(UIView *)prepareLegendView
{
    UIView *view = [[UIView alloc] initWithFrame:kDMChart_ToolbarHiddenFrame];
    view.backgroundColor = [UIColor purpleColor];
    
    for(int i=0;i<self.energyData.targetEnergyData.count; i++){
        REMTargetEnergyData *targetData = self.energyData.targetEnergyData[i];
        
        REMChartSeriesLegend *legend = [[REMChartSeriesLegend alloc] initWithSeriesIndex:i type:REMChartSeriesIndicatorLine andName:targetData.target.name];
        
        CGFloat x = i * (kDMChart_LegendItemWidth + kDMChart_LegnetItemOffset);
        CGFloat y = (kDMChart_ToolbarHeight - kDMChart_LegendItemHeight) / 2;
        
        legend.frame = CGRectMake(x, y, kDMChart_LegendItemWidth, kDMChart_LegendItemHeight);
        
        [view addSubview:legend];
    }
    
    
    return view;
}


@end
