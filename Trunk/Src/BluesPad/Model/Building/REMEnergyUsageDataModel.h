//
//  REMEnergyUsageDataModel.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
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
