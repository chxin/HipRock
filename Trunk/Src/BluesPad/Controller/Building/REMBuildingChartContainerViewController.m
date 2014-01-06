/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingChartViewController.m
 * Date Created : tantan on 11/12/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMBuildingChartContainerViewController.h"
#import "REMBuildingTrendChartViewController.h"
#import "REMBuildingAverageChartViewController.h"
#import "REMBuildingAirQualityChartViewController.h"
#import "REMBuildingCommodityViewController.h"
#import "REMBuildingChartContainerView2.h"

@interface REMBuildingChartContainerViewController ()

//@property (nonatomic,strong) REMEnergyViewData *energyData;
//@property (nonatomic,strong) REMBuildingChartHandler *chartHandler;
@end

@implementation REMBuildingChartContainerViewController


-(void)loadView{
    self.view=[[REMBuildingChartContainerView2 alloc]initWithFrame:self.viewFrame];
    //self.view.layer.borderColor=[UIColor redColor].CGColor;
    //self.view.layer.borderWidth=1;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //[self initTitle];
    [self initChartContainer];
}

- (void)requestData:(REMBuildingChartBaseViewController *)handler
{
    [handler loadData:[self.buildingId longLongValue]  :[self.commodityId longLongValue] :nil :^(id data,REMBusinessErrorInfo *error){
        if(error==nil){
            REMBuildingCommodityViewController *parent=(REMBuildingCommodityViewController *)self.parentViewController;
            [parent loadChartComplete];
        }
    }];
}


- (void)initChartContainer
{
    //UIView *chartContainer= [[UIView alloc]initWithFrame:self.viewFrame];
    //NSLog(@"chartcontainer:%@",NSStringFromCGRect(chartContainer.frame));
    //chartContainer.layer.borderColor=[UIColor redColor].CGColor;
    //chartContainer.layer.borderWidth=1;
    //[self.view addSubview:chartContainer];
    
    if (self.childViewControllers.count==0) {
        REMBuildingChartBaseViewController *handler=[[self.chartHandlerClass alloc]initWithViewFrame:self.view.bounds];
        handler.widgetInfo=self.widgetInfo;
        [self.view addSubview:handler.view];
        //handler.view.layer.borderColor=[UIColor redColor].CGColor;
        //handler.view.layer.borderWidth=1;
        [self requestData:handler];
        [self addChildViewController:handler];
        
        
    }
    else{
        REMBuildingChartBaseViewController *handler=(REMBuildingChartBaseViewController *)self.childViewControllers[0];
        [self.view addSubview:handler.view];
        REMBuildingCommodityViewController *parent=(REMBuildingCommodityViewController *)self.parentViewController;
        [parent loadChartComplete];
    }
}


@end
