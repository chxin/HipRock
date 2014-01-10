/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMUpdateAllManager.m
 * Date Created : tantan on 1/9/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMUpdateAllManager.h"
#import "REMCustomerModel.h"
#import "REMUserModel.h"
#import "REMBuildingOverallModel.h"
#import "REMServiceAgent.h"

@interface REMUpdateAllManager()

@property (nonatomic,strong) NSArray *buildingInfoArray;
@property (nonatomic,strong) NSArray *customerInfoArray;

@property (nonatomic,strong) CustomerSelectionCallback callback;

@property (nonatomic,strong) NSDictionary *parameter;

@end

@implementation REMUpdateAllManager

+ (REMUpdateAllManager *)defaultManager{
    REMUpdateAllManager *manager =  [[REMUpdateAllManager alloc]init];
    REMCustomerModel *customer=REMAppCurrentCustomer;
    REMUserModel *user=REMAppCurrentUser;
    manager.currentCustomerId=customer.customerId;
    manager.currentUserId=@(user.userId);
    return manager;
}

static NSString *customerUpdateAll=@"customerupdateall";


- (void)updateAllBuildingInfoWithAction:(CustomerSelectionCallback)callback
{
    self.callback=callback;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.selectedCustomerId!=nil) {
        [dic setObject:self.selectedCustomerId forKey:@"selectedCustomerId"];
    }
    [dic setObject:self.currentCustomerId forKey:@"customerId"];
    
    REMDataStore *store =[[REMDataStore alloc]initWithName:REMDSBuildingInfoUpdate parameter:dic];
    store.maskContainer=self.maskerView;
    store.groupName =customerUpdateAll;
    self.parameter=dic;
    [store access:^(NSDictionary *data){
        
        
        NSDictionary *parameter;
        if (self.selectedCustomerId!=nil) {
            parameter= @{@"customerId":self.selectedCustomerId};
        }
        else{
            parameter= @{@"customerId":self.currentCustomerId};
        }
        REMDataStore *logoStore = [[REMDataStore alloc] initWithName:REMDSCustomerLogo parameter:parameter];
        logoStore.groupName = nil;
        logoStore.maskContainer = nil;
        
        [logoStore access:^(id data) {
            UIImage *logo = nil;
            if(data != nil && [data length] > 2) {
                logo = [REMImageHelper parseImageFromNSData:data withScale:1.0];
            }
            
            REMAppCurrentLogo = logo;
            
            
            NSNumber *statusNumber=data[@"Status"];
            REMCustomerUserConcurrencyStatus status=(REMCustomerUserConcurrencyStatus)[statusNumber integerValue];
            
            NSArray *newList = data[@"Customers"];
            NSMutableArray *customerList=nil;
            if(newList!=nil && [newList isEqual:[NSNull null]]==NO){
                customerList = [[NSMutableArray alloc]initWithCapacity:newList.count];
                for (NSDictionary *obj in newList) {
                    REMCustomerModel *model=[[REMCustomerModel alloc]initWithDictionary:obj];
                    [customerList addObject:model];
                }
            }
            self.customerInfoArray=customerList;
            NSArray *newBuildingList=data[@"BuildingInfo"];
            NSMutableArray *buildingInfoList=nil;
            if(newBuildingList!=nil && [newBuildingList isEqual:[NSNull null]]==NO){
                buildingInfoList = [[NSMutableArray alloc]initWithCapacity:newBuildingList.count];
                for (NSDictionary *obj in newBuildingList) {
                    REMBuildingOverallModel *model=[[REMBuildingOverallModel alloc]initWithDictionary:obj];
                    [buildingInfoList addObject:model];
                }
            }
            self.buildingInfoArray=buildingInfoList;
            
            if (status == REMCustomerUserConcurrencyStatusUserDeleted) {
                [self statusUserDeleted];
            }
            else if(status == REMCustomerUserConcurrencyStatusCurrentCustomerDeleted){
                [self statusCurrentCustomerDeleted];
            }
            else if(status == REMCustomerUserConcurrencyStatusSelectedCustomerDeleted){
                [self statusSelectedCustomerDeleted];
            }
            else if(status == REMCustomerUserConcurrencyStatusNoAttachedCustomer){
                [self statusNoAttached];
            }
            else if(status == REMCustomerUserConcurrencyStatusSuccess){
                [self statusSuccess];
            }
            
        } error:^(NSError *error, REMDataAccessErrorStatus status, id response) {
            callback(REMCustomerUserConcurrencyStatusFailed,nil,status);
        }];
        
        
    } error:^(NSError *error, REMDataAccessErrorStatus status, id response) {
        callback(REMCustomerUserConcurrencyStatusFailed,nil,status);
    }];
}

