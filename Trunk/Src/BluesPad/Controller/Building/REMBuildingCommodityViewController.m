/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingCommodityViewController.m
 * Date Created : tantan on 11/11/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMBuildingCommodityViewController.h"
#import "REMBuildingChartContainerViewController.h"
#import "REMBuildingAverageChartViewController.h"
#import "REMBuildingTrendChartViewController.h"
#import "REMBuildingDataViewController.h"
#import "REMBuildingCommodityView.h"
#import "REMBuildingCoverWidgetRelationModel.h"
#import "REMBuildingCoverWidgetViewController.h"
#import "REMBuildingWidgetChartViewController.h"


@interface REMBuildingCommodityViewController ()

//typedef void(^SuccessCallback)(BOOL success);

@property (nonatomic,weak) REMBuildingTitleLabelView *totalLabel;

@property (nonatomic,weak) REMBuildingTitleLabelView *carbonLabel;
@property (nonatomic,weak) REMBuildingTitleLabelView *targetLabel;
@property (nonatomic,weak) REMBuildingRankingView *rankingLabel;

@property (nonatomic,weak) UILabel *firstChartTitleLabel;
@property (nonatomic,weak) UILabel *secondChartTitleLabel;

@property (nonatomic) NSUInteger counter;


@property (nonatomic,strong) NSArray *chartViewSnapshotArray;


