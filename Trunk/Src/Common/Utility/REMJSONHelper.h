//
//  REMJSONHelper.h
//  Blues
//
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
