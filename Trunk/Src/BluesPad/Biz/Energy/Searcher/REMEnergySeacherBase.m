/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEnergySeacherBase.m
 * Created      : tantan on 10/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMEnergySeacherBase.h"
#import "REMEnergyMultiTimeSearcher.h"
#import "REMEnergyViewData.h"



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

- (void)queryEnergyDataByStoreType:(REMDataStoreType)storeType andParameters:(NSDictionary *)params withMaserContainer:(UIView *)maskerContainer andGroupName:(NSString *)groupName callback:(void (^)(id,REMBusinessErrorInfo *))callback
{
    REMDataStore *store = [[REMDataStore alloc] initWithName:storeType parameter:params];
    store.maskContainer=maskerContainer;
    store.groupName=groupName;
    [REMDataAccessor access:store success:^(NSDictionary *data){
        if([data isEqual:[NSNull null]]==YES)return ;
        REMEnergyViewData *viewData=[[REMEnergyViewData alloc]initWithDictionary:data];
        if(callback!=nil){
            callback(viewData,nil);
        }
    
    } error:^(NSError *error,REMBusinessErrorInfo *errorInfo){
        callback(nil,errorInfo);
    }];
}

@end
