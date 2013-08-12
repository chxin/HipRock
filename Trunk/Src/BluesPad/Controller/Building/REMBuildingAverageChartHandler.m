//
//  REMBuildingAverageChartHandler.m
//  Blues
//
//  Created by 张 锋 on 8/9/13.
//
//

#import <QuartzCore/QuartzCore.h>
#import "REMBuildingAverageChartHandler.h"
#import "REMBuildingAverageChart.h"
#import "REMEnergyViewData.h"
#import "REMCommodityUsageModel.h"
#import "CorePlot-CocoaTouch.h"

@interface REMBuildingAverageChartHandler ()

@property (nonatomic) CGRect viewFrame;
@property (nonatomic,strong) REMBuildingAverageChart *chartView;
@property (nonatomic,strong) NSArray *chartData;
@property (nonatomic,strong) REMEnergyViewData *averageData;
@property (nonatomic,strong) REMEnergyViewData *benchmarkData;


@end

@implementation REMBuildingAverageChartHandler


- (REMBuildingChartHandler *)initWithViewFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.viewFrame = frame;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view = [[REMBuildingAverageChart alloc] initWithFrame:self.viewFrame];
    
    [self viewDidLoad];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.layer.borderColor = [UIColor redColor].CGColor;
    self.view.layer.borderWidth = 1.0;
    self.view.backgroundColor = [UIColor yellowColor];
}

- (void)loadData:(long long)buildingId :(long long)commodityID :(REMAverageUsageDataModel *)averageData :(void (^)(void))loadCompleted
{
    //convert data
    self.chartData = [self convertData];
    //initialize plot space
    //initialize axises
    //initialize plots
    
}

- (NSArray *)convertData
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
