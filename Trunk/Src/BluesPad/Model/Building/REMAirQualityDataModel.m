//
//  REMAirQualityDataModel.m
//  Blues
//
//  Created by 张 锋 on 8/23/13.
//
//

#import "REMAirQualityDataModel.h"

@implementation REMAirQualityDataModel

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.airQualityData = [[REMEnergyViewData alloc] initWithDictionary:dictionary[@"AirQualityData"]];
    
    NSMutableArray *standardArray = [[NSMutableArray alloc] init];
    for(NSDictionary *item in (NSArray *)dictionary[@"Standards"])
    {
        [standardArray addObject:[[REMAirQualityStandardModel alloc] initWithDictionary:item]];
    }
    
    self.standards = standardArray;
}

@end

@implementation REMAirQualityStandardModel

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.standardName = dictionary[@"StandardName"];
    self.standardValue = dictionary[@"StandardValue"];
    self.uom = dictionary[@"Uom"];
}

@end
