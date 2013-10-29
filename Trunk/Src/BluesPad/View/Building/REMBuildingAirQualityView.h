//
//  REMBuildingAirQualityView.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 8/22/13.
//
//

#import "REMBuildingCommodityView.h"
#import "REMAirQualityModel.h"
#import "REMBuildingTitleLabelView.h"
#import "REMBuildingChartContainerView.h"
#import "REMBuildingAirQualityChartHandler.h"



@interface REMBuildingAirQualityView : REMBuildingCommodityView

- (id)initWithFrame:(CGRect)frame withAirQualityInfo:(REMAirQualityModel *)airQualityInfo;


@end
