//
//  REMAlertHelper.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by zhangfeng on 7/4/13.
//
//

#import <Foundation/Foundation.h>

@interface REMAlertHelper : NSObject

+(void) alert: (NSString *) message;

+(void) alert: (NSString *) message withTitle: (NSString *) title;

@end
