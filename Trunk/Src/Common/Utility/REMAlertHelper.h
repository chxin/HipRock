/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMAlertHelper.h
 * Created      : zhangfeng on 7/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>

@interface REMAlertHelper : NSObject

+(void) alert: (NSString *) message;

+(void) alert: (NSString *) message withTitle: (NSString *) title;

@end
