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

- (void)pinToBuildingCover:(NSDictionary *)param withBuildingInfo:(REMBuildingOverallModel *)buildingInfo withCallback:(void(^)(REMPinToBuildingCoverStatus))callback{
    REMDataStore *store=[[REMDataStore alloc]initWithName:REMDSBuildingPinningToCover parameter:param accessCache:NO andMessageMap:nil];
    
    [store access:^(NSArray *data){
        NSMutableArray *newArray=[NSMutableArray array];
        for (NSDictionary *dic in data) {
            [newArray addObject:[[REMBuildingCoverWidgetRelationModel alloc]initWithDictionary:dic]];
        }
        buildingInfo.widgetRelationArray=newArray;
        [buildingInfo updateInnerDictionary];
        [REMApplicationContext updateBuildingInfoArrayToStorage];
        callback(REMPinToBuildingCoverStatusSuccess);
    }error:^(NSError *error,REMDataAccessErrorStatus status, REMBusinessErrorInfo * bizError){
        if (status == REMDataAccessErrorMessage) {
            if ([bizError.code isEqualToString:@"050001216002"]==YES) {//widget deleted
                [self showMessage:NSLocalizedString(@"Building_WidgetRelationWidgetDeleted", @"")];
            }
            else if([bizError.code isEqualToString:@"050001216001"]==YES){//container deleted
                [self showMessage:NSLocalizedString(@"Building_WidgetRelationPositionDeleted", @"")];
            }
        }
    }];
}

- (void)showMessage:(NSString *)msg{
    NSString *updateString=NSLocalizedString(@"Common_UpdateData", @"");
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
