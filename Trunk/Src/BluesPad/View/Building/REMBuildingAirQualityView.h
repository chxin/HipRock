/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingAirQualityView.h
 * Created      : tantan on 8/22/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMBuildingCommodityView.h"
#import "REMAirQualityModel.h"
#import "REMBuildingTitleLabelView.h"

#import "REMBuildingAirQualityChartViewController.h"



@interface REMBuildingAirQualityView : REMBuildingCommodityView

- (id)initWithFrame:(CGRect)frame withAirQualityInfo:(REMAirQualityModel *)airQualityInfo;


@end
