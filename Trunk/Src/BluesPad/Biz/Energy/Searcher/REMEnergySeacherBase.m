/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEnergySeacherBase.m
 * Created      : tantan on 10/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMEnergySeacherBase.h"
#import "REMEnergyMultiTimeSearcher.h"




@implementation REMEnergySeacherBase

+ (REMEnergySeacherBase *)querySearcherByType:(REMDataStoreType)storeType withWidgetInfo:(REMWidgetObject *)widgetInfo
{
    REMEnergySeacherBase *obj;
    if (storeType == REMDSEnergyMultiTimeDistribute ||storeType == REMDSEnergyMultiTimeTrend) {
        obj= [[REMEnergyMultiTimeSearcher alloc]init];
    }
    else{
        obj=[[REMEnergySeacherBase alloc]init];
    }
    obj.widgetInfo=widgetInfo;
    return  obj;
}

- (void)queryEnergyDataByStoreType:(REMDataStoreType)storeType andParameters:(REMWidgetSearchModelBase *)model withMaserContainer:(UIView *)maskerContainer andGroupName:(NSString *)groupName callback:(void (^)(id, REMBusinessErrorInfo *))callback
{
    self.model=model;
    REMDataStore *store = [[REMDataStore alloc] initWithName:storeType parameter:[model toSearchParam]];
    store.maskContainer=maskerContainer;
    store.groupName=groupName;
    [REMDataAccessor access:store success:^(NSDictionary *data){
        if([data isEqual:[NSNull null]]==YES)return ;
        REMEnergyViewData *viewData=[self processEnergyData:data];
        if(callback!=nil){
            callback(viewData,nil);
        }
        
    } error:^(NSError *error,REMBusinessErrorInfo *errorInfo){
        callback(nil,errorInfo);
    }];
}


- (REMEnergyViewData *)processEnergyData:(NSDictionary *)rawData{
    return [[REMEnergyViewData alloc]initWithDictionary:rawData];;
}



@end
