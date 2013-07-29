//
//  REMAlertHelper.m
//  Blues
//
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
