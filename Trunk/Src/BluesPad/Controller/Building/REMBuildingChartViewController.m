/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingChartViewController.m
 * Date Created : tantan on 11/12/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMBuildingChartViewController.h"
#import "REMBuildingTrendChartViewController.h"
#import "REMBuildingAverageChartViewController.h"
#import "REMBuildingAirQualityChartViewController.h"
#import "REMBuildingCommodityViewController.h"


@interface REMBuildingChartViewController ()

@property (nonatomic,strong) REMEnergyViewData *energyData;
//@property (nonatomic,strong) REMBuildingChartHandler *chartHandler;
@end

@implementation REMBuildingChartViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //[self initTitle];
    [self initChartContainer];
}


- (void)dealloc{
    //REMBuildingChartBaseViewController *chartHandler=  self.childViewControllers[0];
    //[chartHandler purgeMemory];
    //[chartHandler removeFromParentViewController];
}

- (void)initChartContainer
{
    UIView *chartContainer= [[UIView alloc]initWithFrame:self.viewFrame];
    //NSLog(@"chartcontainer:%@",NSStringFromCGRect(chartContainer.frame));
    //chartContainer.layer.borderColor=[UIColor redColor].CGColor;
    //chartContainer.layer.borderWidth=1;
    [self.view addSubview:chartContainer];
    
    if (self.energyData==nil) {
        REMBuildingChartBaseViewController *handler=[[self.chartHandlerClass alloc]initWithViewFrame:chartContainer.frame];
        [self.view addSubview:handler.view];
        [handler loadData:[self.buildingId longLongValue]  :[self.commodityId longLongValue] :nil :^(REMError *error){
            if(error==nil){
                REMBuildingCommodityViewController *parent=(REMBuildingCommodityViewController *)self.parentViewController;
                [parent loadChartComplete];
            }
        }];
        [self addChildViewController:handler];
        
    }
    else{
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
