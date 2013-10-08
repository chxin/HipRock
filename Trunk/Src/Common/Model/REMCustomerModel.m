//
//  REMCustomer.m
//  Blues
//
//  Created by 张 锋 on 7/29/13.
//
//

#import "REMCustomerModel.h"
#import "REMStorage.h"
#import "REMApplicationInfo.h"
#import "REMJSONHelper.h"
#import "REMTimeHelper.h"
#import "REMAdministratorModel.h"

@implementation REMCustomerModel

static NSString *kCurrentCustomerCacheKey = @"CurrentCustomer";

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.customerId = dictionary[@"Id"];
    self.name=dictionary[@"Name"];
    self.code=dictionary[@"Code"];
    self.address=dictionary[@"Address"];
    self.email=dictionary[@"Email"];
    self.manager=dictionary[@"Manager"];
    self.telephone=dictionary[@"Telephone"];
    self.comment=dictionary[@"Comment"];
    self.timezoneId=dictionary[@"TimezoneId"];
    self.logoId=dictionary[@"logoId"];
    long long time=[REMTimeHelper longLongFromJSONString:dictionary[@"StartTime"]];
    self.startTime= [NSDate dateWithTimeIntervalSince1970:time/1000 ];
    
    NSArray *administrators=dictionary[@"Administrators"];
    
    
    NSMutableArray *administratorArray=[[NSMutableArray alloc]initWithCapacity:administrators.count];
    
    for (NSDictionary *admin in administrators) {
        REMAdministratorModel *model = [[REMAdministratorModel alloc]initWithDictionary:admin];
        [administratorArray addObject:model];
    }
    
    self.administratorArray=administratorArray;
    
}

- (void)save
{
    [REMStorage set:[REMApplicationInfo getApplicationCacheKey] key:kCurrentCustomerCacheKey value:[self serialize] expired:REMNeverExpired];
}

- (void)kill
{
    [REMStorage set:[REMApplicationInfo getApplicationCacheKey] key:kCurrentCustomerCacheKey value:@"" expired:REMNeverExpired];
}

+ (REMCustomerModel *)getCached
{
    NSDictionary *dictionary = [REMJSONHelper objectByString:[REMStorage get:[REMApplicationInfo getApplicationCacheKey] key:kCurrentCustomerCacheKey]];
    return [[REMCustomerModel alloc] initWithDictionary:dictionary];
}

@end
