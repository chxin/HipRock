/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEnergyUsageDataModel.m
 * Created      : 张 锋 on 8/1/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMEnergyUsageDataModel.h"
#import "REMUomModel.h"

@implementation REMEnergyUsageDataModel

-(instancetype)initWithDataValue:(NSNumber *)value andUomCode:(NSString *)uomCode
{
    self = [super init];
    
    if(self){
        self.dataValue = value;
        self.uom = [[REMUomModel alloc] init];
        self.uom.code = uomCode;
    }
    
    return self;
}

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.dataValue = dictionary[@"DataValue"];
    self.dataQuality = [dictionary[@"DataQuality"] intValue];
    self.uom = [[REMUomModel alloc] initWithDictionary:dictionary[@"Uom"]];
}

@end
