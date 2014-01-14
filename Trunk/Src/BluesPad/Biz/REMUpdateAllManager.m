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

@property (nonatomic,strong) REMCustomerSelectionCallback callback;

@property (nonatomic,strong) NSDictionary *parameter;

@property (nonatomic) REMCustomerUserConcurrencyStatus lastStatus;

@property (nonatomic,weak) UIAlertView *alertView;


@end

@implementation REMUpdateAllManager

+ (REMUpdateAllManager *)defaultManager{
    REMUpdateAllManager *manager =  [[REMUpdateAllManager alloc]init];
    REMCustomerModel *customer=REMAppCurrentCustomer;
    REMUserModel *user=REMAppCurrentUser;
    manager.currentCustomerId=customer.customerId;
    manager.currentUserId=@(user.userId);
    manager.canCancel=NO;
    return manager;
}

static NSString *customerUpdateAll=@"customerupdateall";


- (void)updateAllBuildingInfoWithAction:(REMCustomerSelectionCallback)callback
{
    self.callback=callback;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.selectedCustomerId!=nil) {
        [dic setObject:self.selectedCustomerId forKey:@"selectedCustomerId"];
    }
    [dic setObject:self.currentCustomerId forKey:@"customerId"];
    
    NSDictionary *messageMap = @{@(REMDataAccessNoConnection):REMLocalizedString(@"TODO:I18N"), @(REMDataAccessFailed):REMLocalizedString(@"TODO:I18N"),@(REMDataAccessErrorMessage):REMLocalizedString(@"TODO:I18N")};
    REMDataStore *store =[[REMDataStore alloc]initWithName:REMDSBuildingInfoUpdate parameter:dic accessCache:YES andMessageMap:messageMap];
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
        REMDataStore *logoStore = [[REMDataStore alloc] initWithName:REMDSCustomerLogo parameter:parameter accessCache:YES andMessageMap:messageMap];
        logoStore.groupName = nil;
        logoStore.maskContainer = nil;
        
        [logoStore access:^(id data1) {
            UIImage *logo = nil;
            if(data1 != nil && [data1 length] > 2) {
                logo = [REMImageHelper parseImageFromNSData:data1 withScale:1.0];
            }
            
            REMAppCurrentLogo = logo;
            
            
            NSNumber *statusNumber=data[@"Status"];
            REMCustomerUserConcurrencyStatus status=(REMCustomerUserConcurrencyStatus)[statusNumber integerValue];
            self.lastStatus=status;
            NSArray *newList = data[@"Customers"];
            NSMutableArray *customerList=nil;
            if(newList!=nil && [newList isEqual:[NSNull null]]==NO){
                customerList = [[NSMutableArray alloc]initWithCapacity:newList.count];
                for (NSDictionary *obj in newList) {
                    REMCustomerModel *model=[[REMCustomerModel alloc]initWithDictionary:obj];
                    [customerList addObject:model];
                }
                self.customerInfoArray=customerList;

            }
            NSArray *newBuildingList=data[@"BuildingInfo"];
            NSMutableArray *buildingInfoList=nil;
            if(newBuildingList!=nil && [newBuildingList isEqual:[NSNull null]]==NO){
                buildingInfoList = [[NSMutableArray alloc]initWithCapacity:newBuildingList.count];
                for (NSDictionary *obj in newBuildingList) {
                    REMBuildingOverallModel *model=[[REMBuildingOverallModel alloc]initWithDictionary:obj];
                    [buildingInfoList addObject:model];
                }
                self.buildingInfoArray=buildingInfoList;
            }
            [self.alertView dismissWithClickedButtonIndex:-1 animated:YES];
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
    if (self.canCancel==YES) {
        NSString *msg=NSLocalizedString(@"Setting_LoadingData", @"");//正在更新客户的楼宇及能耗信息，请稍后...
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"Common_Giveup", @"") otherButtonTitles: nil];
        alert.tag=-1;
        [alert show];
        self.alertView=alert;
    }
    
    
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
        if (self.mainNavigationController.presentedViewController!=nil) {
            customerController.holder=self;
            [self.mainNavigationController dismissViewControllerAnimated:YES completion:^(void){
                [self.mainNavigationController presentViewController:navController animated:YES completion:nil];
            }];
        }
        else{
            [self.mainNavigationController presentViewController:navController animated:YES completion:nil];
        }
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
    
    if (self.customerInfoArray!=nil) {
        context.currentUser.customers=self.customerInfoArray;
        [context.currentUser updateInnerDictionary];
        [context.currentUser save];
    }
    else{
        self.customerInfoArray=context.currentUser.customers;
    }
    REMCustomerModel *current=REMAppCurrentCustomer;
    for (REMCustomerModel *customer in self.customerInfoArray) {
        if ([customer.customerId isEqualToNumber:self.selectedCustomerId]==YES && [customer isEqual:current]==NO) {
            context.currentCustomer=customer;
            [context.currentCustomer updateInnerDictionary];
            [context.currentCustomer save];
        }
    }
    
    
    self.tableViewController=nil;
    self.callback(REMCustomerUserConcurrencyStatusSuccess,self.buildingInfoArray,REMDataAccessFailed);
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        if (alertView.tag==-1) {//give up
            [REMUpdateAllManager cancelUpdateAll:nil];
        }
        else if (alertView.tag == 0 || alertView.tag == 3) { // logout,user deleted
            [self logout];
        }
        else if(alertView.tag == 1 || alertView.tag == 2){ //current customer deleted or selected customer deleted
            [self showTableView];
        }
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
    if (self.lastStatus == REMCustomerUserConcurrencyStatusCurrentCustomerDeleted) {
        self.currentCustomerId=customer.customerId;
        self.selectedCustomerId=nil;
    }
    else{
        self.selectedCustomerId=customer.customerId;
    }
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
