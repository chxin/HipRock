/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMCustomerSwitchHelper.h
 * Created      : tantan on 10/8/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
