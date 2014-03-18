/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEnergyDataPersistenceProcessor.m
 * Date Created : tantan on 3/6/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMEnergyDataPersistenceProcessor.h"
#import "REMJSONHelper.h"


@implementation REMEnergyDataPersistenceProcessor

- (id)fetchData{
    NSString *key = [REMJSONHelper stringByObject:self.dataStore.parameter];
    NSPredicate * qcondition= [NSPredicate predicateWithFormat:@"key = '%@'",key];
    NSArray *values = [self.dataStore fetchMangedObject:@"REMManagedEnergyDataModel" withPredicate:qcondition];
    
    
    return [REMJSONHelper objectByString:values[0]];
}

- (id)persistData:(id)data{
    NSString *url = self.dataStore.url;
    NSString *parameter = [REMJSONHelper stringByObject:self.dataStore.parameter];
    NSString *value = [REMJSONHelper stringByObject:data];
    
    REMManagedEnergyDataModel *energyModel = [self.dataStore newManagedObject:@"REMManagedEnergyDataModel"];
    energyModel.key = [url stringByAppendingString:parameter];
    energyModel.value = value;
    [self.dataStore persistManageObject];
    
    return data;
}

@end
