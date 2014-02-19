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

- (id)persistData:(NSDictionary *)data
{
    REMUserValidationStatus status = (REMUserValidationStatus)[data[@"ValidationStatus"] intValue];
    if (status!=REMUserValidationSuccess) {
        REMUserValidationModel *model= [[REMUserValidationModel alloc]init];
        model.status = status;
        return model;
    }
    else{
        return [self persistUserModel:data[@"User"]];
    }
}

- (id)fetchData{
    

}

- (id)persistUserModel:(NSDictionary *)user{
    
    REMManagedUserModel *oldUser = [self fetchData];
    
    
    
    
    REMManagedUserModel *userObject= [self.dataStore newManagedObject:@"REMManagedUserModel"];
    
    userObject.id=user[@"Id"];
    userObject.name=user[@"Name"];
    userObject.comment=user[@"Comment"];
    userObject.email=user[@"Email"];
    userObject.password=user[@"Password"];
    userObject.realname=user[@"RealName"];
    userObject.telephone=user[@"Telephone"];
    userObject.title=user[@"Title"];
    userObject.userTypeName=user[@"UserTypeName"];
    userObject.version = user[@"Version"];
    userObject.spId = user[@"SpId"];
    userObject.isDemo = user[@"DemoStatus"];
    
    NSArray *array = (NSArray *)user[@"Customers"];
    NSMutableArray *customers = [[NSMutableArray alloc] initWithCapacity:array.count];
    for(NSDictionary *customerJson in array)
    {
        [customers addObject:[[REMCustomerModel alloc] initWithDictionary:customerJson]];
    }


}

@end
