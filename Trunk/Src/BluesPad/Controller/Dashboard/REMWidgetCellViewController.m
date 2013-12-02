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
#import "REMRankingWidgetWrapper.h"
#import "REMAbstractChartWrapper.h"
#import "REMWidgetCollectionViewController.h"
#import "REMWidgetSearchModelBase.h"
#import "DCRankingWrapper.h"
#import "DCPieWrapper.h"
@interface REMWidgetCellViewController ()


@property (nonatomic,weak) UIView *chartContainer;

@property (nonatomic,strong) DAbstractChartWrapper *wrapper;
@property (nonatomic,strong) REMPieChartWrapper *pieWrapper;
@property (nonatomic,strong) UIActivityIndicatorView *loadingView;


@property (nonatomic,strong) REMWidgetSearchModelBase *searchModel;
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
    
    //NSLog(@"detail view:%@",NSStringFromCGRect(self.view.frame));

    self.searchModel=[REMWidgetSearchModelBase searchModelByDataStoreType:self.widgetInfo.contentSyntax.dataStoreType withParam:self.widgetInfo.contentSyntax.params];
    if(self.widgetInfo.contentSyntax.relativeDateType!=REMRelativeTimeRangeTypeNone){
        self.searchModel.relativeDateType=self.widgetInfo.contentSyntax.relativeDateType;
    }

    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(kDashboardWidgetPadding, kDashboardWidgetTitleTopMargin, self.view.frame.size.width, kDashboardWidgetTitleSize)];
    title.backgroundColor=[UIColor clearColor];
    title.font = [UIFont fontWithName:@(kBuildingFontSCRegular) size:kDashboardWidgetTitleSize];
    //title.font = [UIFont fontWithName:@(kBuildingFontSC) size:kDashboardWidgetTitleSize];
    //title.textColor=[REMColor colorByHexString:@"#4c4c4c"];
    title.textColor=[UIColor blackColor];
    NSString *textTitle=self.widgetInfo.name;
    if (textTitle.length>=10) {
        textTitle= [[textTitle substringToIndex:9] stringByAppendingString:@"..."];
    }
    title.text=textTitle;
    [self.view addSubview:title];

    
    UILabel *time=[[UILabel alloc]initWithFrame:CGRectMake(title.frame.origin.x, title.frame.origin.y+title.frame.size.height+kDashboardWidgetTimeTopMargin, self.view.frame.size.width, kDashboardWidgetTimeSize)];
    time.backgroundColor=[UIColor clearColor];
    time.textColor=[REMColor colorByHexString:@"#5e5e5e"];
    time.font = [UIFont fontWithName:@(kBuildingFontSCRegular) size:kDashboardWidgetTimeSize];
    if([self.widgetInfo.contentSyntax.relativeDate isEqual:[NSNull null]]==NO){
        time.text=self.widgetInfo.contentSyntax.relativeDateComponent;
    }
    else{
        REMTimeRange *range = self.widgetInfo.contentSyntax.timeRanges[0];
        NSString *start= [REMTimeHelper formatTimeFullHour:range.startTime isChangeTo24Hour:NO];
        NSString *end= [REMTimeHelper formatTimeFullHour:range.endTime isChangeTo24Hour:YES];
        time.text=[NSString stringWithFormat:NSLocalizedString(@"Dashboard_TimeRange", @""),start,end];//%@ 到 %@
    }
    [self.view addSubview:time];

    if(self.widgetInfo.shareInfo!=nil && [self.widgetInfo.shareInfo isEqual:[NSNull null]]==NO){
        
        UILabel *share=[[UILabel alloc]initWithFrame:CGRectMake(title.frame.origin.x, title.frame.origin.y+2, self.view.frame.size.width-(title.frame.origin.x*2), kDashboardWidgetShareSize)];
        share.backgroundColor=[UIColor clearColor];
        share.textColor=[REMColor colorByHexString:@"#5e5e5e"];
        share.textAlignment=NSTextAlignmentRight;
        share.text= [NSString stringWithFormat: NSLocalizedString(@"Dashboard_ShareUserName", @"") , self.widgetInfo.shareInfo.userRealName];
        share.font = [UIFont fontWithName:@(kBuildingFontSCRegular) size:kDashboardWidgetShareSize];
        [self.view addSubview:share];
    }
    
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
    DAbstractChartWrapper *widgetWrapper = nil;
    REMPieChartWrapper *pieWrapper=nil;
    REMDiagramType widgetType = self.widgetInfo.diagramType;
    CGRect widgetRect = self.chartContainer.bounds;
    REMEnergyViewData *data=self.chartData;
    REMChartStyle* style = [REMChartStyle getMinimunStyle];

    if (widgetType == REMDiagramTypeLine) {
        widgetWrapper = [[DCLineWrapper alloc]initWithFrame:widgetRect data:data widgetContext:self.widgetInfo.contentSyntax style:style];
//        widgetWrapper = [[REMLineWidgetWrapper alloc]initWithFrame:widgetRect data:data widgetContext:self.widgetInfo.contentSyntax style:style];
    } else if (widgetType == REMDiagramTypeColumn) {
        widgetWrapper = [[DCColumnWrapper alloc]initWithFrame:widgetRect data:data widgetContext:self.widgetInfo.contentSyntax style:style];
//        widgetWrapper = [[REMColumnWidgetWrapper alloc]initWithFrame:widgetRect data:data widgetContext:self.widgetInfo.contentSyntax style:style];
    } else if (widgetType == REMDiagramTypePie) {
        pieWrapper = [[REMPieChartWrapper alloc]initWithFrame:widgetRect data:data widgetContext:self.widgetInfo.contentSyntax style:style];
    } else if (widgetType == REMDiagramTypeRanking) {
//        widgetWrapper = [[REMRankingWidgetWrapper alloc]initWithFrame:widgetRect data:data widgetContext:self.widgetInfo.contentSyntax style:style];
        widgetWrapper = [[DCRankingWrapper alloc]initWithFrame:widgetRect data:data widgetContext:self.widgetInfo.contentSyntax style:style];
    } else if (widgetType == REMDiagramTypeStackColumn) {
        widgetWrapper = [[DCColumnWrapper alloc]initWithFrame:widgetRect data:data widgetContext:self.widgetInfo.contentSyntax style:style];
    }
    if (widgetWrapper != nil || pieWrapper!=nil) {
        if(widgetWrapper!=nil){
            self.wrapper=widgetWrapper;
            if([widgetWrapper isKindOfClass:[DCTrendWrapper class]]==YES){
                if(self.widgetInfo.contentSyntax.calendarType!=REMCalendarTypeNone){
                    DCTrendWrapper *trend=(DCTrendWrapper *)widgetWrapper;
                    trend.calenderType=self.widgetInfo.contentSyntax.calendarType;
                }
            }
            [self.chartContainer addSubview:[widgetWrapper getView]];
        }
        else if(pieWrapper!=nil){
            self.pieWrapper=pieWrapper;
            [self.chartContainer addSubview:[pieWrapper getView]];
//            [self.chartContainer addSubview:pieWrapper.view];
        }
        
        
        //[widgetWrapper destroyView];
        
        
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
//    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    UIImage* image=[REMImageHelper imageWithView:self.view];
    //UIImageView *v = [[UIImageView alloc]initWithImage:image];
    
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //[button setBounds:self.chartContainer.bounds];
    button.showsTouchWhenHighlighted=NO;
    button.adjustsImageWhenHighlighted=NO;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    //[button setBackgroundImage:image forState:UIControlStateHighlighted];
    //[button setBackgroundImage:image forState:UIControlStateSelected];
    button.tag=[self.widgetInfo.widgetId integerValue];
    [button addTarget:self action:@selector(widgetButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //[self.wrapper destroyView];
    if(self.wrapper!=nil){
        [[self.wrapper getView] removeFromSuperview];
    }
    else if(self.pieWrapper!=nil){
        [self.pieWrapper.view removeFromSuperview];
    }
    for (UIView *v in self.view.subviews) {
        [v removeFromSuperview];
    }
    [self.view addSubview:button];
    self.wrapper=nil;
    self.pieWrapper=nil;
    self.searchModel=nil;
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
