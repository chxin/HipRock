//
//  REMAlertHelper.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by zhangfeng on 7/4/13.
//
//

#import "REMAlertHelper.h"

@implementation REMAlertHelper

+(void) alert: (NSString *) message
{
    [REMAlertHelper alert:message withTitle:Nil];
}

+(void) alert: (NSString *) message withTitle: (NSString *) title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
