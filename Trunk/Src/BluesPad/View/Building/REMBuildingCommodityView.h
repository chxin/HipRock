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

@interface REMBuildingCommodityView : UIView

- (id)initWithFrame:(CGRect)frame withCommodityInfo:(REMCommodityUsageModel *)commodityInfo;

@end
