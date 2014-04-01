/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingAirQualityPersistenceProcessor.h
 * Date Created : 张 锋 on 4/1/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMDataPersistenceProcessor.h"
#import "REMManagedBuildingAirQualityModel.h"

@interface REMBuildingAirQualityPersistenceProcessor : REMDataPersistenceProcessor

@property (nonatomic,weak) REMManagedBuildingAirQualityModel *airQualityModel;

@end
