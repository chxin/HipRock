//
//  REMCustomer.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 7/29/13.
//
//

#import <Foundation/Foundation.h>
#import "REMJSONObject.h"

@interface REMCustomerModel : REMJSONObject

@property (nonatomic,strong) NSNumber *customerId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *manager;
@property (nonatomic,strong) NSString *telephone;
@property (nonatomic,strong) NSString *comment;
@property (nonatomic,strong) NSNumber *timezoneId;
@property (nonatomic,strong) NSNumber *logoId;
@property (nonatomic,strong) NSDate *startTime;
@property (nonatomic,strong) NSArray *administratorArray;


- (void)save;
- (void)kill;
+ (REMCustomerModel *)getCached;

@end
