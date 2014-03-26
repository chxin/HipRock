/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingInfoUpdateModel.m
 * Date Created : 张 锋 on 3/24/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMBuildingInfoUpdateModel.h"
#import "REMDataStore.h"
#import "REMManagedBuildingModel.h"

@implementation REMBuildingInfoUpdateModel

-(instancetype)initWithManagedData
{
    REMBuildingInfoUpdateModel *model = [[REMBuildingInfoUpdateModel alloc] init];
    model.buildingInfo = [REMDataStore fetchManagedObject:[REMManagedBuildingModel class]];
    model.customers = [REMDataStore fetchManagedObject:[REMManagedCustomerModel class]];
    model.status = REMCustomerUserConcurrencyStatusSuccess;
    
    return model;
}

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.buildingInfo = dictionary[@"BuildingInfo"];
    self.customers = dictionary[@"Customers"];
    self.status = [dictionary[@"Status"] intValue];
}



@end
