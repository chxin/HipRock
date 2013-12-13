/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMCustomer.h
 * Created      : 张 锋 on 7/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
