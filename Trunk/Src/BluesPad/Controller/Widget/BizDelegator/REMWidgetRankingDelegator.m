//
//  REMWidgetRankingDelegator.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 11/5/13.
//
//

#import "REMWidgetRankingDelegator.h"
#import "DCRankingWrapper.h"

const static CGFloat kRankButtonDimension=32;
const static CGFloat kRankingTimePickerWidth=222;

@interface REMWidgetRankingDelegator()

@property (nonatomic,strong) UIPopoverController *datePickerPopoverController;

@property (nonatomic,strong) DCRankingWrapper *chartWrapper;


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
    self.model = [REMWidgetSearchModelBase searchModelByDataStoreType:self.widgetInfo.contentSyntax
                  .dataStoreType withParam:self.widgetInfo.contentSyntax.params];
    self.searcher=[REMEnergySeacherBase querySearcherByType:self.widgetInfo.contentSyntax.dataStoreType withWidgetInfo:self.widgetInfo];
    UIActivityIndicatorView *loader=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loader setColor:[UIColor grayColor]];
    [loader setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8]];
    loader.translatesAutoresizingMaskIntoConstraints=NO;
    self.searcher.loadingView=loader;
    REMWidgetRankingSearchModel *m=(REMWidgetRankingSearchModel *)self.model;
    m.relativeDateType=self.widgetInfo.contentSyntax.relativeDateType;
}


- (void)initSearchView{
    
    UIView *searchViewContainer=[[UIView alloc]initWithFrame:CGRectMake(0,self.ownerController.titleContainer.frame.origin.y+self.ownerController.titleContainer.frame.size.height,kDMChart_ToolbarWidth,kDMChart_ToolbarHeight)];
    //searchViewContainer.translatesAutoresizingMaskIntoConstraints=NO;
    
    [searchViewContainer setBackgroundColor:[REMColor colorByHexString:@"#f4f4f4"]];
    
    UIButton *timePickerButton=[UIButton buttonWithType:UIButtonTypeCustom];
    timePickerButton.layer.borderColor=[UIColor clearColor].CGColor;
    timePickerButton.layer.borderWidth=0;
    timePickerButton.layer.cornerRadius=4;
    timePickerButton.translatesAutoresizingMaskIntoConstraints = NO;
    [timePickerButton setImage:REMIMG_DatePicker_Chart forState:UIControlStateNormal];
    [timePickerButton setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
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
    
    
    NSMutableArray *searchViewSubViewConstraints = [NSMutableArray array];
    NSDictionary *searchViewSubViewDic = NSDictionaryOfVariableBindings(timePickerButton,orderButton);
    NSDictionary *searchViewSubViewMetrics = @{@"margin":@(kWidgetDatePickerLeftMargin),@"buttonHeight":@(kWidgetDatePickerHeight),@"buttonWidth":@(kRankingTimePickerWidth),@"top":@(kWidgetDatePickerTopMargin),@"rankDimension":@(kRankButtonDimension)};
    [searchViewSubViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[timePickerButton(buttonWidth)]" options:0 metrics:searchViewSubViewMetrics views:searchViewSubViewDic]];
    [searchViewSubViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[timePickerButton(buttonHeight)]" options:0 metrics:searchViewSubViewMetrics views:searchViewSubViewDic]];
    
    [searchViewSubViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[orderButton]-margin-|" options:0 metrics:searchViewSubViewMetrics views:searchViewSubViewDic]];
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

- (void)search{
    [self doSearchWithModel:self.model callback:^(REMEnergyViewData *data,REMBusinessErrorInfo *error){
        if(data!=nil){
            [self reloadChart];
        }
        else{
        }
    }];
}


- (void) setDatePickerButtonValueNoSearchByTimeRange:(REMTimeRange *)range withRelative:(NSString *)relativeDate withRelativeType:(REMRelativeTimeRangeType)relativeType
{
    NSString *text=[REMTimeHelper formatTimeRangeFullDay:range];
    
    
    NSString *text1=[NSString stringWithFormat:@"%@ %@",relativeDate,text];
    
    [self.timePickerButton setTitle:text1 forState:UIControlStateNormal];
    REMWidgetRankingSearchModel *rankingModel=(REMWidgetRankingSearchModel *)self.model;
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
    [self.chartWrapper redraw:self.energyData step:REMEnergyStepNone];
}


- (void)showChart{
    [self showEnergyChart];
}

- (void) showEnergyChart{
    if(self.chartWrapper!=nil){
        return;
    }
    
    
    CGRect widgetRect = CGRectMake(0, 0, kWidgetChartWidth, kWidgetChartHeight);
    REMDiagramType widgetType = self.widgetInfo.diagramType;
    
    REMChartStyle* style = [REMChartStyle getMaximizedStyle];
    DCRankingWrapper  *widgetWrapper;
    if (widgetType == REMDiagramTypeRanking) {
        widgetWrapper = [[DCRankingWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax style:style];
    }
    if (widgetWrapper != nil) {
        [self.chartContainer addSubview:widgetWrapper.view];
        self.chartWrapper=widgetWrapper;
        
    }
    
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
        self.chartWrapper=nil;
    }
}

@end
