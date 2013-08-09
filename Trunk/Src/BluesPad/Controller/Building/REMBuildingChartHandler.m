//
//  REMBuildingChartHandler.m
//  Blues
//
//  Created by 张 锋 on 8/9/13.
//
//

#import "REMBuildingChartHandler.h"

@interface REMBuildingChartHandler ()

@end

@implementation REMBuildingChartHandler


- (REMBuildingChartHandler *)initWithViewFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        // Custom initialization
        //[self.view setFrame:frame];
        //[self viewDidLoad];
    }
    return self;
}

- (void)loadData:(long long)buildingId :(long long)commodityID :(REMEnergyViewData *)buildingOverall :(void (^)(void))loadCompleted
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
