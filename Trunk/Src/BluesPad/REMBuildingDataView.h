//
//  REMBuildingDataView.h
//  TestImage
//
//  Created by tantan on 7/31/13.
//  Copyright (c) 2013 demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REMBuildingCommodityView.h"
#import "REMNumberLabel.h"
#import "REMBuildingOverallModel.h"
#import "REMCommodityUsageModel.h"

@interface REMBuildingDataView : UIView

- (id)initWithFrame:(CGRect)frame withBuildingInfo:(REMBuildingOverallModel *)buildingInfo;

@end
