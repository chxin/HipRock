//
//  REMEnergyUsageDataModel.h
//  Blues
//
//  Created by 张 锋 on 8/1/13.
//
//

#import <Foundation/Foundation.h>
#import "REMEnergyData.h"
#import "REMUomModel.h"
#import "REMCommonHeaders.h"

@interface REMEnergyUsageDataModel : REMJSONObject

@property (nonatomic,strong) NSNumber *dataValue;

@property (nonatomic) REMEnergyDataQuality dataQuality;

@property (nonatomic,strong) REMUomModel *uom;

@end
