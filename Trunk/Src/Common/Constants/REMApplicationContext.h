//
//  REMApplicationContext.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 7/29/13.
//
//

#import <Foundation/Foundation.h>
#import "REMUserModel.h"
#import "REMCustomerModel.h"

@interface REMApplicationContext : NSObject

@property (nonatomic,strong) REMUserModel *currentUser;
@property (nonatomic,strong) REMCustomerModel *currentCustomer;
@property (nonatomic,strong) UIImage *currentCustomerLogo;

+ (REMApplicationContext *)instance;


@end
