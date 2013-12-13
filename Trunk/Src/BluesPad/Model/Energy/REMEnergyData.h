/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEnergyData.h
 * Created      : TanTan on 7/1/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
