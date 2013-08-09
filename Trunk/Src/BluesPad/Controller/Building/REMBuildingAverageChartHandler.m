//
//  REMBuildingAverageChartHandler.m
//  Blues
//
//  Created by 张 锋 on 8/9/13.
//
//

#import "REMBuildingAverageChartHandler.h"
#import "REMBuildingAverageChart.h"
#import "REMEnergyViewData.h"
#import "REMCommodityUsageModel.h"

@interface REMBuildingAverageChartHandler ()

@end

@implementation REMBuildingAverageChartHandler


- (REMBuildingChartHandler *)initWithViewFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.view = [[REMBuildingAverageChart alloc] initWithFrame:frame];
        [self viewDidLoad];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)loadData:(long long)buildingId :(long long)commodityID :(REMBuildingOverallModel *)buildingOverall :(void (^)(void))loadCompleted
{
    REMCommodityUsageModel *commodityUsage = [self getAverageUsageData:commodityID :buildingOverall];
    
}
- (REMCommodityUsageModel *)getAverageUsageData:(long long)commodityID :(REMBuildingOverallModel *)buildingOverall
{
    for(REMCommodityUsageModel *commodityUsage in buildingOverall.commodityUsage){
        if(commodityUsage.commodity != nil && [commodityUsage.commodity.commodityId longLongValue] == commodityID){
            return commodityUsage;
        }
    }
    
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
