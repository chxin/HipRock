/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetCellViewController.m
 * Created      : tantan on 10/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMWidgetCellViewController.h"
#import "REMBuildingViewController.h"
#import "REMEnergySeacherBase.h"
#import "REMWidgetCollectionViewController.h"
#import "REMWidgetSearchModelBase.h"
#import "DCRankingWrapper.h"
#import "DCPieWrapper.h"
#import "REMChartHeader.h"
#import "DCLineWrapper.h"
#import "DCLabelingWrapper.h"
#import "REMWidgetCellDelegator.h"
#import "REMWidgetStepEnergyModel.h"
@interface REMWidgetCellViewController ()


@property (nonatomic,weak) UIView *chartContainer;

@property (nonatomic,strong) DAbstractChartWrapper *wrapper;
@property (nonatomic,strong) UIActivityIndicatorView *loadingView;


@property (nonatomic,strong) REMWidgetSearchModelBase *searchModel;
@property (nonatomic,strong) REMWidgetCellDelegator *bizDelegator;
@end

@implementation REMWidgetCellViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view setFrame:self.viewFrame];
    //self.view.layer.borderColor=[UIColor redColor].CGColor;
    //self.view.layer.borderWidth=1;

    self.searchModel=[REMWidgetSearchModelBase searchModelByDataStoreType:self.widgetInfo.contentSyntax.dataStoreType withParam:self.widgetInfo.contentSyntax.params];
    if(self.widgetInfo.contentSyntax.relativeDateType!=REMRelativeTimeRangeTypeNone){
        self.searchModel.relativeDateType=self.widgetInfo.contentSyntax.relativeDateType;
    }
    
    
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(kDashboardWidgetPadding, kDashboardWidgetTitleTopMargin, self.view.frame.size.width, kDashboardWidgetTitleSize)];
    title.backgroundColor=[UIColor clearColor];
    title.font = [UIFont fontWithName:@(kBuildingFontSCRegular) size:kDashboardWidgetTitleSize];
    title.textColor=[UIColor blackColor];
    NSString *textTitle=self.widgetInfo.name;
    if (textTitle.length>=10) {
        textTitle= [[textTitle substringToIndex:9] stringByAppendingString:@"..."];
    }
    title.text=textTitle;
    [self.view addSubview:title];
    
    
    self.bizDelegator=[REMWidgetCellDelegator bizWidgetCellDelegator:self.widgetInfo];
    self.bizDelegator.view=self.view;
    self.bizDelegator.title=title;
    self.bizDelegator.searchModel=self.searchModel;

    [self.bizDelegator initBizView];
    
    if(self.widgetInfo.shareInfo!=nil && [self.widgetInfo.shareInfo isEqual:[NSNull null]]==NO){
        
        UILabel *share=[[UILabel alloc]initWithFrame:CGRectMake(title.frame.origin.x, title.frame.origin.y+2, self.view.frame.size.width-(title.frame.origin.x*2), kDashboardWidgetShareSize)];
        share.backgroundColor=[UIColor clearColor];
        share.textColor=[REMColor colorByHexString:@"#5e5e5e"];
        share.textAlignment=NSTextAlignmentRight;
        NSString *userName=self.widgetInfo.shareInfo.userRealName;
        if (userName.length>=4) {
            userName = [[userName substringToIndex:3] stringByAppendingString:@"..."];
        }
        share.text= [NSString stringWithFormat: NSLocalizedString(@"Dashboard_ShareUserName", @"") , userName];
        share.font = [UIFont fontWithName:@(kBuildingFontSCRegular) size:kDashboardWidgetShareSize];
        [self.view addSubview:share];
    }
    UILabel *time=self.bizDelegator.timeLabel;
    UIView *chartContainer = [[UIView alloc]initWithFrame:CGRectMake(title.frame.origin.x, time.frame.origin.y+time.frame.size.height+kDashboardWidgetChartTopMargin, kDashboardWidgetChartWidth, kDashboardWidgetChartHeight)];
    //chartContainer.layer.borderColor=[UIColor redColor].CGColor;
    //chartContainer.layer.borderWidth=1;
    [self.view addSubview:chartContainer];
    
    self.chartContainer=chartContainer;
    
   
    
    
    [self addConstraint];
    
    
    if (self.chartData!=nil) {
        [self generateChart];
    }
    else{
        [self queryEnergyData:self.widgetInfo.contentSyntax withGroupName:self.groupName];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    if(self.loadingView!=nil){
        [self.loadingView startAnimating];
    }
}


- (void) addConstraint{
    
}

