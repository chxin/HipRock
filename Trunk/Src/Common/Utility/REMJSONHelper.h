//
//  REMJSONHelper.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by TanTan on 7/3/13.
//
//

#import <Foundation/Foundation.h>
#import "REMLog.h"  


@interface REMJSONHelper : NSObject


+ (id)objectByString:(NSString *)json;
+ (NSString *)stringByObject:(id)object;

+ (id)duplicateObject:(id)object;

@end
