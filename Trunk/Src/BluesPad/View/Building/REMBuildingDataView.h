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
#import "REMBuildingConstants.h"
#import "REMBuildingAirQualityView.h"

@interface REMBuildingDataView : UIScrollView//<UIScrollViewDelegate>

@property (nonatomic,weak) UIButton *shareButton;

@property (nonatomic) BOOL isUpScroll;

- (id)initWithFrame:(CGRect)frame withBuildingInfo:(REMBuildingOverallModel *)buildingInfo;



- (void)requireChartDataWithBuildingId:(NSNumber *)buildingId complete:(void(^)(BOOL))callback;

- (void)cancelAllRequest;

-(void)prepareShare;

- (void)exportDataView:(void(^)(NSDictionary *))success;

- (void)resetDefaultCommodity;

-(void)replaceImagesShowReal:(BOOL)showReal;

- (void)showDashboardLabel:(BOOL)overThreshold;

@end
