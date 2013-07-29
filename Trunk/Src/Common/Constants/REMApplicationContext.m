//
//  REMApplicationContext.m
//  Blues
//
//  Created by 张 锋 on 7/29/13.
//
//

#import "REMApplicationContext.h"

@implementation REMApplicationContext

static REMApplicationContext *context = nil;

+ (REMApplicationContext *)instance
{
    if(context == nil)
        context = [[REMApplicationContext alloc] init];
    
    return context;
}

@end
