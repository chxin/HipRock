/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingAirQualityViewController.m
 * Date Created : tantan on 11/11/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMBuildingAirQualityViewController.h"
#import "REMBuildingAirQualityView.h"
#import "REMBuildingDataViewController.h"
#import "REMBuildingChartViewController.h"
#import "REMBuildingAirQualityChartViewController.h"

@interface REMBuildingAirQualityViewController ()
@property (nonatomic,weak) REMBuildingTitleLabelView *totalLabel;

@property (nonatomic,weak) REMBuildingTitleLabelView *honeywellLabel;
@property (nonatomic,weak) REMBuildingTitleLabelView *mayairLabel;
@property (nonatomic,weak) REMBuildingTitleLabelView *outdoorLabel;
@property (nonatomic) NSUInteger counter;


@end

@implementation REMBuildingAirQualityViewController

- (void)loadView{
    self.view=[[REMBuildingAirQualityView alloc]initWithFrame:self.viewFrame];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.counter=0;
    self.dataLoadComplete=NO;
    [self initCommodityView];
}



- (void)initCommodityView{
    [self initTotalValue];
    [self initDetailValue];
    [self initChartContainer];
    if(self.airQualityUsage==nil){
        [self loadTotalUsageByBuildingId:self.buildingInfo.building.buildingId];
    }
    else{
        [self addDataLabel];
    }
}

- (void)loadedPart{
    if (self.counter==1) {
        self.dataLoadComplete=YES;
        REMBuildingDataViewController *dataController=(REMBuildingDataViewController *)self.parentViewController;
        [dataController loadingDataComplete:self.index];
    }
    self.counter++;
}

- (void)loadChartComplete{
    [self loadedPart];
}

- (void)addDataLabel{
    REMAirQualityModel *model=self.airQualityUsage;
    self.totalLabel.data=model.honeywell;
    self.honeywellLabel.data=model.honeywell;
    self.mayairLabel.data=model.mayair;
    self.outdoorLabel.data=model.outdoor;
    [self loadedPart];
}

- (void)loadTotalUsageByBuildingId:(NSNumber *)buildingId{
    NSDictionary *param = @{@"buildingId":buildingId};
    REMDataStore *store = [[REMDataStore alloc]initWithName:REMDSBuildingAirQualityTotalUsage parameter:param];
    store.maskContainer = nil;
    store.groupName = [NSString stringWithFormat:@"building-data-%@", buildingId];
    [self.totalLabel showLoading];
    [self.outdoorLabel showLoading];
    [self.honeywellLabel showLoading];
    [self.mayairLabel showLoading];
    [REMDataAccessor access:store success:^(NSDictionary *data) {
        REMAirQualityModel *model=nil;
        if([data isEqual:[NSNull null]]==YES){
            model=nil;
        }
        else{
            model=[[REMAirQualityModel alloc]initWithDictionary:data];
            if(model!=nil){
                self.airQualityUsage=model;
            }
        }
        [self.totalLabel hideLoading];
        [self.outdoorLabel hideLoading];
        [self.honeywellLabel hideLoading];
        [self.mayairLabel hideLoading];
        [self addDataLabel];
    } error:^(NSError *error, id response) {
        
    }];
}

- (void)addSplitBar:(UIView *)view
{
    CGRect frame=view.frame;
    //NSLog(@"splitbar:%@",NSStringFromCGRect(frame));
    CGRect frame1 = CGRectMake(0, 0, 1, frame.size.height);
    CGRect frame2 = CGRectMake(1, 0, 1, frame.size.height);
    
    CALayer *layer1 = [CALayer layer];
    
    layer1.frame=frame1;
    layer1.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.25].CGColor;
    UIGraphicsBeginImageContextWithOptions(frame1.size, NO, 0.0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    [layer1 renderInContext:c];
    
    
    
    CAGradientLayer *layer2 = [CALayer layer];
    
    
    layer2.frame = frame2;
    layer2.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.11].CGColor;
    
    
    
    [layer2 renderInContext:c];
    
    
    UIGraphicsEndImageContext();
    
    
    [view.layer insertSublayer:layer1 above:view.layer];
    [view.layer insertSublayer:layer2 above:view.layer];
}


- (void)initTotalValue
{
    NSString *title=NSLocalizedString(@"Building_AirQualityIndoor", @"");//室内PM2.5
    REMBuildingTitleLabelView *totalLabel=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(0, 0, 900, kBuildingCommodityTotalHeight)];
    totalLabel.textWidth=1000;
    totalLabel.title=title;
    totalLabel.titleFontSize=kBuildingCommodityTitleFontSize;
    totalLabel.titleMargin=kBuildingTotalInnerMargin;
    totalLabel.leftMargin=0;
    totalLabel.valueFontSize=kBuildingCommodityTotalValueFontSize;
    totalLabel.uomFontSize=kBuildingCommodityTotalUomFontSize;
    //totalLabel.emptyText=NSLocalizedString(@"BuildingChart_NoData", @"");//@"请持续关注能耗变化";
    totalLabel.emptyTextFontSize=29;
    totalLabel.emptyTextFont=@(kBuildingFontSCRegular);
    totalLabel.emptyTextMargin=28;
    [totalLabel showTitle];
    [self.view addSubview:totalLabel];
    self.totalLabel=totalLabel;
    
}

