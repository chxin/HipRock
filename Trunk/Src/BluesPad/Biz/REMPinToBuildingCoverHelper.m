/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMPinToBuildingCoverHelper.m
 * Date Created : tantan on 1/2/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMPinToBuildingCoverHelper.h"

@implementation REMPinToBuildingCoverHelper

+ (void)pinToBuildingCover:(NSDictionary *)param withBuildingInfo:(REMBuildingOverallModel *)buildingInfo withCallback:(void(^)(REMPinToBuildingCoverStatus))callback{
    REMDataStore *store=[[REMDataStore alloc]initWithName:REMDSBuildingPinningToCover parameter:param];
    
    [store access:^(NSArray *data){
        NSMutableArray *newArray=[NSMutableArray array];
        for (NSDictionary *dic in data) {
            [newArray addObject:[[REMBuildingCoverWidgetRelationModel alloc]initWithDictionary:dic]];
        }
        buildingInfo.widgetRelationArray=newArray;
        
        callback(REMPinToBuildingCoverStatusSuccess);
    }error:^(NSError *error,REMDataAccessErrorStatus status, REMBusinessErrorInfo * bizError){
        if (status == REMDataAccessErrorMessage) {
            
        }
    }];
}

@end
