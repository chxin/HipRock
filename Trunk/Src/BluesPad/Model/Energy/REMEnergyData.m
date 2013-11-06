/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEnergyData.m
 * Created      : TanTan on 7/1/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMEnergyData.h"
#import "REMTimeHelper.h"

@implementation REMEnergyData

- (id)initWithArray:(NSArray *)array
{
    self = [super init];
    if(self){
        long long time= [((NSNumber *)array[0]) longLongValue];
        self.localTime = [[NSDate alloc]initWithTimeIntervalSince1970:time];
        
        
        NSNumber *value = array[1];
        NSNumber *quality=0;
        if(array.count>=3){
            quality=array[2];
        }
        
        self.quality = (REMEnergyDataQuality)[quality intValue];
        
        self.dataValue = value;
    }
    
    return self;
}

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    //NSNumber *num = dictionary[@"LocalTime"];
    
    long long time= [REMTimeHelper longLongFromJSONString:dictionary[@"LocalTime"]]/1000;
    self.localTime = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    self.quality = (REMEnergyDataQuality)[dictionary[@"DataQuality"] intValue];
    
    NSNumber *value = dictionary[@"DataValue"];
    
    self.dataValue = value;
}


@end