@property (nonatomic,strong) UIPopoverController *popController;

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
            [model.commodityUsage.dataValue isEqual:[NSNull null]] == NO) {
            if(model.isTargetAchieved==YES){
                [target setTitleIcon:[UIImage imageNamed:@"OverTarget"] ];
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
    REMDataStore *store = [[REMDataStore alloc]initWithName:REMDSBuildingCommodityTotalUsage parameter:param accessCache:YES andMessageMap:nil];
    store.maskContainer = nil;
    store.disableAlert=YES;
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
        [self.totalLabel hideLoading];
        [self.carbonLabel hideLoading];
        [self.rankingLabel hideLoading];
        
        if (status == REMDataAccessFailed || status == REMDataAccessErrorMessage) {
            NSString *serverError;
            if (status == REMDataAccessFailed) {
                serverError=NSLocalizedString(@"Common_ServerTimeout", @"");
            }
            else{
                serverError=NSLocalizedString(@"Common_ServerError", @"");
            }
            [self.totalLabel setEmptyText:serverError];
            [self.carbonLabel setEmptyText:serverError];
            [self.rankingLabel setEmptyText:serverError];
            [self addDataLabel];
        }
        
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

- (REMDashboardObj *)dashboardInfoByPosition:(REMBuildingCoverWidgetPosition)position
{
    REMBuildingCoverWidgetRelationModel *currentRelation=nil;
    for (REMBuildingCoverWidgetRelationModel *relation in self.buildingInfo.widgetRelationArray) {
        if ([relation.buildingId isEqualToNumber:self.buildingInfo.building.buildingId] && [relation.commodityId isEqualToNumber:self.commodityInfo.commodityId] &&
            relation.position == position) {
            currentRelation = relation;
            break;
        }
    }
    if (currentRelation!=nil) {
        NSArray *array=self.buildingInfo.dashboardArray;
        for (REMDashboardObj *dashboard in array) {
            if ([dashboard.dashboardId isEqualToNumber:currentRelation.dashboardId]==YES) {
                return dashboard;
            }
        }
        if ([currentRelation.dashboardId isEqualToNumber:@(-1)]==YES) {
            REMDashboardObj *dashboard=[[REMDashboardObj alloc]init];
            dashboard.dashboardId=currentRelation.dashboardId;
            return dashboard;
        }
    }
    else{
        REMDashboardObj *dashboard=[[REMDashboardObj alloc]init];
        dashboard.dashboardId=@(-1);
        return dashboard;
    }
    return nil;
}

- (REMWidgetObject *)widgetInfoByPosition:(REMBuildingCoverWidgetPosition)position{
    REMBuildingCoverWidgetRelationModel *currentRelation;
    for (REMBuildingCoverWidgetRelationModel *relation in self.buildingInfo.widgetRelationArray) {
        if ([relation.buildingId isEqualToNumber:self.buildingInfo.building.buildingId] && [relation.commodityId isEqualToNumber:self.commodityInfo.commodityId] &&
            relation.position == position) {
            currentRelation = relation;
            break;
        }
    }
    if (currentRelation) {
        for (REMDashboardObj *dashboard in self.buildingInfo.dashboardArray) {
            if ([dashboard.dashboardId isEqualToNumber:currentRelation.dashboardId]==YES) {
                for (REMWidgetObject *widget in dashboard.widgets) {
                    if ([widget.widgetId isEqualToNumber:currentRelation.widgetId] && position == currentRelation.position) {
                        return widget;
                    }
                }
            }
        }
        if ([currentRelation.dashboardId isEqualToNumber:@(-1)]==YES) {
            REMWidgetObject *widget=[[REMWidgetObject alloc]init];
            widget.widgetId=currentRelation.widgetId;
            return widget;
        }
    }
    else{
        REMWidgetObject *widget=[[REMWidgetObject alloc]init];
        widget.dashboardId=@(-1);
        if (position == REMBuildingCoverWidgetPositionFirst) {
            widget.widgetId=@(-1);
        }
        else{
            widget.widgetId=@(-2);
        }
        
        return widget;
    }
    
    return nil;
}



- (NSDictionary *)dashboardArrayForPiningWidget{
    NSMutableArray *dashboardList = [NSMutableArray array];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    for (int i=0; i<self.buildingInfo.dashboardArray.count; ++i) {
        REMDashboardObj *dashboard = self.buildingInfo.dashboardArray[i];
        NSArray *widgetList = [dashboard trendWidgetArray];
        if (widgetList.count!=0) {
            [dashboardList addObject:dashboard];
            [dic setObject:widgetList forKey:dashboard.dashboardId];
        }
    }
    return  @{@"list":dashboardList,@"widget":dic};
}


- (NSString *)chartTitleByPosition:(REMBuildingCoverWidgetPosition)position
{
    REMWidgetObject *widgetInfo=[self widgetInfoByPosition:position];
    if (self.buildingInfo.widgetRelationArray==nil || widgetInfo==nil || [widgetInfo.widgetId isLessThan:@(0)]==YES) {
        NSString *title=NSLocalizedString(@"Building_EnergyUsageByAreaByMonth", @"");//单位面积逐月用%@
        if ([widgetInfo.widgetId isEqualToNumber:@(-1)]==YES) {
            title = NSLocalizedString(@"Building_EnergyUsageByAreaByMonth", @"");//单位面积逐月用%@
        }
        else if([widgetInfo.widgetId isEqualToNumber:@(-2)]==YES){
            title = NSLocalizedString(@"Building_EnergyUsageByCommodity", @"");//用%@趋势图
        }
        else{
            if (position == REMBuildingCoverWidgetPositionFirst) {
                title = NSLocalizedString(@"Building_EnergyUsageByAreaByMonth", @"");//单位面积逐月用%@
            }
            else{
                title = NSLocalizedString(@"Building_EnergyUsageByCommodity", @"");//用%@趋势图
            }
        }
        return [NSString stringWithFormat:title,self.commodityInfo.comment];

    }
    else{
        return widgetInfo.name;
    }
}


- (void)initChartContainer
{
    int marginTop=kBuildingCommodityTotalHeight+kBuildingCommodityDetailHeight+kBuildingDetailInnerMargin+kBuildingCommodityBottomMargin*2;
    int chartContainerHeight=kBuildingChartHeight;
    NSString *title1=[self chartTitleByPosition:REMBuildingCoverWidgetPositionFirst];
    
    UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, marginTop, kBuildingCommodityDetailWidth, kBuildingCommodityTitleFontSize)];
    titleLabel1.text=title1;
    titleLabel1.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    titleLabel1.shadowOffset=CGSizeMake(1, 1);
    
    titleLabel1.backgroundColor=[UIColor clearColor];
    titleLabel1.font = [UIFont fontWithName:@(kBuildingFontSC) size:kBuildingCommodityTitleFontSize];
    titleLabel1.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel1];
    self.firstChartTitleLabel=titleLabel1;
    UIImage *image=[UIImage imageNamed:@"ChartCustomization"];
    UIButton *firstButton=[UIButton buttonWithType:UIButtonTypeCustom];
    if (REMISIOS7) {
        firstButton=[UIButton buttonWithType:UIButtonTypeSystem];
        firstButton.tintColor=[UIColor whiteColor];
    }
    else{
        firstButton.showsTouchWhenHighlighted=YES;
    }
    
    [firstButton setImage:image forState:UIControlStateNormal];
    [firstButton setFrame:CGRectMake(kBuildingChartWidth-40, marginTop, 32, 32)];
    firstButton.tag=0;
    [firstButton addTarget:self action:@selector(widgetRelationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:firstButton];
    
    
    if (self.childViewControllers.count<2) {
        REMBuildingChartContainerViewController *controller1=[self chartContainerControllerByPosition:REMBuildingCoverWidgetPositionFirst];
        controller1.viewFrame=CGRectMake(0, marginTop+kBuildingCommodityTitleFontSize+kBuildingDetailInnerMargin, kBuildingChartWidth, chartContainerHeight-kBuildingCommodityTitleFontSize-kBuildingDetailInnerMargin);
        [self addChildViewController:controller1];
    }
   
    
    int marginTop1=marginTop+chartContainerHeight+kBuildingCommodityBottomMargin;
    CGFloat secondChartHeight=chartContainerHeight;
    NSString *title2=[self chartTitleByPosition:REMBuildingCoverWidgetPositionSecond];
    
    UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, marginTop1, kBuildingCommodityDetailWidth, kBuildingCommodityTitleFontSize)];
    titleLabel2.text=title2;
    titleLabel2.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    titleLabel2.shadowOffset=CGSizeMake(1, 1);
    
    titleLabel2.backgroundColor=[UIColor clearColor];
    titleLabel2.font = [UIFont fontWithName:@(kBuildingFontSC) size:kBuildingCommodityTitleFontSize];
    titleLabel2.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel2];
    self.secondChartTitleLabel=titleLabel2;
    UIButton *secondButton=[UIButton buttonWithType:UIButtonTypeCustom];
    if (REMISIOS7) {
        secondButton=[UIButton buttonWithType:UIButtonTypeSystem];
        secondButton.tintColor=[UIColor whiteColor];
    }
    else{
        secondButton.showsTouchWhenHighlighted=YES;
    }
    [secondButton setImage:image forState:UIControlStateNormal];
    [secondButton setFrame:CGRectMake(kBuildingChartWidth-40, marginTop1, 32, 32)];
    secondButton.tag=1;
    [secondButton addTarget:self action:@selector(widgetRelationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:secondButton];

    if (self.childViewControllers.count<2) {
        REMBuildingChartContainerViewController *controller2=[self chartContainerControllerByPosition:REMBuildingCoverWidgetPositionSecond];
        controller2.viewFrame=CGRectMake(0, marginTop1+kBuildingCommodityTitleFontSize+kBuildingDetailInnerMargin, kBuildingChartWidth, secondChartHeight-kBuildingCommodityTitleFontSize-kBuildingDetailInnerMargin);
        [self addChildViewController:controller2];
    
    }
    
    
}


