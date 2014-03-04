/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMUpdateAllManager.m
 * Date Created : tantan on 1/9/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMUpdateAllManager.h"
#import "REMBuildingOverallModel.h"
#import "REMServiceAgent.h"
#import "REMBuildingOverallModel.h"
#import "REMManagedAdministratorModel.h"


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
    REMUpdateAllManager *manager =  [[REMUpdateAllManager alloc]init];
    REMManagedCustomerModel *customer=REMAppCurrentManagedCustomer;
    REMManagedUserModel *user=REMAppCurrentManagedUser;
    manager.currentCustomerId=customer.id;
    manager.currentUserId=user.id;
    manager.canCancel=NO;
    manager.updateSource=REMCustomerUserConcurrencySourceEnter;
    REMApplicationContext *context=REMAppContext;
    context.updateManager=manager;
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
    
    REMDataStore *store =[[REMDataStore alloc]initWithName:REMDSBuildingInfoUpdate parameter:dic accessCache:accessCache andMessageMap:messageMap];
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
        REMDataStore *logoStore = [[REMDataStore alloc] initWithName:REMDSCustomerLogo parameter:parameter accessCache:YES andMessageMap:nil];
        logoStore.parentStore=store;
        
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
                if (self.customerInfoArray!=nil) {
                    REMDataStore *store = [[REMDataStore alloc]init];
                    for (REMManagedCustomerModel *oldCustomer in self.customerInfoArray) {
                        [store deleteManageObject:oldCustomer];
                    }
                }
                for (NSDictionary *obj in newList) {
                    //REMCustomerModel *model=[[REMCustomerModel alloc]initWithDictionary:obj];
                    REMManagedCustomerModel *model = [self buildManagedCustomerModel:obj];
                    [customerList addObject:model];
                }
                self.customerInfoArray=customerList;

            }
            NSArray *newBuildingList= data[@"BuildingInfo"];
            self.buildingInfoArray=newBuildingList;
//            NSMutableArray *buildingInfoList=nil;
//            if(newBuildingList!=nil && [newBuildingList isEqual:[NSNull null]]==NO){
//                buildingInfoList = [[NSMutableArray alloc]initWithCapacity:newBuildingList.count];
//                for (NSDictionary *obj in newBuildingList) {
//                    REMBuildingOverallModel *model=[[REMBuildingOverallModel alloc]initWithDictionary:obj];
//                    [buildingInfoList addObject:model];
//                }
//                self.buildingInfoArray= [REMBuildingOverallModel sortByProvince: buildingInfoList];
//            }
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
            self.tableViewController=nil;
            REMApplicationContext *context=REMAppContext;
            
            if (self.alertView!=nil) {
                [self.alertView dismissWithClickedButtonIndex:-1 animated:NO];
            }
            callback(REMCustomerUserConcurrencyStatusFailed,nil,status);
            context.updateManager=nil;
        }];
        
        
    } error:^(NSError *error, REMDataAccessErrorStatus status, id response) {
        self.tableViewController=nil;
        REMApplicationContext *context=REMAppContext;
        if (self.alertView!=nil) {
            [self.alertView dismissWithClickedButtonIndex:-1 animated:NO];
        }
        callback(REMCustomerUserConcurrencyStatusFailed,nil,status);
        context.updateManager=nil;
    }];
    REMApplicationContext *context=REMAppContext;
    if (context.updateManager != nil && self.canCancel==YES) {
        NSString *msg=NSLocalizedString(@"Setting_LoadingData", @"");//正在更新客户的楼宇及能耗信息，请稍后...
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"Common_Giveup", @"") otherButtonTitles: nil];
        alert.tag=-1;
        [alert show];
        self.alertView=alert;
    }
    
    
}

- (REMManagedCustomerModel *)buildManagedCustomerModel:(NSDictionary *)customer{
    REMDataStore *store = [[REMDataStore alloc]init];
    REMManagedUserModel *user = [[store fetchMangedObject:@"REMManagedUserModel"] lastObject];
    REMManagedCustomerModel *customerObject= [store newManagedObject:@"REMManagedCustomerModel"];
    
    customerObject.id = customer[@"Id"];
    customerObject.name=customer[@"Name"];
    customerObject.code=customer[@"Code"];
    customerObject.address=customer[@"Address"];
    customerObject.email=customer[@"Email"];
    customerObject.manager=customer[@"Manager"];
    customerObject.telephone=customer[@"Telephone"];
    customerObject.comment= NULL_TO_NIL(customer[@"Comment"]);
    customerObject.timezoneId=customer[@"TimezoneId"];
    customerObject.logoId=customer[@"logoId"];
    long long time=[REMTimeHelper longLongFromJSONString:customer[@"StartTime"]];
    customerObject.startTime= [NSDate dateWithTimeIntervalSince1970:time/1000 ];
    
    NSArray *administrators=customer[@"Administrators"];
    
    
    for (NSDictionary *admin in administrators) {
        REMManagedAdministratorModel *adminObject= [store newManagedObject:@"REMManagedAdministratorModel"];
        adminObject.realName=admin[@"RealName"];
        adminObject.customer=customerObject;
        [customerObject addAdministratorsObject:adminObject];
    }
    [user addCustomersObject:customerObject];
    return customerObject;

}

