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


@interface REMBuildingCommodityView : UIView

- (id)initWithFrame:(CGRect)frame withCommodityInfo:(REMCommodityUsageModel *)commodityInfo;


- (void)requireChartDataWithBuildingId:(NSNumber *)buildingId withCommodityId:(NSNumber *)commodityId;

@end
