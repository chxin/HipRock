/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEnergyUsageDataModel.h
 * Created      : 张 锋 on 8/1/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMEnergyData.h"
#import "REMUomModel.h"
#import "REMCommonHeaders.h"

@interface REMEnergyUsageDataModel : REMJSONObject

@property (nonatomic,strong) NSNumber *dataValue;

@property (nonatomic) REMEnergyDataQuality dataQuality;

@property (nonatomic,strong) REMUomModel *uom;

@end
