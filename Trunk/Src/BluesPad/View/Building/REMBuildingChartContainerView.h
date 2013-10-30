//
//  REMBuildingChartContainerView.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 8/9/13.
//
//

#import "REMBuildingTitleView.h"
#import "REMBuildingConstants.h"
#import "REMBuildingChartHandler.h"
#import "REMAverageUsageDataModel.h"



@interface REMBuildingChartContainerView : REMBuildingTitleView

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title andTitleFontSize:(CGFloat)size;

- (void)requireChartDataWithBuildingId:(NSNumber *)buildingId withCommodityId:(NSNumber *)commodityId withEnergyData:(REMAverageUsageDataModel *)averageData complete:(void(^)(BOOL))callback;

@property (nonatomic,strong) UIView *chartContainer;

@property (nonatomic,strong) REMBuildingChartHandler *controller;

@end
