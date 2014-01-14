//
//  REMWidgetLabelingDelegator.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 11/5/13.
//
//

#import "REMWidgetLabelingDelegator.h"
#import "REMWidgetLabellingSearchModel.h"
#import "REMColor.h"
#import "REMBuildingConstants.h"
#import "REMWidgetEnergyDelegator.h"
#import "REMWidgetMonthPickerViewController.h"
#import "DCLabelingWrapper.h"
#import "DCLabelingChartView.h"

const static CGFloat kLabellingTimePickerWidth=105;
const static CGFloat kLabellingBenchmarkFontSize=20;

@interface REMWidgetLabelingDelegator()

@property (nonatomic,strong) UIPopoverController *datePickerPopoverController;
@property (nonatomic,weak) UIButton *timePickerButton;
@property (nonatomic,strong) DCLabelingWrapper *chartWrapper;
@property (nonatomic,weak) UIView *chartContainer;
@property (nonatomic,weak) UIView *searchView;
@property (nonatomic,weak) UILabel *benchmarkTextLabel;

@property (nonatomic,weak) REMTooltipViewBase *tooltipView;

@end

@implementation REMWidgetLabelingDelegator



- (void)initBizView{
    [self initSearchView];
    [self initChartView];
    
    REMWidgetLabellingSearchModel *m=(REMWidgetLabellingSearchModel *)self.model;
    [self setDatePickerButtonValueNoSearchByTimeRange:m.timeRangeArray[0] withStep:m.step];
}



