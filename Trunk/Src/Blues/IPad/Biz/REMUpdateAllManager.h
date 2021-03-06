/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMUpdateAllManager.h
 * Date Created : tantan on 1/9/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <Foundation/Foundation.h>
#import "REMLoginCustomerTableViewController.h"
#import "REMMainNavigationController.h" 
#import "REMLoginCustomerTableViewController.h"
#import "REMCommonHeaders.h"
#import "REMDataStore.h"


typedef enum _REMCustomerUserConcurrencyStatus {
    REMCustomerUserConcurrencyStatusSuccess = 0,
    REMCustomerUserConcurrencyStatusCurrentCustomerDeleted = 1,
    REMCustomerUserConcurrencyStatusSelectedCustomerDeleted=2,
    REMCustomerUserConcurrencyStatusNoAttachedCustomer=3,
    REMCustomerUserConcurrencyStatusUserDeleted=4,
    REMCustomerUserConcurrencyStatusFailed=5
} REMCustomerUserConcurrencyStatus;

typedef enum _REMCustomerUserConcurrencySource{
    REMCustomerUserConcurrencySourceEnter=0,
    REMCustomerUserConcurrencySourceUpdate=1,
    REMCustomerUserConcurrencySourceSwitchCustomer=2
} REMCustomerUserConcurrencySource;

typedef void (^REMCustomerSelectionCallback)(REMCustomerUserConcurrencyStatus status,NSArray* buildingInfoArray,REMDataAccessStatus errorStatus);


@interface REMUpdateAllManager : NSObject<UIAlertViewDelegate, REMLoginCustomerSelectionDelegate>

@property (nonatomic,copy) NSNumber *selectedCustomerId;

@property (nonatomic,copy) NSNumber *currentUserId;

@property (nonatomic,copy) NSNumber *currentCustomerId;

@property (nonatomic,weak) REMMainNavigationController *mainNavigationController;

@property (nonatomic) REMCustomerUserConcurrencySource updateSource;

@property (nonatomic,weak) UIView *maskerView;

@property (nonatomic) BOOL canCancel;

@property (nonatomic,weak) UITableViewController<REMCustomerSelectionInterface> *tableViewController;

- (void) updateAllBuildingInfoWithAction:(REMCustomerSelectionCallback )callback;

+ (REMUpdateAllManager *)defaultManager;

+ (void)cancelUpdateAll:(void(^)(void))callback;

@end
