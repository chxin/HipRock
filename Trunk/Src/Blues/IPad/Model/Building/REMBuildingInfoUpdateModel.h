/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingInfoUpdateModel.h
 * Date Created : 张 锋 on 3/24/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <Foundation/Foundation.h>
#import "REMUpdateAllManager.h"

@interface REMBuildingInfoUpdateModel : REMJSONObject

@property (nonatomic,strong) NSArray *buildingInfo;
@property (nonatomic,strong) NSArray *customers;
@property (nonatomic) REMCustomerUserConcurrencyStatus status;

-(instancetype)initWithManagedData;

@end
