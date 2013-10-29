//
//  REMBuildingCommodityView.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 8/6/13.
//
//

#import <UIKit/UIKit.h>
#import "REMBuildingTitleView.h"
#import "REMBuildingTitleLabelView.h"
#import "REMNumberLabel.h"
#import "REMCommodityUsageModel.h"
#import "REMBuildingConstants.h"
#import "REMBuildingRankingView.h"
#import "REMBuildingChartContainerView.h"
#import "REMBuildingAverageChartHandler.h"
#import "REMBuildingTrendChartHandler.h"
#import "REMBuildingOverallModel.h"

@interface REMBuildingCommodityView : UIView//UIScrollView

@property (nonatomic,strong) NSArray *chartViewArray;

- (id)initWithFrame:(CGRect)frame withCommodity:(REMCommodityModel *)commodity withBuildingInfo:(REMBuildingOverallModel *)buildingInfo;

- (void)addSplitBar:(UIView *)view;

- (void)replaceChart:(BOOL)showReal;

-(void)prepareShare;

-(void)loadTotalUsageByBuildingId:(NSNumber *)buildingId ByCommodityId:(NSNumber *)commodityId;

- (void)requireChartDataWithBuildingId:(NSNumber *)buildingId withCommodityId:(NSNumber *)commodityId complete:(void(^)(BOOL))callback;

@end
