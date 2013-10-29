//
//  REMCommodityModel.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 8/1/13.
//
//

#import "REMCommodityModel.h"

@implementation REMCommodityModel

static NSString *_systemCommodityJson = @"["
"{\"Code\" : \"Other\",\"Comment\" : \"其他\",\"Id\" : 0,},"
"{\"Code\" : \"Electricity\",\"Comment\" : \"电\",\"Id\" : 1,},"
"{\"Code\" : \"Water\",\"Comment\" : \"自来水\",\"Id\" : 2,},"
"{\"Code\" : \"Gas\",\"Comment\" : \"天然气\",\"Id\" : 3,},"
"{\"Code\" : \"SoftWater\",\"Comment\" : \"软水\",\"Id\" : 4,},"
"{\"Code\" : \"Petrol\",\"Comment\" : \"汽油\",\"Id\" : 5,},"
"{\"Code\" : \"LowPressureSteam\",\"Comment\" : \"低压蒸汽\",\"Id\" : 6,},"
"{\"Code\" : \"DieselOil\",\"Comment\" : \"柴油\",\"Id\" : 7,},"
"{\"Code\" : \"HeatQ\",\"Comment\" : \"热量\",\"Id\" : 8,},"
"{\"Code\" : \"CoolQ\",\"Comment\" : \"冷量\",\"Id\" : 9,},"
"{\"Code\" : \"Coal\",\"Comment\" : \"煤\",\"Id\" : 10,},"
"{\"Code\" : \"CoalOil\",\"Comment\" : \"煤油\",\"Id\" : 11,},"
"{\"Code\" : \"AirQuality\",\"Comment\" : \"空气质量\",\"Id\" : 12,}]";
static NSMutableDictionary *_systemCommodities;

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.commodityId = dictionary[@"Id"];
    self.name = dictionary[@"Name"];
    self.code = dictionary[@"Code"];
    self.comment = dictionary[@"Comment"];
}


+(NSDictionary *)systemCommodities
{
    if(_systemCommodities == nil){
        _systemCommodities = [[NSMutableDictionary alloc] init];
        NSArray *array = [REMJSONHelper objectByString:_systemCommodityJson];
        for(NSDictionary *item in array){
            REMCommodityModel *commodity = [[REMCommodityModel alloc] initWithDictionary:item];
            
            [_systemCommodities setObject:commodity forKey:commodity.commodityId];
        }
    }
    
    return _systemCommodities;
}

@end
