//
//  REMEnergyData.h
//  Blues
//
//  Created by TanTan on 7/1/13.
//
//

#import <Foundation/Foundation.h>
#import "REMJSONObject.h"

typedef enum _REMEnergyDataQuality:NSUInteger
{
    REMEnergyDataQualityGood=0
} REMEnergyDataQuality;

@interface REMEnergyData : REMJSONObject

- (id)initWithArray:(NSArray *)array;

@property (nonatomic,strong) NSDate *localTime;

@property (nonatomic,strong) NSNumber *dataValue;

@property (nonatomic) REMEnergyDataQuality quality;


@end
