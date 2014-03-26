/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMLoginPersistenceProcessor.m
 * Date Created : tantan on 2/18/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMLoginPersistenceProcessor.h"
#import "REMUserValidationModel.h"
#import "REMManagedUserModel.h"
#import "REMManagedAdministratorModel.h"
#import "REMManagedCustomerModel.h"


@implementation REMLoginPersistenceProcessor

#pragma mark - Data persistence processor

- (REMUserValidationModel *)persist:(NSDictionary *)data
{
    REMUserValidationStatus status = (REMUserValidationStatus)[data[@"ValidationStatus"] intValue];
    REMUserValidationModel *model= [[REMUserValidationModel alloc]init];
    model.status = status;
    if (status==REMUserValidationSuccess) {
         model.managedUser = [self persistUserModel:data[@"User"]];
    }
    return model;
}

- (REMUserValidationModel *)fetch{
    NSArray *array =  [self fetch:[REMManagedUserModel class]];
    if (array == nil || [array lastObject]==nil) {
        return nil;
    }
    return array[0];
}

#pragma mark - @private

- (REMManagedUserModel *)persistUserModel:(NSDictionary *)user{
    
    REMManagedUserModel *oldUser = [self fetch];
    
    if (oldUser != nil) {
        [self delete:oldUser];
    }
    
    
    REMManagedUserModel *userObject= [self create:[REMManagedUserModel class]];
    
    userObject.id=user[@"Id"];
    userObject.name=user[@"Name"];
    userObject.comment=user[@"Comment"];
    userObject.email=user[@"Email"];
    userObject.password=user[@"Password"];
    userObject.realname=user[@"RealName"];
    userObject.telephone=user[@"Telephone"];
    userObject.title=user[@"Title"];
    userObject.userTypeName= NULL_TO_NIL(user[@"UserTypeName"]);
    userObject.version = user[@"Version"];
    userObject.spId = user[@"SpId"];
    userObject.isDemo = user[@"DemoStatus"];
    
    NSArray *array = (NSArray *)user[@"Customers"];
    for(NSDictionary *customer in array)
    {
        [self addCustomer:customer intoUserObject:userObject];
    }
    
    [self save];
    
    //id newData= [self fetchData];
    
    return userObject;

}
- (void)addCustomer:(NSDictionary *)customer intoUserObject:(REMManagedUserModel *)userObject
{
    REMManagedCustomerModel *customerObject= [self create:[REMManagedCustomerModel class]];
    
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
        [self addAdministrator:admin intoUserObject:customerObject];
    }
    customerObject.user=userObject;
    [userObject addCustomersObject:customerObject];
}

- (void)addAdministrator:(NSDictionary *)admin intoUserObject:(REMManagedCustomerModel *)customerObject
{
    REMManagedAdministratorModel *adminObject= [self create:[REMManagedAdministratorModel class]];
    adminObject.realName=admin[@"RealName"];
    adminObject.customer=customerObject;
    [customerObject addAdministratorsObject:adminObject];
}

@end