- (void)initSearchView{
    
    UIView *searchViewContainer=[[UIView alloc]initWithFrame:CGRectMake(kDMCommon_ContentLeftMargin,self.ownerController.titleContainer.frame.origin.y+self.ownerController.titleContainer.frame.size.height,kDMChart_ToolbarWidth,kDMChart_ToolbarHeight)];
    //searchViewContainer.translatesAutoresizingMaskIntoConstraints=NO;
    
    [searchViewContainer setBackgroundColor:[REMColor colorByHexString:@"#f4f4f4"]];
    
    UIButton *timePickerButton=[UIButton buttonWithType:UIButtonTypeCustom];
    timePickerButton.layer.borderColor=[UIColor clearColor].CGColor;
    timePickerButton.layer.borderWidth=0;
    timePickerButton.layer.cornerRadius=4;
    timePickerButton.translatesAutoresizingMaskIntoConstraints = NO;
    [timePickerButton setImage:REMIMG_DatePicker_Chart forState:UIControlStateNormal];
    [timePickerButton setImageEdgeInsets:UIEdgeInsetsMake(0, -4, 0, 0)];
    timePickerButton.titleLabel.font=[UIFont fontWithName:@(kBuildingFontSCRegular) size:kWidgetDatePickerTitleSize];
    
    [timePickerButton setTitleColor:[REMColor colorByHexString:@"#5e5e5e"] forState:UIControlStateNormal];
    
    [timePickerButton addTarget:self action:@selector(showTimePicker) forControlEvents:UIControlEventTouchUpInside];
    [timePickerButton addTarget:self action:@selector(timePickerPressDown) forControlEvents:UIControlEventTouchDown];
    
    
    [searchViewContainer addSubview:timePickerButton];
    
    self.timePickerButton = timePickerButton;
    
    
    [self.view addSubview:searchViewContainer];
    self.searchView=searchViewContainer;
    
//    UILabel *benchmarkLabel=[[UILabel alloc]init];
//    REMWidgetLabellingSearchModel *labellingModel=(REMWidgetLabellingSearchModel *)self.model;
//    benchmarkLabel.font=[UIFont fontWithName:@(kBuildingFontSC) size:kLabellingBenchmarkFontSize];
//    benchmarkLabel.text=labellingModel.benchmarkText;
//    benchmarkLabel.translatesAutoresizingMaskIntoConstraints=NO;
//    [benchmarkLabel setBackgroundColor:[UIColor clearColor]];
//    [benchmarkLabel setTextColor:[REMColor colorByHexString:@"#5e5e5e"]];
//    [searchViewContainer addSubview:benchmarkLabel];
//    
//    self.benchmarkTextLabel=benchmarkLabel;
    
    
    NSMutableArray *searchViewSubViewConstraints = [NSMutableArray array];
    NSDictionary *searchViewSubViewDic = NSDictionaryOfVariableBindings(timePickerButton/*,benchmarkLabel*/);
    NSDictionary *searchViewSubViewMetrics = @{@"margin":@(kWidgetDatePickerLeftMargin),@"buttonHeight":@(kWidgetDatePickerHeight),@"buttonWidth":@(kLabellingTimePickerWidth),@"top":@(kWidgetDatePickerTopMargin),@"labelMargin":@(kWidgetDatePickerLeftMargin*2),@"benchmarkHeight":@(kLabellingBenchmarkFontSize+2)};
    [searchViewSubViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[timePickerButton(buttonWidth)]" options:0 metrics:searchViewSubViewMetrics views:searchViewSubViewDic]];
//    [searchViewSubViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[timePickerButton(buttonWidth)]-labelMargin-[benchmarkLabel]" options:0 metrics:searchViewSubViewMetrics views:searchViewSubViewDic]];
    [searchViewSubViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[timePickerButton(buttonHeight)]" options:0 metrics:searchViewSubViewMetrics views:searchViewSubViewDic]];
//    [searchViewSubViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[benchmarkLabel(benchmarkHeight)]" options:0 metrics:searchViewSubViewMetrics views:searchViewSubViewDic]];
    
    [searchViewContainer addConstraints:searchViewSubViewConstraints];
    
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

- (void)reloadChart{
    if(self.chartWrapper == nil){
        [self showEnergyChart];
    }
    else{
        [self.chartWrapper redraw:self.energyData];
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

- (void) showEnergyChart{
    if(self.chartWrapper!=nil){
        return;
    }
    
    
    CGRect widgetRect = CGRectMake(0, 0, kWidgetChartWidth, kWidgetChartHeight);
    REMDiagramType widgetType = self.widgetInfo.diagramType;
    
    REMChartStyle* style = [REMChartStyle getMaximizedStyle];
    DCLabelingWrapper  *widgetWrapper;
    DWrapperConfig* wrapperConfig = [[DWrapperConfig alloc]init];
    
    if ([self.model isKindOfClass:[REMWidgetStepEnergyModel class]]==YES) {
        REMWidgetStepEnergyModel *stepModel=(REMWidgetStepEnergyModel *)self.model;
        wrapperConfig.stacked=NO;
        wrapperConfig.benckmarkText=stepModel.benchmarkText;
    }
    if (widgetType == REMDiagramTypeLabelling) {
        widgetWrapper = [[DCLabelingWrapper alloc]initWithFrame:widgetRect data:self.energyData wrapperConfig:wrapperConfig style:style];
        widgetWrapper.delegate = self;
    }
    if (widgetWrapper != nil) {
        [self.chartContainer addSubview:[widgetWrapper getView]];
        self.chartWrapper=widgetWrapper;
        
    }
    
}

- (void)search{
    [self searchData:self.model];
}

- (void) setDatePickerButtonValueNoSearchByTimeRange:(REMTimeRange *)range withStep:(REMEnergyStep)step
{
    NSString *text=[REMTimeHelper formatTimeFullMonth:range.startTime];
    if (step == REMEnergyStepYear) {
        text=[REMTimeHelper formatTimeFullYear:range.startTime];
    }
    [self.timePickerButton setTitle:text forState:UIControlStateNormal];
    REMWidgetLabellingSearchModel *labellingModel=(REMWidgetLabellingSearchModel *)self.model;
    [labellingModel setTimeRangeItem:range AtIndex:0];
    
    labellingModel.step=step;
    
}
- (void)timePickerPressDown{
    [self.timePickerButton setBackgroundColor:[REMColor colorByHexString:@"#ebebeb"]];
}

- (void) showTimePicker{
    [self.timePickerButton setBackgroundColor:[UIColor clearColor]];
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    UINavigationController *nav=[storyboard instantiateViewControllerWithIdentifier:@"monthPickerNavigationController"];
    
   
    UIPopoverController *popoverController=[[UIPopoverController alloc]initWithContentViewController:nav];
    REMWidgetMonthPickerViewController *dateViewController=nav.childViewControllers[0];
    dateViewController.popSize=CGSizeMake(300, 250);

    REMWidgetLabellingSearchModel *labellingModel=(REMWidgetLabellingSearchModel *)self.model;
    
    dateViewController.timeRange=labellingModel.timeRangeArray[0];
    dateViewController.step=labellingModel.step;
    dateViewController.popController=popoverController;
    dateViewController.datePickerProtocol=self;
    [popoverController setPopoverContentSize:dateViewController.popSize];
    CGRect rect= CGRectMake(self.timePickerButton.frame.origin.x, self.searchView.frame.origin.y+self.timePickerButton.frame.origin.y, self.timePickerButton.frame.size.width, self.timePickerButton.frame.size.height);
    [popoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown|UIPopoverArrowDirectionUp animated:YES];
    
    self.datePickerPopoverController=popoverController;
}

- (void)setNewDate:(NSDate *)date withStep:(REMEnergyStep)step
{
    NSDate *end=[REMTimeHelper add:1 onPart:REMDateTimePartDay ofDate:date];
    REMTimeRange *range=[[REMTimeRange alloc]initWithStartTime:date EndTime:end];
    
    [self setDatePickerButtonValueNoSearchByTimeRange:range withStep:step];
    
    [self search];
}


- (void)releaseChart{
    if(self.chartWrapper!=nil){
        [[self.chartWrapper getView] removeFromSuperview];
        self.chartWrapper=nil;
    }
}

#pragma mark Tooltip
-(void)highlightPoint:(DCLabelingLabel*)point
{
    NSDate *x = [self.tempModel.searchTimeRangeArray[0] startTime];
    if(self.tooltipView != nil){
        REMTrendChartTooltipView *trendTooltip = (REMTrendChartTooltipView *)self.tooltipView;
        
        [trendTooltip updateHighlightedData:@[point] atX:x];
    }
    else{
        [self showTooltip:@[point] forX:x];
    }
    
}


-(void)tooltipWillDisapear
{
    //NSLog(@"tool tip will disappear");
    if(self.tooltipView==nil)
        return;
    
    [self hideTooltip:^{
        [self.chartWrapper cancelToolTipStatus];
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