- (REMBuildingChartContainerViewController *)chartContainerControllerByPosition:(REMBuildingCoverWidgetPosition)position{
    REMBuildingChartContainerViewController *controller=[[REMBuildingChartContainerViewController alloc] init];
    REMWidgetObject *widget=[self widgetInfoByPosition:position];
    if ([widget.widgetId isLessThan:@(0)]==YES) {
        if ([widget.widgetId isEqualToNumber:@(-1)]==YES) {
            controller.chartHandlerClass=[REMBuildingAverageViewController class];
        }
        else{
            controller.chartHandlerClass=[REMBuildingTrendChartViewController class];
        }
    }
    else{
        controller.chartHandlerClass=[REMBuildingWidgetChartViewController class];
    }
    controller.buildingId=self.buildingInfo.building.buildingId;
    controller.commodityId=self.commodityInfo.commodityId;
    controller.widgetInfo=widget;
    return controller;
}



- (void)widgetRelationButtonClicked:(UIButton *)button{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];

    UINavigationController *nav= [storyboard instantiateViewControllerWithIdentifier:@"buildingWidgetNavigation"];
    nav.navigationBar.translucent=NO;
    REMBuildingCoverWidgetViewController *coverRelationController= nav.childViewControllers[0];
    coverRelationController.position=(REMBuildingCoverWidgetPosition)button.tag;
    coverRelationController.buildingInfo=self.buildingInfo;
    coverRelationController.commodityInfo=self.commodityInfo;
    NSDictionary *dic=[self dashboardArrayForPiningWidget];
    coverRelationController.dashboardArray=dic[@"list"];
    coverRelationController.widgetDic=dic[@"widget"];
    coverRelationController.commodityController=self;
    REMDashboardObj *dashboard=[self dashboardInfoByPosition:coverRelationController.position];
    REMWidgetObject *widget=[self widgetInfoByPosition:coverRelationController.position];
    
    coverRelationController.selectedWidgetId=widget.widgetId;
    coverRelationController.selectedDashboardId=dashboard.dashboardId;
    
    UIPopoverController *popController= [[UIPopoverController alloc]initWithContentViewController:nav];
    coverRelationController.popController=popController;
    popController.delegate=self;
    popController.popoverContentSize=CGSizeMake(350, 400);
    self.popController=popController;
    [popController presentPopoverFromRect:button.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    UINavigationController *nav= (UINavigationController *)popoverController.contentViewController;
    REMBuildingCoverWidgetViewController *widgetController=nav.childViewControllers[0];
    if (widgetController.isRequesting==NO) {
        self.popController=nil;
    }
}

