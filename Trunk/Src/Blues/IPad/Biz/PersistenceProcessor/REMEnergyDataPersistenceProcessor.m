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


- (id)persist:(id)data{
    [self clean];
    
    NSString *value = [REMJSONHelper stringByObject:data];
    
    REMManagedEnergyDataModel *energyModel = [self create:[REMManagedEnergyDataModel class]];
    energyModel.key = [self getDataKey];
    energyModel.value = value;
    [self save];
    
    return data;
}

- (id)fetch{
    NSPredicate * qcondition= [NSPredicate predicateWithFormat:@"%K==%@",@"key",[self getDataKey]];//[NSPredicate predicateWithFormat:@"key = %@",[self getDataKey]];
    REMManagedEnergyDataModel *energyDataModel = [[self fetch:[REMManagedEnergyDataModel class] withPredicate:qcondition] lastObject];
    
    if(energyDataModel == nil){
        return nil;
    }
    
    NSString *value = energyDataModel.value;
    
    return  [REMJSONHelper objectByString:value];
}

-(void)clean
{
    NSPredicate * qcondition= [NSPredicate predicateWithFormat:@"%K==%@",@"key",[self getDataKey]];
    NSArray *oldEnergyData = [self fetch:[REMManagedEnergyDataModel class] withPredicate:qcondition];
    
    if(REMIsNilOrNull(oldEnergyData) || oldEnergyData.count <=0)
        return;
    
    for (REMManagedEnergyDataModel *model in oldEnergyData) {
        [self remove:model];
    }
}

-(NSString *)getDataKey
{
    NSString *url = self.dataStore.url;
    NSString *parameter = [REMJSONHelper stringByObject:self.dataStore.parameter];
    
    return [url stringByAppendingString:parameter];
}

@end
