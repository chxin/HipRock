/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMAverageUsageDataModel.h
 * Created      : 张 锋 on 8/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMEnergyViewData.h"

@interface REMAverageUsageDataModel : REMJSONObject

@property (nonatomic,strong) REMEnergyViewData *unitData;
@property (nonatomic,strong) REMEnergyViewData *benchmarkData;


@end
