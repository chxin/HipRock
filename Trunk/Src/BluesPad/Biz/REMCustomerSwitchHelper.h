//
//  REMCustomerSwitchHelper.h
//  Blues
//
//  Created by tantan on 10/8/13.
//
//

#import <Foundation/Foundation.h>

typedef enum _REMCustomerSwitchStatus {
    REMCustomerSwitchStatusSuccess = 0,
    REMCustomerSwitchStatusCurrentCustomerDeleted = 1,
    REMCustomerSwitchStatusSelectedCustomerDeleted=2,
    REMCustomerSwitchStatusBothDeleted=3
} REMCustomerSwitchStatus;

@interface REMCustomerSwitchHelper : NSObject

+ (void)switchCustomerById:(NSNumber *)selectedCustomerId masker:(UIView *)view action:(void(^)(REMCustomerSwitchStatus,NSArray *))callback;

+ (void)cancelSwitch;

@end
