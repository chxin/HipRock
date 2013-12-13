/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTargetEnergyData.h
 * Created      : 谭 坦 on 7/16/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMEnergyTargetModel.h"
#import "REMEnergyData.h"

@interface REMTargetEnergyData : REMJSONObject

@property (nonatomic,strong) REMEnergyTargetModel *target;

@property (nonatomic,strong) NSArray *energyData;

@end
