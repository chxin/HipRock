//
//  REMCustomer.m
//  Blues
//
//  Created by 张 锋 on 7/29/13.
//
//

#import "REMCustomerModel.h"

@implementation REMCustomerModel

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
}

@end
