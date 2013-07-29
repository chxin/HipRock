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


+ (NSDictionary *)dictionaryByJSONString:(NSString *)jsonString;
+ (NSString *)stringByDictionary:(NSDictionary *)dictionary;

@end
