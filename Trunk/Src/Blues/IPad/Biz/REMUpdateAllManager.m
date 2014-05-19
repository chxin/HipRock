/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMUpdateAllManager.m
 * Date Created : tantan on 1/9/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMUpdateAllManager.h"
#import "REMManagedAdministratorModel.h"
#import "REMBuildingPersistenceProcessor.h"
#import "REMApplicationContext.h"
#import "REMImageHelper.h"
#import "REMTimeHelper.h"
#import "REMCommonHeaders.h"
#import "REMBuildingInfoUpdateModel.h"
#import "REMManagedCustomerModel.h"
#import "REMManagedBuildingModel.h"


@interface REMUpdateAllManager()


@property (nonatomic,strong) NSArray *buildingInfoArray;
@property (nonatomic,strong) NSArray *customerInfoArray;

@property (nonatomic,strong) REMCustomerSelectionCallback callback;

@property (nonatomic,strong) NSDictionary *parameter;

@property (nonatomic) REMCustomerUserConcurrencyStatus lastStatus;

@property (nonatomic,weak) UIAlertView *alertView;

@property (nonatomic) BOOL isError;

@end



@implementation REMUpdateAllManager

+ (REMUpdateAllManager *)defaultManager{
    REMUpdateAllManager *manager =  [[REMUpdateAllManager alloc] init];
    
    manager.currentUserId = REMAppContext.currentUser.id;
    manager.currentCustomerId = REMAppContext.currentCustomer.id;
    manager.canCancel = NO;
    manager.updateSource = REMCustomerUserConcurrencySourceEnter;
    
    REMAppContext.sharedUpdateManager = manager;
    
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
    NSDictionary *messageMap=nil;
    BOOL accessCache=YES;
    if (self.updateSource == REMCustomerUserConcurrencySourceEnter) {
        messageMap = REMDataAccessMessageMake(@"",@"Setting_NetworkFailed",@"Setting_ServerError",@"");
    }
    else if(self.updateSource == REMCustomerUserConcurrencySourceSwitchCustomer){
        messageMap = REMDataAccessMessageMake(@"Setting_SwitchCustomerNoNetwork",@"Setting_SwitchCustomerNetworkFailed",@"Setting_SwitchCustomerServerError",@"");
        accessCache=NO;
    }
    else{
        accessCache=NO;
        messageMap = REMDataAccessMessageMake(@"Setting_UpdateNoNetwork",@"Setting_UpdateNetworkFailed",@"Setting_UpdateServerError",@"");
    }
    
    
    if (REMAppContext.sharedUpdateManager != nil && self.canCancel==YES) {
        NSString *msg=REMIPadLocalizedString(@"Setting_LoadingData");//正在更新客户的楼宇及能耗信息，请稍后...
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:REMIPadLocalizedString(@"Common_Giveup") otherButtonTitles: nil];
        alert.tag=-1;
        [alert show];
        self.alertView=alert;
    }
    
    REMDataStore *store =[[REMDataStore alloc]initWithName:REMDSBuildingInfoUpdate parameter:dic accessCache:accessCache andMessageMap:messageMap];
    store.persistenceProcessor = [[REMBuildingPersistenceProcessor alloc]init];
    store.groupName =customerUpdateAll;
    //store.isAccessCache = NO;
    
    self.parameter=dic;
    
    [self accessStore:store success:^(REMBuildingInfoUpdateModel *buildingInfo, UIImage *logoImage) {
        REMCustomerUserConcurrencyStatus status=buildingInfo.status;
        self.lastStatus=status;
        
        self.customerInfoArray = buildingInfo.customers;
        
        [REMAppContext cleanImage];
        
        //sort building by province
        self.buildingInfoArray=[self sortByProvince:buildingInfo.buildingInfo];
        
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
            [self statusSuccess:logoImage];
        }
    } failure:^(NSError *error, REMDataAccessStatus status, id response) {
        self.tableViewController=nil;
        REMApplicationContext *context=REMAppContext;
        if (self.alertView!=nil) {
            [self.alertView dismissWithClickedButtonIndex:-1 animated:NO];
        }
        callback(REMCustomerUserConcurrencyStatusFailed,nil,status);
        context.sharedUpdateManager=nil;
    }];
    
    
}

- (void)accessStore:(REMDataStore *)store success:(void (^)(REMBuildingInfoUpdateModel *buildingInfo, UIImage *logoImage))success failure:(REMDataAccessFailureBlock)failure
{
    [store access:^(REMBuildingInfoUpdateModel *buildingInfo){
        NSDictionary *parameter;
        if (self.selectedCustomerId!=nil) {
            parameter= @{@"customerId":self.selectedCustomerId};
        }
        else{
            parameter= @{@"customerId":self.currentCustomerId};
        }
        
        REMDataStore *logoStore = [[REMDataStore alloc] initWithName:REMDSCustomerLogo parameter:parameter accessCache:YES andMessageMap:nil];
        logoStore.parentStore=store;
        
        [logoStore access:^(UIImage *logoImage) {
            success(buildingInfo,logoImage);
        } failure:failure];
    } failure: failure];
}


