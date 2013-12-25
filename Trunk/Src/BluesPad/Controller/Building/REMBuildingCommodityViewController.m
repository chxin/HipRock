/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingCommodityViewController.m
 * Date Created : tantan on 11/11/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMBuildingCommodityViewController.h"
#import "REMBuildingChartViewController.h"
#import "REMBuildingAverageChartViewController.h"
#import "REMBuildingTrendChartViewController.h"
#import "REMBuildingDataViewController.h"
#import "REMBuildingCommodityView.h"


@interface REMBuildingCommodityViewController ()

//typedef void(^SuccessCallback)(BOOL success);

@property (nonatomic,weak) REMBuildingTitleLabelView *totalLabel;

@property (nonatomic,weak) REMBuildingTitleLabelView *carbonLabel;
@property (nonatomic,weak) REMBuildingTitleLabelView *targetLabel;
@property (nonatomic,weak) REMBuildingRankingView *rankingLabel;



@property (nonatomic) NSUInteger counter;


@property (nonatomic,strong) NSArray *chartViewSnapshotArray;


@end

@implementation REMBuildingCommodityViewController

- (void)loadView{
    self.view=[[REMBuildingCommodityView alloc]initWithFrame:self.viewFrame];
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
    if(self.commodityUsage==nil){
        [self loadTotalUsageByBuildingId:self.buildingInfo.building.buildingId ByCommodityId:self.commodityInfo.commodityId];
    }
    else{
        [self addDataLabel];
    }
}

- (void)loadedPart{
    if (self.counter==2) {
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
    REMCommodityUsageModel *model=self.commodityUsage;
    self.totalLabel.data=model.commodityUsage;
    self.carbonLabel.data=model.carbonEquivalent;
    self.rankingLabel.data=model.rankingData;
    [self loadedPart];
    if(model.targetValue!=nil &&
       model.targetValue!=nil &&
       ![model.targetValue.dataValue isEqual:[NSNull null]] &&
       [model.targetValue.dataValue isGreaterThan:@(0)])
    {
        REMBuildingTitleLabelView *target=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(kBuildingCommodityDetailWidth*2, self.rankingLabel.frame.origin.y, kBuildingCommodityDetailWidth, kBuildingCommodityDetailHeight)];
        target.title=NSLocalizedString(@"Building_Target", @""); //@"目标值";
        target.textWidth=400;
        target.titleFontSize=kBuildingCommodityTitleFontSize;
        target.titleMargin=kBuildingDetailInnerMargin;
        target.leftMargin=kBuildingCommodityDetailTextMargin;
        target.valueFontSize=kBuildingCommodityDetailValueFontSize;
        target.uomFontSize=kBuildingCommodityDetailUomFontSize;
        [target showTitle];
        [self addSplitBar:target];
        if (model.commodityUsage!=nil && model.commodityUsage.dataValue!=nil &&
            ![model.commodityUsage.dataValue isEqual:[NSNull null]]) {
            if(model.isTargetAchieved==YES){
                [target setTitleIcon:[UIImage imageNamed:@"OverTarget"]];
            }
            else{
                [target setTitleIcon:[UIImage imageNamed:@"NotOverTarget"]];
            }
        }
        
        [self.view addSubview:target];
        self.targetLabel=target;
        self.targetLabel.data=model.targetValue;
    }
}

