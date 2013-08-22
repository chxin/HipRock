//
//  REMServiceAgent.h
//  Blues
//
//  Created by zhangfeng on 7/5/13.
//
//

#import <Foundation/Foundation.h>
#import "REMServiceMeta.h"

typedef void(^REMServiceCallSuccessBlock)(id data);
typedef void(^REMServiceCallErrorBlock)(NSError *error, id response);
typedef void(^REMServiceCallProgressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);

@interface REMServiceAgent : NSObject


+ (void) call: (REMServiceMeta *) service withBody:(id)body mask:(UIView *) maskContainer group:(NSString *)groupName store:(BOOL) isStore success:(REMServiceCallSuccessBlock)success error:(REMServiceCallErrorBlock)error progress:(REMServiceCallProgressBlock)progress;

+ (void) cancel;
+ (void) cancel: (NSString *) group;

+ (NSString *)buildParameterString: (id)parameter;
+ (NSDictionary *)deserializeResult:(NSString *)resultJson ofService:(NSString *)service;

@end
