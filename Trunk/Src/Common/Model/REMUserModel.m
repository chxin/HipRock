//
//  REMUser.m
//  Blues
//
//  Created by 张 锋 on 7/29/13.
//
//

#import "REMUserModel.h"
#import "REMCustomerModel.h"
#import "REMStorage.h"
#import "REMApplicationInfo.h"

@implementation REMUserModel

static NSString *kCurrentUserCacheKey = @"CurrentUser";

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.userId=[dictionary[@"Id"] longLongValue];
    self.name=dictionary[@"Name"];
    self.comment=dictionary[@"Comment"];
    self.email=dictionary[@"Email"];
    self.password=dictionary[@"Password"];
    self.realname=dictionary[@"RealName"];
    self.telephone=dictionary[@"Telephone"];
    self.title=[dictionary[@"Title"] intValue];
    self.userTypeName=dictionary[@"UserTypeName"];
    self.version = dictionary[@"Version"];
    self.spId = [dictionary[@"SpId"] longLongValue];
    
    NSArray *array = (NSArray *)dictionary[@"Customers"];
    NSMutableArray *customers = [[NSMutableArray alloc] initWithCapacity:array.count];
    for(NSDictionary *customerJson in array)
    {
        [customers addObject:[[REMCustomerModel alloc] initWithDictionary:customerJson]];
    }
    
    self.customers = customers;
}

- (void)updateInnerDictionary{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:12];
    dic[@"Id"]=[NSNumber numberWithLongLong: self.userId];
    dic[@"Name"]=self.name;
    dic[@"Comment"]=self.comment;
    dic[@"Email"]=self.email;
    dic[@"Password"]=self.password;
    dic[@"RealName"]=self.realname;
    dic[@"Telephone"]=self.telephone;
    dic[@"Title"]= @(self.title);
    dic[@"UserTypeName"]=self.userTypeName;
    dic[@"Version"]=self.version;
    dic[@"SpId"]=@(self.spId);
    for (int i=0; i<self.customers.count;i++) {
        REMCustomerModel *model = self.customers[i];
    }
    
    
}


- (void)save
{
    [REMStorage set:[REMApplicationInfo getApplicationCacheKey] key:kCurrentUserCacheKey value:[self serialize] expired:REMNeverExpired];
}

- (void)kill
{
    [REMStorage set:[REMApplicationInfo getApplicationCacheKey] key:kCurrentUserCacheKey value:@"" expired:REMNeverExpired];
}

+ (REMUserModel *)getCached
{
    NSDictionary *dictionary = [REMJSONHelper objectByString:[REMStorage get:[REMApplicationInfo getApplicationCacheKey] key:kCurrentUserCacheKey]];
    return [[REMUserModel alloc] initWithDictionary:dictionary];
}

@end
