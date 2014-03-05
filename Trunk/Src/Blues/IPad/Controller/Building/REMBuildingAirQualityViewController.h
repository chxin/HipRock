/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingAirQualityViewController.h
 * Date Created : tantan on 11/11/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMBuildingCommodityViewController.h"

@interface REMBuildingAirQualityViewController : UIViewController

@property (nonatomic,weak) REMManageBuildingAirQualityModel *airQualityInfo;
@property (nonatomic) CGRect viewFrame;
@property (nonatomic,weak) REMManagedBuildingModel *buildingInfo;
@property (nonatomic,strong) REMAirQualityModel *airQualityUsage;
@property (nonatomic) BOOL dataLoadComplete;
@property (nonatomic) NSUInteger index;
- (void) showChart;
- (void)loadChartComplete;
@end
