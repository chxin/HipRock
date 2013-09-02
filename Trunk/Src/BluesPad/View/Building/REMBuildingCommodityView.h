//
//  REMBuildingCommodityView.h
//  Blues
//
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

@interface REMBuildingCommodityView : UIView//UIScrollView

- (id)initWithFrame:(CGRect)frame withCommodityInfo:(REMCommodityUsageModel *)commodityInfo;

- (void)addSplitBar:(UIView *)view;

- (void)replaceChart:(BOOL)showReal;

- (void)requireChartDataWithBuildingId:(NSNumber *)buildingId withCommodityId:(NSNumber *)commodityId complete:(void(^)(BOOL))callback;

@end