- (void)initDetailValue
{
    int marginTop=kBuildingCommodityTotalHeight+kBuildingCommodityBottomMargin;
    
    REMBuildingTitleLabelView *outdoor=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(0, marginTop, kBuildingCommodityDetailWidth, kBuildingCommodityDetailHeight)];
    outdoor.textWidth=300;
    outdoor.title=NSLocalizedString(@"Building_AirQualityOutdoor", @""); //@"室外PM2.5";
    outdoor.titleFontSize=kBuildingCommodityTitleFontSize;
    outdoor.titleMargin=kBuildingDetailInnerMargin;
    outdoor.leftMargin=0;
    outdoor.valueFontSize=kBuildingCommodityDetailValueFontSize;
    outdoor.uomFontSize=kBuildingCommodityDetailUomFontSize;
    outdoor.emptyTextFontSize=29;
    outdoor.emptyTextFont=@(kBuildingFontSCRegular);
    outdoor.emptyTextMargin=28;
    [outdoor showTitle];
    
    [self.view addSubview:outdoor];
    self.outdoorLabel=outdoor;
    
    REMBuildingTitleLabelView *honeywell=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(kBuildingCommodityDetailWidth, marginTop, kBuildingCommodityDetailWidth, kBuildingCommodityDetailHeight)];
    honeywell.title=NSLocalizedString(@"Building_AirQualityHoneywell", @""); //@"室内新风PM2.5(霍尼)";
    honeywell.textWidth=300;
    honeywell.titleFontSize=kBuildingCommodityTitleFontSize;
    honeywell.titleMargin=kBuildingDetailInnerMargin;
    honeywell.leftMargin=kBuildingCommodityDetailTextMargin;
    honeywell.valueFontSize=kBuildingCommodityDetailValueFontSize;
    honeywell.emptyTextFontSize=29;
    honeywell.uomFontSize=kBuildingCommodityDetailUomFontSize;
    honeywell.emptyTextFont=@(kBuildingFontSCRegular);
    honeywell.emptyTextMargin=28;
    [honeywell showTitle];
    [self.view addSubview:honeywell];
    self.honeywellLabel=honeywell;
    [self addSplitBar:honeywell];
    
    
    
    REMBuildingTitleLabelView *mayair=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(kBuildingCommodityDetailWidth*2, self.honeywellLabel.frame.origin.y, kBuildingCommodityDetailWidth, kBuildingCommodityDetailHeight)];
    mayair.title=NSLocalizedString(@"Building_AirQualityMayair", @""); //@"室内新风PM2.5(美埃)";
    mayair.textWidth=400;
    mayair.titleFontSize=kBuildingCommodityTitleFontSize;
    mayair.titleMargin=kBuildingDetailInnerMargin;
    mayair.leftMargin=kBuildingCommodityDetailTextMargin;
    mayair.valueFontSize=kBuildingCommodityDetailValueFontSize;
    mayair.uomFontSize=kBuildingCommodityDetailUomFontSize;
    mayair.emptyTextFontSize=29;
    mayair.emptyTextFont=@(kBuildingFontSCRegular);
    mayair.emptyTextMargin=28;
    [mayair showTitle];
    [self addSplitBar:mayair];
    
    
    [self.view addSubview:mayair];
    self.mayairLabel=mayair;
    
}


- (void)initChartContainer
{
    int marginTop=kBuildingCommodityTotalHeight+kBuildingCommodityDetailHeight+kBuildingDetailInnerMargin+kBuildingCommodityBottomMargin*2;
    int chartContainerHeight= kBuildingChartHeight*2+kBuildingCommodityBottomMargin+85;
    NSString *title1=NSLocalizedString(@"Building_AirQualityDailyChart", @"");//室内外PM2.5逐日含量
    
    UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, marginTop, kBuildingCommodityDetailWidth, kBuildingCommodityTitleFontSize)];
    titleLabel1.text=title1;
    titleLabel1.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    titleLabel1.shadowOffset=CGSizeMake(1, 1);
    
    titleLabel1.backgroundColor=[UIColor clearColor];
    titleLabel1.font = [UIFont fontWithName:@(kBuildingFontSC) size:kBuildingCommodityTitleFontSize];
    titleLabel1.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel1];
    
    
    if (self.childViewControllers.count<1) {
        REMBuildingChartViewController *controller1=[[REMBuildingChartViewController alloc] init];
        controller1.viewFrame=CGRectMake(0, marginTop+kBuildingCommodityTitleFontSize+kBuildingDetailInnerMargin, kBuildingChartWidth, chartContainerHeight-kBuildingCommodityTitleFontSize-kBuildingDetailInnerMargin);
        //NSLog(@"view frame:%@",NSStringFromCGRect(controller1.viewFrame));
        controller1.chartHandlerClass=[REMBuildingAirQualityChartViewController class];
        controller1.buildingId=self.buildingInfo.building.buildingId;
        controller1.commodityId=self.airQualityUsage.commodity.commodityId;
        [self addChildViewController:controller1];
    }
}

- (void)showChart{
    
    for (int i=0; i<self.childViewControllers.count; ++i) {
        REMBuildingChartViewController *controller=self.childViewControllers[i];
        if(controller.isViewLoaded==NO){
            [self.view addSubview:controller.view];
        }
    }
    
    
}


@end