- (void)loadTotalUsageByBuildingId:(NSNumber *)buildingId ByCommodityId:(NSNumber *)commodityId
{
    NSDictionary *param = @{@"commodityId":commodityId,@"buildingId":buildingId};
    REMDataStore *store = [[REMDataStore alloc]initWithName:REMDSBuildingCommodityTotalUsage parameter:param];
    store.maskContainer = nil;
    store.groupName = [NSString stringWithFormat:@"building-data-%@", buildingId];
    [self.totalLabel showLoading];
    [self.carbonLabel showLoading];
    [self.rankingLabel showLoading];
    [store access:^(NSDictionary *data) {
        REMCommodityUsageModel *model=nil;
        if([data isEqual:[NSNull null]]==YES){
            model=nil;
        }
        else{
            model=[[REMCommodityUsageModel alloc]initWithDictionary:data];
            if(model!=nil){
                self.commodityUsage=model;
            }
        }
        [self.totalLabel hideLoading];
        [self.carbonLabel hideLoading];
        [self.rankingLabel hideLoading];
        [self addDataLabel];
    } error:^(NSError *error, REMDataAccessErrorStatus status, id response) {
        
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
    NSString *title=NSLocalizedString(@"Building_ThisMonthEnergyUsage", @"");//本月用%@总量
    REMBuildingTitleLabelView *totalLabel=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(0, 0, 900, kBuildingCommodityTotalHeight)];
    totalLabel.textWidth=1000;
    totalLabel.title=[NSString stringWithFormat:title,self.commodityInfo.comment];
    totalLabel.titleFontSize=kBuildingCommodityTitleFontSize;
    totalLabel.titleMargin=kBuildingTotalInnerMargin;
    totalLabel.leftMargin=0;
    totalLabel.valueFontSize=kBuildingCommodityTotalValueFontSize;
    totalLabel.uomFontSize=kBuildingCommodityTotalUomFontSize;
    totalLabel.emptyText=NSLocalizedString(@"BuildingChart_NoData", @"");//@"请持续关注能耗变化";
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
    
    REMBuildingTitleLabelView *carbon=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(0, marginTop, kBuildingCommodityDetailWidth, kBuildingCommodityDetailHeight)];
    carbon.textWidth=300;
    carbon.title=NSLocalizedString(@"Building_CarbonUsage", @""); //@"二氧化碳当量";
    carbon.titleFontSize=kBuildingCommodityTitleFontSize;
    carbon.titleMargin=kBuildingDetailInnerMargin;
    carbon.leftMargin=0;
    carbon.valueFontSize=kBuildingCommodityDetailValueFontSize;
    carbon.uomFontSize=kBuildingCommodityDetailUomFontSize;
    carbon.emptyTextFontSize=29;
    carbon.emptyTextFont=@(kBuildingFontSCRegular);
    carbon.emptyTextMargin=28;
    [carbon showTitle];
    
    [self.view addSubview:carbon];
    self.carbonLabel=carbon;
    
    REMBuildingRankingView *ranking=[[REMBuildingRankingView alloc]initWithFrame:CGRectMake(kBuildingCommodityDetailWidth, marginTop, kBuildingCommodityDetailWidth, kBuildingCommodityDetailHeight)];
    ranking.title=NSLocalizedString(@"Building_CorporationRanking", @""); //@"集团排名";
    ranking.textWidth=300;
    ranking.titleFontSize=kBuildingCommodityTitleFontSize;
    ranking.titleMargin=kBuildingDetailInnerMargin;
    ranking.leftMargin=kBuildingCommodityDetailTextMargin;
    ranking.emptyTextFontSize=29;
    ranking.emptyTextFont=@(kBuildingFontSCRegular);
    ranking.emptyTextMargin=28;
    [ranking showTitle];
    [self.view addSubview:ranking];
    self.rankingLabel=ranking;
    [self addSplitBar:ranking];
    
}

- (void)initTitle{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kBuildingCommodityDetailWidth, kBuildingCommodityTitleFontSize)];
    titleLabel.text=self.title;
    titleLabel.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    titleLabel.shadowOffset=CGSizeMake(1, 1);
    
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@(kBuildingFontSC) size:kBuildingCommodityTitleFontSize];
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
}

