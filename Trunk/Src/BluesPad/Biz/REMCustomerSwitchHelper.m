//
//  REMCustomerSwitchHelper.m
//  Blues
//
//  Created by tantan on 10/8/13.
//
//

#import "REMCustomerSwitchHelper.h"
#import "REMApplicationContext.h"
#import "REMCustomerModel.h"
#import "REMDataAccessor.h"
@implementation REMCustomerSwitchHelper

static NSString *customerSwitchKey=@"customerswitch";

+(void)switchCustomerById:(NSNumber *)selectedCustomerId masker:(UIView *)view action:(void (^)(REMCustomerSwitchStatus, NSArray *))callback {
    REMCustomerModel *currentCustomer = [REMApplicationContext instance].currentCustomer;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dic setObject:selectedCustomerId forKey:@"selectedCustomerId"];
    if(currentCustomer!=nil){
        [dic setObject:currentCustomer.customerId forKey:@"currentCustomerId"];
    }
    REMDataStore *store =[[REMDataStore alloc]initWithName:REMDSCustomerSwitch parameter:dic];
    store.maskContainer=view;
    store.groupName =customerSwitchKey;
    [REMDataAccessor access: store success:^(NSDictionary *data){
        NSNumber *statusNumber=data[@"Status"];
        REMCustomerSwitchStatus status=(REMCustomerSwitchStatus)[statusNumber integerValue];
        NSArray *newList = data[@"Customers"];
        NSMutableArray *customerList=nil;
        if(newList!=nil && [newList isEqual:[NSNull null]]==NO){
            customerList = [[NSMutableArray alloc]initWithCapacity:newList.count];
            for (NSDictionary *obj in newList) {
                REMCustomerModel *model=[[REMCustomerModel alloc]initWithDictionary:obj];
                [customerList addObject:model];
            }
        }
        callback(status,customerList);
    }];
    
}

+ (void)cancelSwitch
{
    [REMDataAccessor cancelAccess:customerSwitchKey];
}

@end
