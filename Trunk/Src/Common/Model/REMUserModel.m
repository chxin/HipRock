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