- (void)updateChartController{
    UINavigationController *nav= (UINavigationController *)self.popController.contentViewController;
    REMBuildingCoverWidgetViewController *widgetController=nav.childViewControllers[0];
    REMBuildingChartContainerViewController *containerController;
    REMBuildingChartContainerViewController *otherContainer;
    REMWidgetObject *otherWidget;
    REMBuildingChartContainerViewController *firstController=self.childViewControllers[0];
    REMBuildingChartContainerViewController *secondController=self.childViewControllers[1];
    if (widgetController.position == REMBuildingCoverWidgetPositionFirst) {
        self.firstChartTitleLabel.text=[self chartTitleByPosition:REMBuildingCoverWidgetPositionFirst];
        containerController = [self chartContainerControllerByPosition:REMBuildingCoverWidgetPositionFirst];
        
        containerController.viewFrame=firstController.viewFrame;
        otherContainer=self.childViewControllers[1];
        otherWidget=[self widgetInfoByPosition:REMBuildingCoverWidgetPositionSecond];
        
        if ([secondController.widgetInfo.widgetId isEqualToNumber:otherContainer.widgetInfo.widgetId]==NO) {
            self.secondChartTitleLabel.text=[self chartTitleByPosition:REMBuildingCoverWidgetPositionSecond];
            otherContainer=[self chartContainerControllerByPosition:REMBuildingCoverWidgetPositionSecond];
            otherContainer.viewFrame=secondController.viewFrame;
        }
        
        [firstController removeFromParentViewController];
        if (firstController.isViewLoaded==YES) {
            [firstController.view removeFromSuperview];
            [self.view addSubview: containerController.view];
        }
        
        
        [secondController removeFromParentViewController];
        if ([secondController isEqual:otherContainer]==NO && secondController.isViewLoaded==YES) {
            [secondController.view removeFromSuperview];
            [self.view addSubview:otherContainer.view];
        }
        
        [self addChildViewController:containerController];
        [self addChildViewController:otherContainer];
        
    }
    else{
        self.secondChartTitleLabel.text=[self chartTitleByPosition:REMBuildingCoverWidgetPositionSecond];
        containerController = [self chartContainerControllerByPosition:REMBuildingCoverWidgetPositionSecond];
        containerController.viewFrame=secondController.viewFrame;
        otherContainer=self.childViewControllers[0];
        otherWidget=[self widgetInfoByPosition:REMBuildingCoverWidgetPositionFirst];
        
        if ([firstController.widgetInfo.widgetId isEqualToNumber:otherContainer.widgetInfo.widgetId]==NO) {
            self.firstChartTitleLabel.text=[self chartTitleByPosition:REMBuildingCoverWidgetPositionFirst];
            otherContainer=[self chartContainerControllerByPosition:REMBuildingCoverWidgetPositionFirst];
            otherContainer.viewFrame=firstController.viewFrame;
        }
        
        [firstController removeFromParentViewController];
        [secondController removeFromParentViewController];
        [self addChildViewController:otherContainer];
        [self addChildViewController:containerController];
        
        if ([otherContainer isEqual:firstController]==NO && firstController.isViewLoaded==YES) {
            [otherContainer.view removeFromSuperview];
            [self.view addSubview:otherContainer.view];
        }
        if (secondController.isViewLoaded==YES) {
            [secondController.view removeFromSuperview];
            [self.view addSubview:containerController.view];
        }
        
    }
    self.popController=nil;
}

- (void)showChart{
    
    for (int i=0; i<self.childViewControllers.count; ++i) {
        REMBuildingChartContainerViewController *controller=self.childViewControllers[i];
        if(controller.isViewLoaded==NO){
            [self.view addSubview:controller.view];
        }
    }

}



@end
