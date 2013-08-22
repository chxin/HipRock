//
//  REMBuildingAirQualityView.h
//  Blues
//
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
