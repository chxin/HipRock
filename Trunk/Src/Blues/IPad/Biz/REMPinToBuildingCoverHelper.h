/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMPinToBuildingCoverHelper.h
 * Date Created : tantan on 1/2/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <Foundation/Foundation.h>
#import "REMBuildingCoverWidgetRelationModel.h"
#import "REMMainNavigationController.h"
#import "REMPinToCoverPersistenceProcessor.h"
#import "REMManagedBuildingModel.h"
#import "REMBusinessErrorInfo.h"
typedef enum _REMPinToBuildingCoverStatus{
    REMPinToBuildingCoverStatusSuccess,
    REMPinToBuildingCoverStatusWidgetNotExist,
    REMPinToBuildingCoverStatusBuildingNotExist,
    REMPinToBuildingCoverStatusCommodityNotExist
} REMPinToBuildingCoverStatus;

@interface REMPinToBuildingCoverHelper : NSObject<UIAlertViewDelegate>

- (void) pinToBuildingCover:(NSDictionary *)param withBuildingInfo:(REMManagedBuildingModel *)buildingInfo withCallback:(void(^)(REMPinToBuildingCoverStatus))callback;

@property (nonatomic,weak) REMMainNavigationController *mainNavigationController;
@property (nonatomic,copy) NSString *widgetName;

@end
