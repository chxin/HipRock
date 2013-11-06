/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMCustomer.m
 * Created      : 张 锋 on 7/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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

-(NSDictionary *)updateInnerDictionary
{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:12];
    
    dic[@"Id"]=self.customerId;
    dic[@"Name"]=self.name;
    dic[@"Code"]=self.code;
    dic[@"Address"]=self.address;
    dic[@"Email"]=self.email;
    dic[@"Manager"]=self.manager;
    dic[@"Telephone"]=self.telephone;
    dic[@"Comment"]=self.comment;
    dic[@"TimezoneId"]=self.timezoneId;
    if(self.logoId!=nil){
        dic[@"logoId"]=self.logoId;
    }
    dic[@"StartTime"]=[REMTimeHelper jsonStringFromDate:self.startTime];
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:self.administratorArray.count];
    for (int i=0; i<self.administratorArray.count; ++i) {
        REMAdministratorModel *m = self.administratorArray[i];
        NSDictionary *d= [m updateInnerDictionary];
        [array addObject:d];
    }
    dic[@"Administrators"]=array;

    self.innerDictionary=dic;
    
    return self.innerDictionary;
}


@end
