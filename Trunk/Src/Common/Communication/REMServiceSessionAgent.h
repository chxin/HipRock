//
//  REMServiceSessionAgent.h
//  Blues
//
//  Created by 张 锋 on 3/3/14.
//
//

#import <Foundation/Foundation.h>

@interface REMServiceSessionAgent : NSObject

@end

@interface REMURLSession : NSURLSession

@property (nonatomic,strong) NSString *group;

@end