- (void)generateChart{
    [self.loadingView stopAnimating];
    [self.loadingView removeFromSuperview];
    self.loadingView = nil;
    
    if (self.chartData==nil) {
        [self snapshotChartView];
        return;
    }
    
    DAbstractChartWrapper *widgetWrapper = nil;
    REMDiagramType widgetType = self.widgetInfo.diagramType;
    CGRect widgetRect = self.chartContainer.bounds;
    REMEnergyViewData *data=self.chartData;
    REMChartStyle* style = [REMChartStyle getMinimunStyle];
    DWrapperConfig* wrapperConfig = [[DWrapperConfig alloc]initWith:self.widgetInfo];
    if ([self.searchModel isKindOfClass:[REMWidgetStepEnergyModel class]]==YES) {
        REMWidgetStepEnergyModel *stepModel=(REMWidgetStepEnergyModel *)self.searchModel;
        wrapperConfig.stacked=NO;
        wrapperConfig.step=stepModel.step;
        wrapperConfig.benckmarkText=stepModel.benchmarkText;
        wrapperConfig.relativeDateType=stepModel.relativeDateType;
    }
    if (widgetType == REMDiagramTypeLine) {
        widgetWrapper = [[DCLineWrapper alloc]initWithFrame:widgetRect data:data wrapperConfig:wrapperConfig style:style];
    } else if (widgetType == REMDiagramTypeColumn) {
        widgetWrapper = [[DCColumnWrapper alloc]initWithFrame:widgetRect data:data wrapperConfig:wrapperConfig style:style];
    } else if (widgetType == REMDiagramTypePie) {
        widgetWrapper = [[DCPieWrapper alloc]initWithFrame:widgetRect data:data wrapperConfig:wrapperConfig style:style];
    } else if (widgetType == REMDiagramTypeRanking) {
        widgetWrapper = [[DCRankingWrapper alloc]initWithFrame:widgetRect data:data wrapperConfig:wrapperConfig style:style];
    } else if (widgetType == REMDiagramTypeStackColumn) {
        wrapperConfig.stacked=YES;
        widgetWrapper = [[DCColumnWrapper alloc]initWithFrame:widgetRect data:data wrapperConfig:wrapperConfig style:style];
    } else if (widgetType == REMDiagramTypeLabelling) {
        widgetWrapper = [[DCLabelingWrapper alloc]initWithFrame:widgetRect data:data wrapperConfig:wrapperConfig style:style];
    }
    if (widgetWrapper != nil) {
        self.wrapper=widgetWrapper;
        if([widgetWrapper isKindOfClass:[DCTrendWrapper class]]==YES){
            if(self.widgetInfo.contentSyntax.calendarType!=REMCalendarTypeNone){
                DCTrendWrapper *trend=(DCTrendWrapper *)widgetWrapper;
                trend.calenderType=self.widgetInfo.contentSyntax.calendarType;
            }
        }
        [self.chartContainer addSubview:[widgetWrapper getView]];
        
        
        NSRunLoop *loop=[NSRunLoop currentRunLoop];
        NSTimer *timer= [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(snapshotChartView) userInfo:nil repeats:NO];
        [loop addTimer:timer forMode:NSDefaultRunLoopMode];
    }

}

- (void)queryEnergyData:(REMWidgetContentSyntax *)syntax withGroupName:(NSString *)groupName{
    UIActivityIndicatorView *loadingView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView setFrame:self.chartContainer.bounds];
    self.loadingView=loadingView;
    REMEnergySeacherBase *searcher=[REMEnergySeacherBase querySearcherByType:syntax.dataStoreType withWidgetInfo:self.widgetInfo];
    searcher.loadingView=self.loadingView;
    [searcher queryEnergyDataByStoreType:syntax.dataStoreType andParameters:self.searchModel withMaserContainer:self.chartContainer  andGroupName:groupName callback:^(REMEnergyViewData *data,REMBusinessErrorInfo *errorInfo){
        self.chartData = data;
        if(self.isViewLoaded==YES){
            [self generateChart];
        }
    }];
}

- (void)snapshotChartView{
    UIImage* image=[REMImageHelper imageWithView:self.view];
    
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    button.showsTouchWhenHighlighted=NO;
    button.adjustsImageWhenHighlighted=NO;
    [button setExclusiveTouch:YES];
    [button setMultipleTouchEnabled:NO];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    button.tag=[self.widgetInfo.widgetId integerValue];
    [button addTarget:self action:@selector(widgetButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if(self.wrapper!=nil){
        [[self.wrapper getView] removeFromSuperview];
    }
    for (UIView *v in self.view.subviews) {
        [v removeFromSuperview];
    }
    [self.view addSubview:button];
    self.wrapper=nil;
    self.searchModel=nil;
    self.bizDelegator=nil;
}

- (void)widgetButtonPressed:(UIButton *)button{
    //NSLog(@"click widget:%d",button.tag);
    REMWidgetCollectionViewController *parent=(REMWidgetCollectionViewController *)self.parentViewController;
    
    parent.currentMaxWidgetIndex=self.currentIndex;
    
    [parent maxWidget];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //NSLog(@"didReceiveMemoryWarning :%@",[self class]);
}

@end
