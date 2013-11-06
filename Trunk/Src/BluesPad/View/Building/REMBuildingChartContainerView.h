/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingChartContainerView.h
 * Created      : tantan on 8/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
