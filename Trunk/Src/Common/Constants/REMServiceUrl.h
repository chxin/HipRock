//
//  REMServiceUrl.h
//  Blues
//
//  Created by zhangfeng on 7/1/13.
//
//

#import <Foundation/Foundation.h>



//http://localhost/data/login.json

//commodity & uom



@interface REMServiceUrl : NSObject


+ (NSString *)absoluteUrl: (NSString *)relativeUrl;

@end
