/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingCommodityViewController.h
 * Date Created : tantan on 11/11/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "REMBuildingOverallModel.h"
#import "REMCommodityUsageModel.h"
#import "REMBuildingTitleView.h"
#import "REMBuildingTitleLabelView.h"
#import "REMBuildingRankingView.h"
#import "REMBuildingChartContainerView.h"

@interface REMBuildingCommodityViewController : UIViewController

@property (nonatomic,weak) REMCommodityModel *commodityInfo;
@property (nonatomic,weak) REMBuildingOverallModel *buildingInfo;
@property (nonatomic) CGRect viewFrame;

@property (nonatomic) BOOL dataLoadComplete;
@property (nonatomic) NSUInteger index;

- (void) showChart;
- (void)loadChartComplete;
@end
