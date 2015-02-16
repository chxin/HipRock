/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingAirQualityPersistenceProcessor.m
 * Date Created : 张 锋 on 4/1/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMBuildingAirQualityPersistenceProcessor.h"

@implementation REMBuildingAirQualityPersistenceProcessor


- (id)persist:(NSDictionary *)dictionary
{
//    self.airQualityModel.commodityId = @(12);//commodity[@"Id"];
    
    if(REMIsNilOrNull(dictionary)){
        return self.airQualityModel;
    }
    
    
//    NSDictionary *commodity = dictionary[@"AirQualityCommodity"];
    NSDictionary *honeywell = dictionary[@"HoneywellData"];
    NSDictionary *mayair = dictionary[@"MayAirData"];
    NSDictionary *outdoor = dictionary[@"OutdoorData"];
    
//    if(REMIsNilOrNull(commodity) && REMIsNilOrNull(honeywell) && REMIsNilOrNull(mayair) && REMIsNilOrNull(outdoor)){
//        return nil;
//    }
    
//    self.airQualityModel.commodityCode = REMIsNilOrNull(commodity)?nil:commodity[@"Code"] ;
//    self.airQualityModel.commodityId = @(12);//commodity[@"Id"];
//    self.airQualityModel.commodityName = REMIsNilOrNull(commodity)?nil:NULL_TO_NIL(commodity[@"Name"]);
    
    if(!REMIsNilOrNull(honeywell)){
        NSDictionary *uom = honeywell[@"Uom"];
        
        self.airQualityModel.honeywellUom = uom[@"Code"];
        self.airQualityModel.honeywellValue = honeywell[@"DataValue"];
    }
    
    if(!REMIsNilOrNull(mayair)){
        NSDictionary *uom = mayair[@"Uom"];
        
        self.airQualityModel.mayairUom = uom[@"Code"];
        self.airQualityModel.mayairValue = mayair[@"DataValue"];
    }
    
    if(!REMIsNilOrNull(outdoor)){
        NSDictionary *uom = outdoor[@"Uom"];
        
        self.airQualityModel.outdoorUom = uom[@"Code"];
        self.airQualityModel.outdoorValue = outdoor[@"DataValue"];
    }
    
    [self save];
    
    return self.airQualityModel;
}

- (id)fetch
{
    return self.airQualityModel;
}

@end
