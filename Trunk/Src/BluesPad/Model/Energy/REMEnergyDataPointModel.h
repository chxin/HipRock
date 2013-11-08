/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEnergyDataPointModel.h
 * Date Created : 张 锋 on 11/7/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <Foundation/Foundation.h>
#import "REMEnergyData.h"

@interface REMEnergyDataPointModel : NSObject

@property (nonatomic,strong) NSNumber *identity;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) UIColor *color;
@property (nonatomic,strong) REMEnergyData *dataValue;

@end
