//
//  REMServiceAgent.h
//  Blues
//
//  Created by zhangfeng on 7/5/13.
//
//

#import <Foundation/Foundation.h>

@interface REMServiceAgent : NSObject

+ (void) call: (NSString *) serviceName withBody:(id)body mask:(UIView *) maskContainer group:(NSString *)groupName store:(BOOL) isStore success:(void (^)(id data))success error:(void (^)(NSError *error, id response))error progress:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progress;

+ (void) cancel;
+ (void) cancel: (NSString *) group;

+ (NSString *)buildParameterString: (id)parameter;
+ (NSDictionary *)deserializeResult:(NSString *)resultJson ofService:(NSString *)service;

@end