- (void)showAlertWithMessage:(NSString *)msg withTag:(NSInteger)tag{
    if (self.updateSource == REMCustomerUserConcurrencySourceSwitchCustomer) {
        msg = [REMIPadLocalizedString(@"Setting_SwitchCustomerFailed") stringByAppendingString:msg];
    }
    else if(self.updateSource == REMCustomerUserConcurrencySourceUpdate){
        msg = [REMIPadLocalizedString(@"Setting_UpdateFailed") stringByAppendingString:msg];
    }
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:REMIPadLocalizedString(@"Common_OK") otherButtonTitles:nil];
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
        if (self.updateSource == REMCustomerUserConcurrencySourceEnter) {
            customerController.hideCancelButton=YES;
        }
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
    [self showAlertWithMessage:REMIPadLocalizedString(@"Setting_UserDeleted") withTag:0];
}

- (void)statusCurrentCustomerDeleted{
    [self showAlertWithMessage:REMIPadLocalizedString(@"Setting_CurrentCustomerDeleted") withTag:1];
}

- (void)statusSelectedCustomerDeleted{
    [self showAlertWithMessage:REMIPadLocalizedString(@"Setting_CurrentCustomerDeleted") withTag:2];

}

- (void)statusNoAttached{
    [self showAlertWithMessage:REMIPadLocalizedString(@"Setting_NoAttachedCustomer") withTag:3];
}

- (void)statusSuccess:(UIImage *)customerLogo{
    if (self.customerInfoArray==nil) {
        self.customerInfoArray=REMAppContext.currentUser.customers.array;
    }
    
    NSNumber *newCustomerId = self.selectedCustomerId == nil ? self.currentCustomerId : self.selectedCustomerId;
    
    if(newCustomerId != self.currentCustomerId){
        REMAppContext.currentCustomer.isCurrent = @(NO);
    }
    
    for(REMManagedCustomerModel * customer in self.customerInfoArray){
        if([customer.id isEqualToNumber:newCustomerId]){
            REMAppContext.currentCustomer = customer;
            break;
        }
    }
    
    if(customerLogo!=nil){
        REMAppContext.currentCustomer.logoImage = UIImagePNGRepresentation(customerLogo);
    }
    
    [self persistAllData];
    
    self.tableViewController=nil;
    REMAppContext.sharedUpdateManager=nil;
    self.callback(REMCustomerUserConcurrencyStatusSuccess,self.buildingInfoArray,REMDataAccessSucceed);
}

- (void)persistAllData{
    REMApplicationContext *context=REMAppContext;
    context.buildingInfoArray = self.buildingInfoArray;
    
    [REMDataStore saveContext];
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
    
    REMMainNavigationController *mainController=self.mainNavigationController;
    
    void (^completion)(void) = ^(void){ [mainController logout]; };
    
    if(mainController.presentedViewController != nil){
        [mainController dismissViewControllerAnimated:YES completion:completion];
    }
    else{
        completion();
    }
}

- (void)customerSelectionTableView:(UITableView *)table didSelectCustomer:(REMManagedCustomerModel *)customer
{
    if (self.lastStatus == REMCustomerUserConcurrencyStatusCurrentCustomerDeleted) {
        self.currentCustomerId=customer.id;
        self.selectedCustomerId=nil;
    }
    else{
        self.selectedCustomerId=customer.id;
    }
    self.tableViewController=self.tableViewController;
    self.updateSource=REMCustomerUserConcurrencySourceSwitchCustomer;
    [self updateAllBuildingInfoWithAction:self.callback];
}

- (void)customerSelectionTableViewdidDismissView
{
    self.tableViewController=nil;
    REMApplicationContext *context=REMAppContext;
    context.sharedUpdateManager=nil;
}

+ (void)cancelUpdateAll:(void (^)(void))callback
{
    [REMDataStore cancel:customerUpdateAll];
    REMApplicationContext *context=REMAppContext;
    context.sharedUpdateManager=nil;
    if (callback!= nil) {
        callback();
    }
}

-(NSArray *)sortByProvince:(NSArray *)buildingInfoArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for(int i=0; i<REMProvinceOrder.count;i++){
        NSString *key = REMProvinceOrder[i];
        
        for (int j=0; j<buildingInfoArray.count; j++) {
            REMManagedBuildingModel *buildingInfo = buildingInfoArray[j];
            NSString *province = buildingInfo.province;
            
            if(!REMIsNilOrNull(province) && [province rangeOfString:key].length>0) {
                [array addObject:buildingInfo];
            }
        }
    }
    
    //海外
    for(REMManagedBuildingModel *buildingInfo in buildingInfoArray){
        if([array containsObject:buildingInfo] == NO){
            [array addObject:buildingInfo];
        }
    }
    
    return array;
}

@end
