//
//  REMAirQualityModel.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 8/22/13.
//
//

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
