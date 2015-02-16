/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMJSONHelper.h
 * Created      : TanTan on 7/3/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMLog.h"  


@interface REMJSONHelper : NSObject


+ (id)objectByString:(NSString *)json;
+ (NSString *)stringByObject:(id)object;

+ (id)duplicateObject:(id)object;

@end