- (void)initChartContainer
{
    int marginTop=kBuildingCommodityTotalHeight+kBuildingCommodityDetailHeight+kBuildingDetailInnerMargin+kBuildingCommodityBottomMargin*2;
    int chartContainerHeight=kBuildingChartHeight;
    NSString *title1=NSLocalizedString(@"Building_EnergyUsageByAreaByMonth", @"");//单位面积逐月用%@
    
    UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, marginTop, kBuildingCommodityDetailWidth, kBuildingCommodityTitleFontSize)];
    titleLabel1.text=[NSString stringWithFormat:title1,self.commodityInfo.comment];
    titleLabel1.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    titleLabel1.shadowOffset=CGSizeMake(1, 1);
    
    titleLabel1.backgroundColor=[UIColor clearColor];
    titleLabel1.font = [UIFont fontWithName:@(kBuildingFontSC) size:kBuildingCommodityTitleFontSize];
    titleLabel1.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel1];
    
    
    if (self.childViewControllers.count<2) {
        REMBuildingChartViewController *controller1=[[REMBuildingChartViewController alloc] init];
        controller1.viewFrame=CGRectMake(0, marginTop+kBuildingCommodityTitleFontSize+kBuildingDetailInnerMargin, kBuildingChartWidth, chartContainerHeight-kBuildingCommodityTitleFontSize-kBuildingDetailInnerMargin);
        //NSLog(@"view frame:%@",NSStringFromCGRect(controller1.viewFrame));
        controller1.chartHandlerClass=[REMBuildingAverageViewController class];
        controller1.buildingId=self.buildingInfo.building.buildingId;
        controller1.commodityId=self.commodityInfo.commodityId;
        [self addChildViewController:controller1];
    }
   
    
    int marginTop1=marginTop+chartContainerHeight+kBuildingCommodityBottomMargin;
    CGFloat secondChartHeight=chartContainerHeight+85;//85 is delta value for second chart in commodity view

    NSString *title2=NSLocalizedString(@"Building_EnergyUsageByCommodity", @"");//用%@趋势图
    
    UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, marginTop1, kBuildingCommodityDetailWidth, kBuildingCommodityTitleFontSize)];
    titleLabel2.text=[NSString stringWithFormat:title2,self.commodityInfo.comment];;
    titleLabel2.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    titleLabel2.shadowOffset=CGSizeMake(1, 1);
    
    titleLabel2.backgroundColor=[UIColor clearColor];
    titleLabel2.font = [UIFont fontWithName:@(kBuildingFontSC) size:kBuildingCommodityTitleFontSize];
    titleLabel2.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel2];

    if (self.childViewControllers.count<2) {
        REMBuildingChartViewController *controller2=[[REMBuildingChartViewController alloc] init];
        controller2.viewFrame=CGRectMake(0, marginTop1+kBuildingCommodityTitleFontSize+kBuildingDetailInnerMargin, kBuildingChartWidth, secondChartHeight-kBuildingCommodityTitleFontSize-kBuildingDetailInnerMargin);
        //NSLog(@"view frame:%@",NSStringFromCGRect(controller2.viewFrame));
        controller2.chartHandlerClass=[REMBuildingTrendChartViewController class];
        controller2.commodityId=self.commodityInfo.commodityId;
        controller2.buildingId=self.buildingInfo.building.buildingId;
        [self addChildViewController:controller2];
    
    }
    

}

- (void)showChart{
    
    for (int i=0; i<self.childViewControllers.count; ++i) {
        REMBuildingChartViewController *controller=self.childViewControllers[i];
        if(controller.isViewLoaded==NO){
            [self.view addSubview:controller.view];
        }
    }
    
    /*
    
    REMBuildingChartContainerView *averageContainer = self.chartViewArray[0];
    
    if(averageContainer.controller==nil){
        REMBuildingAverageChartHandler *averageController = [[REMBuildingAverageChartHandler alloc]initWithViewFrame:CGRectMake(0, 0, averageContainer.frame.size.width, averageContainer.chartContainer.frame.size.height)];
        averageContainer.controller=averageController;
    }
    
    
    [averageContainer requireChartDataWithBuildingId:buildingId withCommodityId:commodityId withEnergyData:nil complete:^(BOOL success){
        [self sucessRequest];
    }];
    
    
    REMBuildingChartContainerView *trendContainer = self.chartViewArray[1];
    
    if (trendContainer.controller==nil) {
        REMBuildingTrendChartHandler  *trendController = [[REMBuildingTrendChartHandler alloc]initWithViewFrame:CGRectMake(0, 0, trendContainer.frame.size.width, trendContainer.chartContainer.frame.size.height)];
        trendContainer.controller=trendController;
        
    }
    
    [trendContainer requireChartDataWithBuildingId:buildingId withCommodityId:commodityId withEnergyData:nil complete:^(BOOL success){
        [self sucessRequest];
    }];*/

}



@end
