/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMAlertHelper.m
 * Created      : zhangfeng on 7/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
