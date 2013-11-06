/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMAirQualityModel.m
 * Created      : tantan on 8/22/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMAirQualityModel.h"

@implementation REMAirQualityModel

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.commodity = [[REMCommodityModel alloc] initWithDictionary:dictionary[@"AirQualityCommodity"]];
    
    self.outdoor=[[REMEnergyUsageDataModel alloc]initWithDictionary:dictionary[@"OutdoorData"]];
    self.mayair=[[REMEnergyUsageDataModel alloc]initWithDictionary:dictionary[@"MayAirData"]];
    self.honeywell=[[REMEnergyUsageDataModel alloc]initWithDictionary:dictionary[@"HoneywellData"]];
}

@end
