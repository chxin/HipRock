/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMPinToBuildingCoverHelper.m
 * Date Created : tantan on 1/2/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMPinToBuildingCoverHelper.h"
#import "REMApplicationContext.h"
#import "REMUpdateAllManager.h"


@implementation REMPinToBuildingCoverHelper

- (void)pinToBuildingCover:(NSDictionary *)param withBuildingInfo:(REMManagedBuildingModel *)buildingInfo withCallback:(void(^)(REMPinToBuildingCoverStatus))callback{
    REMDataStore *store=[[REMDataStore alloc]initWithName:REMDSBuildingPinningToCover parameter:param accessCache:NO andMessageMap:nil];
    REMPinToCoverPersistenceProcessor *processor = [[REMPinToCoverPersistenceProcessor alloc]init];
    processor.buildingInfo = buildingInfo;
    store.persistenceProcessor = processor;
    [store access:^(NSArray *data){
        callback(REMPinToBuildingCoverStatusSuccess);
    }error:^(NSError *error,REMDataAccessErrorStatus status, REMBusinessErrorInfo * bizError){
        if (status == REMDataAccessErrorMessage) {
            if ([bizError.code isEqualToString:@"050001216002"]==YES) {//widget deleted
                [self showMessage:REMIPadLocalizedString(@"Building_WidgetRelationWidgetDeleted")];
            }
            else if([bizError.code isEqualToString:@"050001216001"]==YES || [bizError.code isEqualToString:@"050001216005"]==YES){//container deleted
                [self showMessage:REMIPadLocalizedString(@"Building_WidgetRelationPositionDeleted")];
            }
        }
    }];
}

- (void)showMessage:(NSString *)msg{
    NSString *updateString=REMIPadLocalizedString(@"Common_UpdateData");
    NSString *fullMsg = [NSString stringWithFormat:msg,self.widgetName];
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"" message:fullMsg delegate:self cancelButtonTitle:updateString otherButtonTitles: nil];
    [view show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    REMUpdateAllManager *manager=[REMUpdateAllManager defaultManager];
    manager.canCancel=YES;
    manager.updateSource=REMCustomerUserConcurrencySourceUpdate;
    manager.mainNavigationController = self.mainNavigationController;
    [manager updateAllBuildingInfoWithAction:^(REMCustomerUserConcurrencyStatus status, NSArray *buildingInfoArray, REMDataAccessErrorStatus errorStatus) {
        if (status == REMCustomerUserConcurrencyStatusSuccess) {
            [self.mainNavigationController presentInitialView];
        }
    }];
}

@end
