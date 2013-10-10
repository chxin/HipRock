//
//  REMEnergySeacherBase.m
//  Blues
//
//  Created by tantan on 10/9/13.
//
//

#import "REMEnergySeacherBase.h"
#import "REMEnergyMultiTimeSearcher.h"
@implementation REMEnergySeacherBase

+ (REMEnergySeacherBase *)querySearcherByType:(REMDataStoreType)storeType
{
    if (storeType == REMDSEnergyMultiTimeDistribute ||storeType == REMDSEnergyMultiTimeTrend) {
        return [[REMEnergyMultiTimeSearcher alloc]init];
    }
    else{
        return [[REMEnergySeacherBase alloc]init];
    }
}

- (void)queryEnergyDataByStoreType:(REMDataStoreType)storeType andParameters:(NSDictionary *)params withMaserContainer:(UIView *)maskerContainer callback:(void (^)(id))callback
{
    REMDataStore *store = [[REMDataStore alloc] initWithName:storeType parameter:params];
    store.maskContainer=maskerContainer;
    
    [REMDataAccessor access:store success:^(NSDictionary *data){
        
        if(callback!=nil){
            callback(data);
        }
    
    } error:^(NSError *error,id response){
    
    }];
}

@end