- (void)showAlertWithMessage:(NSString *)msg withTag:(NSInteger)tag{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"Common_OK", @"") otherButtonTitles:nil];
    alert.tag=tag;
    [alert show];
}

- (void)showTableView{
    if (self.tableViewController==nil) {
        REMLoginCustomerTableViewController *customerController = [[REMLoginCustomerTableViewController alloc] init];
        customerController.delegate=self;
        customerController.customerArray=self.customerInfoArray;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:customerController];
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
        navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        [self.mainNavigationController presentViewController:navController animated:YES completion:nil];
    }
    else{
        self.tableViewController.customerArray=self.customerInfoArray;
        [self.tableViewController customerSelectionTableViewUpdate];
    }
}

- (void)statusUserDeleted{
    [self showAlertWithMessage:NSLocalizedString(@"Setting_UserDeleted", @"") withTag:0];
}

- (void)statusCurrentCustomerDeleted{
    [self showAlertWithMessage:NSLocalizedString(@"Setting_CurrentCustomerDeleted", @"") withTag:1];
}

- (void)statusSelectedCustomerDeleted{
    [self showAlertWithMessage:NSLocalizedString(@"Setting_CurrentCustomerDeleted", @"") withTag:2];

}

- (void)statusNoAttached{
    [self showAlertWithMessage:NSLocalizedString(@"Setting_NoAttachedCustomer", @"") withTag:3];
}

- (void)statusSuccess{
    REMApplicationContext *context=REMAppContext;
    context.buildingInfoArray=self.buildingInfoArray;
    
    NSString *parameterString = [REMServiceAgent buildParameterString:self.parameter];
    NSData *postData = [parameterString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *storageKey = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    context.buildingInfoArrayStorageKey=storageKey;
    self.callback(REMCustomerUserConcurrencyStatusSuccess,self.buildingInfoArray,REMDataAccessCanceled);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0 || alertView.tag == 3) { // logout,user deleted
        [self logout];
    }
    else if(alertView.tag == 1 || alertView.tag == 2){ //current customer deleted or selected customer deleted
        [self showTableView];
    }
    
}

- (void)logout{
    REMUserModel *currentUser = [REMApplicationContext instance].currentUser;
    REMCustomerModel *currentCustomer = [REMApplicationContext instance].currentCustomer;
    
    [currentUser kill];
    [currentCustomer kill];
    currentUser = nil;
    currentCustomer = nil;
    
    
    
    [REMApplicationContext destroy];
    
    REMMainNavigationController *mainController=self.mainNavigationController;
    //NSLog(@"child controllers before: %d", nav.childViewControllers.count);
    [mainController dismissViewControllerAnimated:YES completion:^(void){
        //self.view = nil;
        //[nav popToRootViewControllerAnimated:NO];
        //NSLog(@"child controllers after: %d", nav.childViewControllers.count);
        [mainController logout:nil];
        
        [REMStorage clearSessionStorage];
        [REMStorage clearOnApplicationActive];
    }];
}

- (void)customerSelectionTableView:(UITableView *)table didSelectCustomer:(REMCustomerModel *)customer
{
    
    self.selectedCustomerId=customer.customerId;
    self.tableViewController=self.tableViewController;
    [self updateAllBuildingInfoWithAction:self.callback];
}

- (void)customerSelectionTableViewdidDismissView
{
    
}

+ (void)cancelUpdateAll:(void (^)(void))callback
{
    [REMDataStore cancelAccess:customerUpdateAll];
    if (callback!= nil) {
        callback();
    }
}

@end
