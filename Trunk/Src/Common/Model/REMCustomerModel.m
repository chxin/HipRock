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

-(void)updateInnerDictionary
{
    [self.innerDictionary setValue:self.customerId forKey:@"Id"];
    [self.innerDictionary setValue:self.name forKey:@"Name"];
    [self.innerDictionary setValue:self.code forKey:@"Code"];
    [self.innerDictionary setValue:self.address forKey:@"Address"];
    [self.innerDictionary setValue:self.email forKey:@"Email"];
    [self.innerDictionary setValue:self.manager forKey:@"Manager"];
    [self.innerDictionary setValue:self.telephone forKey:@"Telephone"];
    [self.innerDictionary setValue:self.comment forKey:@"Comment"];
    [self.innerDictionary setValue:self.timezoneId forKey:@"TimezoneId"];
    [self.innerDictionary setValue:self.logoId forKey:@"logoId"];
    [self.innerDictionary setValue:[REMTimeHelper jsonStringFromDate:self.startTime] forKey:@"StartTime"];
    [self.innerDictionary setValue:self.administratorArray forKey:@"Administrators"];
}


@end
