//
//  REMEnergyData.m
//  Blues
//
//  Created by TanTan on 7/1/13.
//
//

#import "REMEnergyData.h"
#import "REMTimeHelper.h"

@implementation REMEnergyData

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    //NSNumber *num = dictionary[@"LocalTime"];
    
    long long time= [REMTimeHelper longLongFromJSONString:dictionary[@"LocalTime"]]/1000;
    self.localTime = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    self.quality = (REMEnergyDataQuality)[dictionary[@"DataQuality"] intValue];
    
    NSNumber *value = dictionary[@"DataValue"];
    
    self.dataValue = [value decimalValue];
}


@end
