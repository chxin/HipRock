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
    [REMAlertHelper alert:message withTitle:nil];
}

+(void) alert: (NSString *) message delegate:(id)delegate
{
    [REMAlertHelper alert:message withTitle:nil delegate:delegate];
}

+(void) alert: (NSString *) message withTitle: (NSString *) title
{
    [REMAlertHelper alert:message withTitle:title delegate:nil];
}

+(void) alert: (NSString *) message withTitle: (NSString *) title  delegate:(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:REMIPadLocalizedString(@"Common_OK") otherButtonTitles:nil];
    [alert show];
}

@end
