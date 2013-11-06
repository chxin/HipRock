/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMApplicationContext.h
 * Created      : 张 锋 on 7/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMUserModel.h"
#import "REMCustomerModel.h"

#define REMAppContext [REMApplicationContext instance]
#define REMAppCurrentUser REMAppContext.currentUser
#define REMAppCurrentCustomer REMAppContext.currentCustomer
#define REMAppCurrentLogo REMAppContext.currentCustomerLogo

@interface REMApplicationContext : NSObject

@property (nonatomic,strong) REMUserModel *currentUser;
@property (nonatomic,strong) REMCustomerModel *currentCustomer;
@property (nonatomic,strong) UIImage *currentCustomerLogo;

+ (REMApplicationContext *)instance;


@end
