/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingAirQualityViewController.h
 * Date Created : tantan on 11/11/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMBuildingCommodityViewController.h"

@interface REMBuildingAirQualityViewController : REMBuildingCommodityViewController

@property (nonatomic,weak) REMAirQualityModel *airQualityInfo;
@property (nonatomic) CGRect viewFrame;


@end
