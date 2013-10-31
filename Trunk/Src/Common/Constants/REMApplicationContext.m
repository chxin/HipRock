//
//  REMApplicationContext.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 7/29/13.
//
//

#import "REMApplicationContext.h"

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


@end