- (void)showAlertWithMessage:(NSString *)msg withTag:(NSInteger)tag{
    if (self.updateSource == REMCustomerUserConcurrencySourceSwitchCustomer) {
        msg = [NSLocalizedString(@"Setting_SwitchCustomerFailed", @"") stringByAppendingString:msg];
    }
    else if(self.updateSource == REMCustomerUserConcurrencySourceUpdate){
        msg = [NSLocalizedString(@"Setting_UpdateFailed", @"") stringByAppendingString:msg];
    }
    
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
    
    context.buildingInfoArray=[REMBuildingOverallModel sortByProvince:self.buildingInfoArray];
    
    NSString *parameterString = [REMServiceAgent buildParameterString:self.parameter];
    NSData *postData = [parameterString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *storageKey = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    context.buildingInfoArrayStorageKey=storageKey;
    
    if (self.customerInfoArray!=nil) {
        //context.currentUser.customers=self.customerInfoArray;
        
        //[context.currentUser updateInnerDictionary];
        //[context.currentUser save];
    }
    else{
        self.customerInfoArray=context.currentManagedUser.customers.allObjects;
    }
    REMManagedCustomerModel *current=REMAppCurrentManagedCustomer;
    NSNumber *newCustomerId = self.selectedCustomerId;
    if (newCustomerId==nil) {
        newCustomerId = self.currentCustomerId;
    }
    for (REMManagedCustomerModel *customer in self.customerInfoArray) {
        if ([customer.id isEqualToNumber:newCustomerId]==YES && [customer isEqual:current]==NO) {
            context.currentManagedCustomer=customer;
            customer.isCurrent=@(YES);
            //[context.currentCustomer updateInnerDictionary];
            //[context.currentCustomer save];
        }
    }
    
    [self persistCustomer];
    [self persistBuilding];
    self.tableViewController=nil;
    context.updateManager=nil;
    self.callback(REMCustomerUserConcurrencyStatusSuccess,self.buildingInfoArray,REMDataAccessFailed);
    
    
}

- (void)persistBuilding{
    
}

- (void)persistCustomer{
    REMDataStore *store = [[REMDataStore alloc]init];
    REMManagedUserModel *user = [[store fetchMangedObject:@"REMManagedUserModel"] lastObject];
//
//    
//    for (int i=0; i<self.customerInfoArray.count; ++i) {
//        REMManagedCustomerModel *currentCustomer = self.customerInfoArray[i];
//        REMManagedCustomerModel *customerObject = [store newManagedObject:@"REMManagedCustomerModel"];
//        
//        customerObject.id = currentCustomer.id;
//        customerObject.name=currentCustomer.name;
//        customerObject.code=currentCustomer.code;
//        customerObject.address=currentCustomer.address;
//        customerObject.email=currentCustomer.email;
//        customerObject.manager=currentCustomer.manager;
//        customerObject.telephone=currentCustomer.telephone;
//        customerObject.comment= currentCustomer.comment;
//        customerObject.timezoneId=currentCustomer.timezoneId;
//        customerObject.logoId=currentCustomer.logoId;
//        
//        customerObject.startTime= currentCustomer.startTime;
//        customerObject.user = user;
//        NSArray *administrators=currentCustomer.administrators.allObjects;
//        
//        
//        for (REMManagedAdministratorModel *admin in administrators) {
//            REMManagedAdministratorModel *adminObject= [[REMManagedAdministratorModel alloc]init];
//            adminObject.realName=admin.realName;
//            adminObject.customer=customerObject;
//            [customerObject addAdministratorsObject:adminObject];
//        }
//    }
    REMAppCurrentManagedUser = user;
    [store persistManageObject];

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
    context.updateManager=nil;
}

+ (void)cancelUpdateAll:(void (^)(void))callback
{
    [REMDataStore cancelAccess:customerUpdateAll];
    REMApplicationContext *context=REMAppContext;
    context.updateManager=nil;
    if (callback!= nil) {
        callback();
    }
}

@end
