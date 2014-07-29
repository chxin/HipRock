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
#import "DCChartEnum.h"
#import "DCTrendWrapper.h"
#import "DCLabelingWrapper.h"
#import "REMWidgetCellDelegator.h"
#import "REMWidgetStepEnergyModel.h"
#import "REMManagedSharedModel.h"
#import "REMWrapperFactor.h"

@interface REMWidgetCellViewController ()


@property (nonatomic,weak) UIView *chartContainer;

@property (nonatomic,strong) DAbstractChartWrapper *wrapper;
@property (nonatomic,strong) UIActivityIndicatorView *loadingView;


@property (nonatomic,strong) REMWidgetSearchModelBase *searchModel;
@property (nonatomic,strong) REMWidgetCellDelegator *bizDelegator;
@property (nonatomic,strong) REMWidgetContentSyntax *contentSyntax;
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
    
    self.contentSyntax = [[REMWidgetContentSyntax alloc]initWithJSONString:self.widgetInfo.contentSyntax];

    self.searchModel=[REMWidgetSearchModelBase searchModelByDataStoreType:self.contentSyntax.dataStoreType withParam:self.contentSyntax.params];
    if(self.contentSyntax.relativeDateType!=REMRelativeTimeRangeTypeNone){
        self.searchModel.relativeDateType=self.contentSyntax.relativeDateType;
    }
    
    
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(kDashboardWidgetPadding, kDashboardWidgetTitleTopMargin, self.view.frame.size.width, kDashboardWidgetTitleSize)];
    title.backgroundColor=[UIColor clearColor];
    title.font = [REMFont fontWithKey:@(kBuildingFontKeyRegular) size:kDashboardWidgetTitleSize];
    title.textColor=[UIColor blackColor];
    NSString *textTitle=self.widgetInfo.name;
    if (textTitle.length>=10) {
        textTitle= [[textTitle substringToIndex:9] stringByAppendingString:@"..."];
    }
    title.text=textTitle;
    [self.view addSubview:title];
    
    
    self.bizDelegator=[REMWidgetCellDelegator bizWidgetCellDelegator:self.widgetInfo andSyntax:self.contentSyntax];
    self.bizDelegator.view=self.view;
    self.bizDelegator.title=title;
    self.bizDelegator.searchModel=self.searchModel;

    [self.bizDelegator initBizView];
    
    if(self.widgetInfo.sharedInfo!=nil && [self.widgetInfo.sharedInfo isEqual:[NSNull null]]==NO){
        
        UILabel *share=[[UILabel alloc]initWithFrame:CGRectMake(title.frame.origin.x, title.frame.origin.y+2, self.view.frame.size.width-(title.frame.origin.x*2), kDashboardWidgetShareSize)];
        share.backgroundColor=[UIColor clearColor];
        share.textColor=[REMColor colorByHexString:@"#5e5e5e"];
        share.textAlignment=NSTextAlignmentRight;
        NSString *userName=self.widgetInfo.sharedInfo.userRealName;
        if (userName.length>=4) {
            userName = [[userName substringToIndex:3] stringByAppendingString:@"..."];
        }
        share.text= [NSString stringWithFormat: REMIPadLocalizedString(@"Dashboard_ShareUserName") , userName];
        share.font = [REMFont fontWithKey:@(kBuildingFontKeyRegular) size:kDashboardWidgetShareSize];
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
//        if ([self.widgetInfo.name isEqualToString:@"自定义时间成本查看line"]) {
        [self queryEnergyData:self.contentSyntax withGroupName:self.groupName];
//        }
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
    CGRect widgetRect = self.chartContainer.bounds;
    REMEnergyViewData *data=self.chartData;
    DCChartStyle* style = [DCChartStyle getMinimunStyle];
    DWrapperConfig* wrapperConfig = [[DWrapperConfig alloc]initWith:self.contentSyntax];
    if ([self.searchModel isKindOfClass:[REMWidgetStepEnergyModel class]]==YES) {
        REMWidgetStepEnergyModel *stepModel=(REMWidgetStepEnergyModel *)self.searchModel;
        wrapperConfig.step=stepModel.step;
        wrapperConfig.benckmarkText=stepModel.benchmarkText;
        wrapperConfig.relativeDateType=stepModel.relativeDateType;
//        wrapperConfig.multiTimeSpans=stepModel.timeRangeArray;
    }
    widgetWrapper = [REMWrapperFactor constructorWrapper:widgetRect data:data wrapperConfig:wrapperConfig style:style];
    if (widgetWrapper != nil) {
        self.wrapper=widgetWrapper;
        widgetWrapper.delegate = self;
        [self.chartContainer addSubview:[widgetWrapper getView]];
        
//        NSRunLoop *loop=[NSRunLoop currentRunLoop];
//        NSTimer *timer= [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(snapshotChartView) userInfo:nil repeats:NO];
//        [loop addTimer:timer forMode:NSDefaultRunLoopMode];
    }

}

- (void)queryEnergyData:(REMWidgetContentSyntax *)syntax withGroupName:(NSString *)groupName{
    UIActivityIndicatorView *loadingView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView setFrame:self.chartContainer.bounds];
    self.loadingView=loadingView;
    REMEnergySeacherBase *searcher=[REMEnergySeacherBase querySearcherByType:syntax.dataStoreType withWidgetInfo:self.widgetInfo andSyntax:self.contentSyntax
                                    ];
    searcher.loadingView=self.loadingView;
    searcher.disableNetworkAlert=YES;
    [searcher queryEnergyDataByStoreType:syntax.dataStoreType andParameters:self.searchModel withMaserContainer:self.chartContainer  andGroupName:groupName callback:^(REMEnergyViewData *data,REMBusinessErrorInfo *errorInfo){
        if (data==nil) {
            if (errorInfo==nil) { // timeout or network failed
                [self generateServerErrorLabel:REMIPadLocalizedString(@"Common_ServerTimeout")];
                self.isServerTimeout=YES;
            }
            else{
                self.serverError=errorInfo;
                if ([errorInfo.code isEqualToString:@"1"]==YES) {
                    [self generateServerErrorLabel:REMIPadLocalizedString(@"Common_ServerError")];
                }
            }
        }
        else{
            self.chartData = data;
        }
        if(self.isViewLoaded==YES){
            [self generateChart];
        }
    }];
}

- (void)generateServerErrorLabel:(NSString *)msg{
    UIFont *font = [REMFont defaultFontOfSize:kDashboardWidgetTitleSize];
    
    CGSize size = [msg sizeWithFont:font];
    
    UILabel *label=[[UILabel alloc]init];
    label.translatesAutoresizingMaskIntoConstraints=NO;
    label.textColor= [[UIColor blackColor] colorWithAlphaComponent:0.6] ;
    label.text=msg;
    label.font=font;
    [label setBackgroundColor:[UIColor clearColor]];
    
    label.frame = CGRectMake((self.view.bounds.size.width - size.width)/2, (self.view.bounds.size.height - size.height)/2, size.width, size.height);
    
//    NSLayoutConstraint *constraintX=[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
//    NSLayoutConstraint *constraintY=[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
//    [self.view addConstraint:constraintX];
//    [self.view addConstraint:constraintY];
    [self.view addSubview:label];
    

}

-(void)beginAnimationDone {
    [self snapshotChartView];
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
    button.tag=[self.widgetInfo.id integerValue];
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
