/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMApplicationContext.m
 * Created      : 张 锋 on 7/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMApplicationContext.h"
#import "REMAppConfiguration.h"

@implementation REMApplicationContext

static REMApplicationContext *context = nil;

+ (REMApplicationContext *)instance
{
    if(context == nil){
        @synchronized(self){
            context = [[REMApplicationContext alloc] init];
        }
    }
    
    return context;
}

+ (void)recover
{
    REMUserModel *storedUser = [REMUserModel getCached];
    REMCustomerModel *storedCustomer = [REMCustomerModel getCached];
    
    [REMAppContext setCurrentUser:storedUser];
    [REMAppContext setCurrentCustomer:storedCustomer];
}

+ (void)destroy
{
    context = nil;
}

-(REMApplicationContext *)init
{
    self = [super init];
    
    if(self){
        self.appConfig = [[REMAppConfiguration alloc] init];
    }
    
    return self;
}


@end
