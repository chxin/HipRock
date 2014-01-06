/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMPinToBuildingCoverHelper.h
 * Date Created : tantan on 1/2/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <Foundation/Foundation.h>
#import "REMBuildingOverallModel.h"
#import "REMBuildingCoverWidgetRelationModel.h"

typedef enum _REMPinToBuildingCoverStatus{
    REMPinToBuildingCoverStatusSuccess,
    REMPinToBuildingCoverStatusWidgetNotExist,
    REMPinToBuildingCoverStatusBuildingNotExist,
    REMPinToBuildingCoverStatusCommodityNotExist
} REMPinToBuildingCoverStatus;

@interface REMPinToBuildingCoverHelper : NSObject

+ (void) pinToBuildingCover:(NSDictionary *)param withBuildingInfo:(REMBuildingOverallModel *)buildingInfo withCallback:(void(^)(REMPinToBuildingCoverStatus))callback;

@end
