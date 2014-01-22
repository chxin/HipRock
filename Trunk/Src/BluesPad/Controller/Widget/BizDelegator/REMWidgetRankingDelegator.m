//
//  REMWidgetRankingDelegator.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 11/5/13.
//
//

#import "REMWidgetRankingDelegator.h"
#import "DCRankingWrapper.h"
#import "REMRankingTooltipView.h"

const static CGFloat kRankButtonDimension=32;
const static CGFloat kRankingTimePickerWidth=250;

@interface REMWidgetRankingDelegator()

@property (nonatomic,strong) UIPopoverController *datePickerPopoverController;

@property (nonatomic,strong) DCRankingWrapper *chartWrapper;

@property (nonatomic,weak) REMTooltipViewBase *tooltipView;

@end

@implementation REMWidgetRankingDelegator


- (void)initBizView{
    //monthPickerViewController
    [self initModelAndSearcher];
    [self initSearchView];
    [self initChartView];
    
    REMWidgetRankingSearchModel *m=(REMWidgetRankingSearchModel *)self.model;
    [self setDatePickerButtonValueNoSearchByTimeRange:m.timeRangeArray[0] withRelative:m.relativeDateComponent withRelativeType:m.relativeDateType];
}

- (void)initModelAndSearcher{
    REMWidgetRankingSearchModel *m=(REMWidgetRankingSearchModel *)self.model;
    m.relativeDateType=self.widgetInfo.contentSyntax.relativeDateType;
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
    
    UIButton *orderButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //[orderButton setFrame:CGRectMake(900, 0, 32, 32)];
    orderButton.translatesAutoresizingMaskIntoConstraints=NO;
    [orderButton setImage:REMIMG_Ascend forState:UIControlStateNormal];
    orderButton.showsTouchWhenHighlighted=YES;
    orderButton.adjustsImageWhenHighlighted=YES;
    [orderButton setImage:REMIMG_Descend forState:UIControlStateSelected];
    [orderButton addTarget:self action:@selector(orderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchView addSubview:orderButton];
    
    self.orderButton=orderButton;
    
    if(self.widgetInfo.contentSyntax.rankingSortOrder == NSOrderedDescending){
        [orderButton setSelected:YES];
    }
    
    
    NSMutableArray *searchViewSubViewConstraints = [NSMutableArray array];
    NSDictionary *searchViewSubViewDic = NSDictionaryOfVariableBindings(timePickerButton,orderButton);
    NSDictionary *searchViewSubViewMetrics = @{@"margin":@(kWidgetDatePickerLeftMargin),@"buttonHeight":@(kWidgetDatePickerHeight),@"buttonWidth":@(kRankingTimePickerWidth),@"top":@(kWidgetDatePickerTopMargin),@"rankDimension":@(kRankButtonDimension)};
    [searchViewSubViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[timePickerButton(buttonWidth)]" options:0 metrics:searchViewSubViewMetrics views:searchViewSubViewDic]];
    [searchViewSubViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[timePickerButton(buttonHeight)]" options:0 metrics:searchViewSubViewMetrics views:searchViewSubViewDic]];
    
    [searchViewSubViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[orderButton]-0-|" options:0 metrics:searchViewSubViewMetrics views:searchViewSubViewDic]];
    [searchViewSubViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[orderButton(rankDimension)]" options:0 metrics:searchViewSubViewMetrics views:searchViewSubViewDic]];
    
    [searchViewContainer addConstraints:searchViewSubViewConstraints];
    
}

- (void) orderButtonClicked:(UIButton *)button{
//    REMRankingWidgetWrapper *rank=(REMRankingWidgetWrapper *)self.chartWrapper;
    if(button.selected==YES){
        [button setSelected:NO];
        self.chartWrapper.sortOrder=NSOrderedAscending;
    }
    else{
        [button setSelected:YES];
        self.chartWrapper.sortOrder=NSOrderedDescending;
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
    
    NSMutableArray *chartConstraints = [NSMutableArray array];
    UIView *searchView=self.searchView;
    NSDictionary *dic = NSDictionaryOfVariableBindings(chartContainer,searchView);
    NSDictionary *metrics = @{@"margin":@(kWidgetChartLeftMargin),@"height":@(kWidgetChartHeight),@"width":@(kWidgetChartWidth),@"top":@(0)};
    [chartConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[chartContainer(width)]-margin-|" options:0 metrics:metrics views:dic]];
    [chartConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[searchView]-top-[chartContainer]-margin-|" options:0 metrics:metrics views:dic]];
    
    
    [self.view addConstraints:chartConstraints];

    
    
}

- (CGFloat)xPositionForPinToBuildingCoverButton
{
    return 970;
}

- (void)search{
    
    [self searchData:self.tempModel];
}


- (void) setDatePickerButtonValueNoSearchByTimeRange:(REMTimeRange *)range withRelative:(NSString *)relativeDate withRelativeType:(REMRelativeTimeRangeType)relativeType
{
    NSString *text=[REMTimeHelper formatTimeRangeFullDay:range];
    
    
    NSString *text1=[NSString stringWithFormat:@"%@ %@",relativeDate,text];
    
    [self.timePickerButton setTitle:text1 forState:UIControlStateNormal];
    REMWidgetRankingSearchModel *rankingModel=(REMWidgetRankingSearchModel *)self.tempModel;
    [rankingModel setTimeRangeItem:range AtIndex:0];
    rankingModel.relativeDateComponent=relativeDate;
    rankingModel.relativeDateType=relativeType;
}

- (void)setNewTimeRange:(REMTimeRange *)newRange withRelativeType:(REMRelativeTimeRangeType)relativeType withRelativeDateComponent:(NSString *)newDateComponent
{
    [self setDatePickerButtonValueNoSearchByTimeRange:newRange withRelative:newDateComponent withRelativeType:relativeType];
    
    
    [self search];
    
}

- (void)reloadChart{
    if(self.chartWrapper == nil){
        [self showEnergyChart];
    }
    else{
        [self.chartWrapper redraw:self.energyData step:REMEnergyStepNone];
    }
}


- (void)showChart{
    [super showChart];
    if(self.energyData!=nil){
        [self showEnergyChart];
    }
    else{
        if (self.ownerController.serverError == nil && self.ownerController.isServerTimeout==NO) {
            [self search];
        }
        
    }
}

- (void) showEnergyChart{
    if(self.chartWrapper!=nil){
        return;
    }
    
    
    CGRect widgetRect = CGRectMake(0, 0, kWidgetChartWidth, kWidgetChartHeight);
    REMDiagramType widgetType = self.widgetInfo.diagramType;
    
    REMChartStyle* style = [REMChartStyle getMaximizedStyle];
    DCRankingWrapper  *widgetWrapper;
    DWrapperConfig* wrapperConfig = [[DWrapperConfig alloc]initWith:self.widgetInfo];
//    wrapperConfig.multiTimeSpans=self.model.timeRangeArray;

    if (widgetType == REMDiagramTypeRanking) {
        widgetWrapper = [[DCRankingWrapper alloc]initWithFrame:widgetRect data:self.energyData wrapperConfig:wrapperConfig style:style];
    }
    if (widgetWrapper != nil) {
        [self.chartContainer addSubview:widgetWrapper.view];
        self.chartWrapper=widgetWrapper;
        widgetWrapper.delegate = self;
        
    }
    
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
    REMDatePickerViewController *dateViewController =nav.childViewControllers[0];
    dateViewController.showHour=NO;
    REMWidgetRankingSearchModel *rankModel=(REMWidgetRankingSearchModel *)self.model;
    
    dateViewController.relativeDate=rankModel.relativeDateComponent;
    dateViewController.timeRange=rankModel.timeRangeArray[0];
    dateViewController.relativeDateType=rankModel.relativeDateType;
    dateViewController.datePickerProtocol=self;
    dateViewController.popController=popoverController;
    [popoverController setPopoverContentSize:CGSizeMake(400, 500)];
    CGRect rect= CGRectMake(self.timePickerButton.frame.origin.x, self.searchView.frame.origin.y+self.timePickerButton.frame.origin.y, self.timePickerButton.frame.size.width, self.timePickerButton.frame.size.height);
    [popoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown|UIPopoverArrowDirectionUp animated:YES];
    
    self.datePickerPopoverController=popoverController;
}

- (void)releaseChart{
    if(self.chartWrapper!=nil){
//        [self.chartWrapper destroyView];
        [[self.chartWrapper getView] removeFromSuperview];
        self.chartWrapper=nil;
    }
}


#pragma mark - Tooltip
// Trend chart delegate
-(void)highlightPoints:(NSArray*)points x:(id)x
{
    [self.searchView setHidden:YES];
    
    if(self.tooltipView!=nil){
        REMTrendChartTooltipView *trendTooltip = (REMTrendChartTooltipView *)self.tooltipView;
        
        [trendTooltip updateHighlightedData:points atX:x];
    }
    else{
        [self showTooltip:points];
    }
}

-(void)showTooltip:(NSArray *)highlightedData
{
    REMRankingTooltipView *tooltip = [[REMRankingTooltipView alloc] initWithHighlightedPoints:highlightedData inSerieses:self.chartWrapper.view.seriesList widget:self.widgetInfo andParameters:nil];
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

-(void)tooltipWillDisapear
{
    //NSLog(@"tool tip will disappear");
    if(self.tooltipView==nil)
        return;
    
    [self.chartWrapper cancelToolTipStatus];
    
    [self.searchView setHidden:NO];
    
    [self hideTooltip:^{
    }];
}

@end
