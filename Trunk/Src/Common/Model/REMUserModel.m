//
//  REMUser.m
//  Blues
//
//  Created by 张 锋 on 7/29/13.
//
//

#import "REMUserModel.h"
#import "REMCustomerModel.h"

@implementation REMUserModel

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    
    self.userId=(long long)dictionary[@"Id"];
    self.name=dictionary[@"Name"];
    self.comment=dictionary[@"Comment"];
    self.email=dictionary[@"Email"];
    self.password=dictionary[@"Password"];
    self.realname=dictionary[@"RealName"];
    self.telephone=dictionary[@"Telephone"];
    self.title=(NSInteger)dictionary[@"Title"];
    self.userTypeName=dictionary[@"UserTypeName"];
    self.version = dictionary[@"Version"];
    
    NSArray *array = (NSArray *)dictionary[@"Customers"];
    NSMutableArray *customers = [[NSMutableArray alloc] initWithCapacity:array.count];
    for(NSDictionary *customerJson in array)
    {
        [customers addObject:[[REMCustomerModel alloc] initWithDictionary:customerJson]];
    }
    
    self.customers = customers;
}
@end
